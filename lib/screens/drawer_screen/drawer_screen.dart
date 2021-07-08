import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http_demo/blocs/drawer_bloc.dart';
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
  DrawerBloc drawerBloc = DrawerBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  child: CustomAvatar(url: snapshot.data ?? "", size: 120),
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
            print('View Avatar');
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

  void selectPhoto(ImageSource imageSource) async {
    final progress = ProgressDialog(context: context);

    try {
      PickedFile? pickedFile = await _picker.getImage(
        maxWidth: 500,
        maxHeight: 500,
        source: imageSource,
        imageQuality: 100,
      );
      if (pickedFile != null) {
        progress.show();
        await drawerBloc.uploadAvatar(File(pickedFile.path));
        progress.hide();
      } else {
        print('_DrawerScreenState.selectPhoto false');
      }
    } catch (e) {
      print('Bạn không đủ quyền truy cập');
    }
  }
}
