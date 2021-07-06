import 'dart:async';

import 'package:http_demo/models/issue.dart';
import 'package:http_demo/services/api_service.dart';
import 'package:http_demo/services/Issue_service.dart';

class IssueBloc {
  final _streamController = StreamController<List<Issue>>();

  Stream<List<Issue>> get stream => _streamController.stream;
  var issues = <Issue>[];

  IssueBloc();

  void dispose() {
    _streamController.close();
  }

  Future getIssues({
    int offset = 0,
  }) async {
    await apiService.getIssues(
      offset: offset,
      onSuccess: (data) {
        issues = data;
        _streamController.sink.add(issues);
      },
      onFailure: (error) {
        _streamController.addError(error);
      },
    );
  }
}
