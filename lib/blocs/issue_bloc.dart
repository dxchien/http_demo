import 'dart:async';

import 'package:http_demo/models/issue.dart';
import 'package:http_demo/services/api_service.dart';
import 'package:http_demo/services/Issue_service.dart';

class IssueBloc {
  final _issuesStreamCtrl = StreamController<List<Issue>>();
  final _isLoadMoreStreamCtrl = StreamController<bool>();

  Stream<List<Issue>> get issueStream => _issuesStreamCtrl.stream;

  Stream<bool> get isLoadMoreStream => _isLoadMoreStreamCtrl.stream;

  var issues = <Issue>[];

  IssueBloc();

  void dispose() {
    _issuesStreamCtrl.close();
    _isLoadMoreStreamCtrl.close();
  }

  Future getIssues({bool isRefresh = false}) async {
    _isLoadMoreStreamCtrl.add(true);

    await apiService.getIssues(
      offset: isRefresh ? 0 : issues.length,
      onSuccess: (data) {
        if (isRefresh) {
          issues.clear();
        }
        if (data.length > 0) {
          issues.addAll(data);
          _issuesStreamCtrl.add(issues);
        } else if (isRefresh) {
          _issuesStreamCtrl.add(issues);
        }
      },
      onFailure: (error) {
        _issuesStreamCtrl.addError(error);
      },
    );

    _isLoadMoreStreamCtrl.add(false);
  }
}
