import 'dart:async';
import 'dart:io';

import 'package:http_demo/services/api_service.dart';
import 'package:http_demo/services/drawer_service.dart';
import 'package:http_demo/utils/constant.dart';

class DrawerBloc {
  final _avatarStreamCtrl = StreamController<String>();
  late File selectedImage;

  Stream<String> get avatarStream => _avatarStreamCtrl.stream;

  DrawerBloc();

  String getCurrentAvatar() {
    return loggedUser.avatar ?? defaultAvatar;
  }

  void dispose() {
    _avatarStreamCtrl.close();
  }

  Future uploadAvatar() async {
    await apiService.uploadAvatar(
      file: selectedImage,
      onSuccess: (data) {
        _avatarStreamCtrl.add(data);
        loggedUser.avatar = data;
      },
      onFailure: (error) {
        _avatarStreamCtrl.addError(error);
      },
    );
  }
}
