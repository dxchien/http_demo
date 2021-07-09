import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http_demo/blocs/drawer_bloc.dart';
import 'package:http_demo/screens/photo_screen.dart';
import 'package:http_demo/utils/navigator.dart';
import 'package:http_demo/widgets/custom_avatar.dart';
import 'package:http_demo/widgets/dialogs/progess_dialog.dart';
import 'package:http_demo/widgets/show_value_bottom_sheet.dart';
import 'package:image_picker/image_picker.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  final _picker = ImagePicker();
  final drawerBloc = DrawerBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black12,
      padding: EdgeInsets.all(10),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            StreamBuilder<String>(
              stream: drawerBloc.avatarStream,
              builder: (ctx, snapshot) {
                return GestureDetector(
                  onTap: changeAvatarAction,
                  child: CustomAvatar(url: drawerBloc.getCurrentAvatar(), size: 120),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void changeAvatarAction() {
    final values = [
      'Xem hình đại diện',
      'Chụp hình',
      'Chọn ảnh',
    ];
    showValueBottomSheet(
      context: context,
      values: values,
      onSelected: (index, value) {
        Navigator.of(context).pop();
        switch (index) {
          case 0:
            viewPhoto();
            break;
          case 1:
            selectPhoto(ImageSource.camera);
            break;
          case 2:
            selectPhoto(ImageSource.gallery);
            break;
        }
      },
    );
  }

  void viewPhoto() {
    navigatorPush(context, PhotoScreen(path: drawerBloc.getCurrentAvatar()));
  }

  void selectPhoto(ImageSource imageSource) async {
    try {
      PickedFile? pickedFile = await _picker.getImage(
        maxWidth: 500,
        maxHeight: 500,
        source: imageSource,
        imageQuality: 100,
      );
      if (pickedFile != null) {
        drawerBloc.selectedImage = File(pickedFile.path);
        navigatorPush(
          context,
          PhotoScreen(
            path: pickedFile.path,
            action: uploadAvatar,
            actionLabel: "Lưu",
          ),
        );
      } else {
        print('_DrawerScreenState.selectPhoto false');
      }
    } catch (e) {
      print('Bạn không đủ quyền truy cập');
    }
  }

  void uploadAvatar() async {
    final progress = ProgressDialog(context: context);
    progress.show();
    await drawerBloc.uploadAvatar();
    progress.hide();
    Navigator.of(context).pop();
  }
}
