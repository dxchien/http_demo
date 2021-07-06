import 'dart:async';

import 'package:http_demo/models/user.dart';
import 'package:http_demo/services/api_service.dart';
import 'package:http_demo/services/user_service.dart';

class UserBloc {
  final _streamController = StreamController<List<User>>();

  Stream<List<User>> get stream => _streamController.stream;
  var users = <User>[];

  UserBloc() {}

  void dispose() {
    _streamController.close();
  }

  void getUsers() {
    apiService.getUsers(
      onSuccess: (data) {
        users = data;
        _streamController.sink.add(users);
      },
      onFailure: (error) {
        _streamController.addError(error);
      },
    );
  }
}
