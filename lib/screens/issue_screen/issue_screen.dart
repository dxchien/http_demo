import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http_demo/blocs/issue_bloc.dart';
import 'package:http_demo/models/issue.dart';
import 'package:http_demo/screens/issue_screen/list_issue.dart';
import 'package:http_demo/utils/color.dart';
import 'package:http_demo/utils/system.dart';
import 'package:http_demo/widgets/custom_app_bar.dart';

class IssueScreen extends StatefulWidget {
  const IssueScreen({Key? key}) : super(key: key);

  @override
  _IssueScreenState createState() => _IssueScreenState();
}

class _IssueScreenState extends State<IssueScreen> {
  final _controller = ScrollController();
  final bloc = IssueBloc();
  List<Issue> issues = <Issue>[];
  bool isLoadingMore = false;

  Future<void> refreshData() async {
    issues.clear();
    bloc.getIssues();
  }

  Future<void> getMoreData(int offset) async {
    if (isLoadingMore) {
      return;
    }

    setState(() {
      isLoadingMore = true;
    });

    await bloc.getIssues(offset: offset);

    setState(() {
      isLoadingMore = false;
    });
  }

  @override
  void initState() {
    bloc.getIssues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
    );
  }

  Widget buildBody() {
    return StreamBuilder<List<Issue>>(
      stream: bloc.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (!isLoadingMore) {
            issues.addAll(snapshot.data!);
          }

          return Stack(
            children: [
              buildList(),
              buildBottomLoader(),
            ],
          );
        }

        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget buildList() {
    return Container(
      child: RefreshIndicator(
        onRefresh: refreshData,
        child: NotificationListener<ScrollUpdateNotification>(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 10),
            controller: _controller,
            itemBuilder: (ctx, index) {
              return buildItem(ctx, issues[index]);
            },
            itemCount: issues.length,
          ),
          onNotification: (scrollEnd) {
            var metrics = scrollEnd.metrics;
            if (metrics.atEdge && metrics.pixels != 0) {
              getMoreData(issues.length);
            }
            return true;
          },
        ),
      ),
    );
  }

  Widget buildBottomLoader() {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 200),
      curve: Curves.fastOutSlowIn,
      bottom: isLoadingMore ? 0 : -20,
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
}
