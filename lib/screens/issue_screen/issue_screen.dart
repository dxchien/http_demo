import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http_demo/blocs/account_bloc.dart';
import 'package:http_demo/blocs/issue_bloc.dart';
import 'package:http_demo/models/issue.dart';
import 'package:http_demo/screens/drawer_screen/drawer_screen.dart';
import 'package:http_demo/screens/issue_screen/list_issue.dart';
import 'package:http_demo/utils/color.dart';
import 'package:http_demo/utils/system.dart';
import 'package:http_demo/widgets/custom_app_bar.dart';
import 'package:lottie/lottie.dart';

class IssueScreen extends StatefulWidget {
  const IssueScreen({Key? key}) : super(key: key);

  @override
  _IssueScreenState createState() => _IssueScreenState();
}

class _IssueScreenState extends State<IssueScreen> {
  final _controller = ScrollController();
  final issueBloc = IssueBloc();
  final accountBloc = AccountBloc();

  Future<void> refreshData() async {
    issueBloc.getIssues(isRefresh: true);
  }

  @override
  void initState() {
    accountBloc.login();
    issueBloc.getIssues();
    super.initState();
  }

  @override
  void dispose() {
    issueBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('_IssueScreenState.build');

    return Scaffold(
      appBar: CustomAppBar(
        appBar: AppBar(
          title: Text("Sự cố"),
        ),
        onTap: () {
          _controller.animateTo(
            _controller.position.minScrollExtent,
            duration: Duration(seconds: 1),
            curve: Curves.fastOutSlowIn,
          );
        },
      ),
      body: buildBody(),
      drawer: Drawer(
        child: DrawerScreen(),
      ),
    );
  }

  Widget buildBody() {
    return StreamBuilder<List<Issue>>(
      stream: issueBloc.issueStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SafeArea(
            child: Stack(
              children: [
                buildList(),
                buildBottomLoader(),
              ],
            ),
          );
        }

        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }

        return Center(
          child: Lottie.asset("assets/progress.json", width: 100, height: 100),
        );
      },
    );
  }

  Widget buildList() {
    return Container(
      child: RefreshIndicator(
        onRefresh: refreshData,
        child: ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 10),
          controller: _controller,
          itemBuilder: (ctx, index) {
            if (index == issueBloc.issues.length - 1) {
              issueBloc.getIssues();
            }
            return buildItem(ctx, issueBloc.issues[index]);
          },
          itemCount: issueBloc.issues.length,
        ),
      ),
    );
  }

  Widget buildBottomLoader() {
    return StreamBuilder<bool>(
      stream: issueBloc.isLoadMoreStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return AnimatedPositioned(
            duration: Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            bottom: (snapshot.data ?? false) ? 0 : -20,
            child: Container(
              height: 20,
              color: Colors.black,
              width: getScreenWidth(context),
              child: Center(
                  child: Text(
                "Loading...",
                style: TextStyle(
                  color: colorGrey1,
                ),
              )),
            ),
          );
        }
        return SizedBox(height: 0);
      },
    );
  }
}
