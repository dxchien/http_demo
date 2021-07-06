import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http_demo/blocs/issue_bloc.dart';
import 'package:http_demo/models/issue.dart';
import 'package:http_demo/screens/issue_screen/list_issue.dart';
import 'package:http_demo/utils/system.dart';

class IssueScreen extends StatefulWidget {
  const IssueScreen({Key? key}) : super(key: key);

  @override
  _IssueScreenState createState() => _IssueScreenState();
}

class _IssueScreenState extends State<IssueScreen> {
  final bloc = IssueBloc();
  List<Issue> issues = <Issue>[];
  bool isLoadingMore = false;

  Future<void> refreshData() async {
    issues.clear();
    bloc.getIssues();
  }

  Future<void> getMoreData(int offset) async {
    print('getMoreData from $offset');
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
    issues.clear();
    bloc.getIssues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Issue List"),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return StreamBuilder<List<Issue>>(
      stream: bloc.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          issues.addAll(snapshot.data!);

          return Stack(
            children: [
              AnimatedPositioned(
                duration: Duration(milliseconds: 200),
                curve: Curves.fastOutSlowIn,
                bottom: isLoadingMore ? 0 : -20,
                child: Container(
                  height: 18,
                  color: Colors.grey,
                  width: getScreenWidth(context),
                  child: Center(child: Text("Loading...")),
                ),
              ),
              Container(
                child: RefreshIndicator(
                  onRefresh: refreshData,
                  child: NotificationListener<ScrollUpdateNotification>(
                    child: ListView.builder(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
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
              ),
            ],
          );
        }
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
