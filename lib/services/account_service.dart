import 'package:http_demo/models/account.dart';
import 'package:http_demo/services/api_service.dart';
import 'package:http_demo/utils/constant.dart';

extension AccountService on ApiService {
  Future login({
    required Function(Account) onSuccess,
    required Function(String) onFailure,
  }) async {
    Map<String, String> params = {
      "PhoneNumber": demoPhoneNumber,
      "Password": demoPassword,
    };

    await apiService.request(
      path: "/api/accounts/login",
      method: Method.post,
      parameters: params,
      onSuccess: (json) {
        final account = Account.fromJson(json);
        onSuccess(account);
      },
    );
  }
}
