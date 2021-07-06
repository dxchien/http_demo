import 'package:http_demo/models/user.dart';
import 'package:http_demo/services/api_service.dart';

extension UserService on ApiService {
  void getUsers({
    required Function(List<User>) onSuccess,
    required Function(String) onFailure,
  }) async {
    apiService.request(
      path: "/api/users",
      method: Method.get,
      onSuccess: (json) {
        final users = List<User>.from(json.map((e) => User.fromJson(e)));
        onSuccess(users);
      },
    );
  }
}
