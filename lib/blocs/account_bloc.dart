import 'dart:async';

import 'package:http_demo/models/account.dart';
import 'package:http_demo/services/api_service.dart';
import 'package:http_demo/services/account_service.dart';
import 'package:http_demo/utils/constant.dart';

class AccountBloc {
  AccountBloc();

  Future login() async {
    await apiService.login(
      onSuccess: (data) {
        loggedUser = data;
      },
      onFailure: (error) {
        print(error);
        return Account();
      },
    );
  }
}
