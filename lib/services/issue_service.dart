import 'package:http_demo/models/issue.dart';
import 'package:http_demo/services/api_service.dart';
import 'package:http_demo/utils/constant.dart';

extension IssueService on ApiService {
  Future getIssues({
    required int offset,
    required Function(List<Issue>) onSuccess,
    required Function(String) onFailure,
  }) async {
    await apiService.request(
      path: "/api/issues?limit=$rowPerPage&offset=$offset",
      method: Method.get,
      onSuccess: (json) {
        final issues = List<Issue>.from(json.map((e) => Issue.fromJson(e)));
        onSuccess(issues);
      },
      onFailure: (error) {
        print(error);
      },
    );
  }
}
