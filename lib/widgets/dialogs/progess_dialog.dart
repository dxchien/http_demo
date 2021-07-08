import 'package:flutter/material.dart';

import 'dialog_manager.dart';


class ProgressDialog {
  ProgressDialog({required BuildContext context}) {
    _context = context;
  }

  bool _isShowing = false;
  BuildContext? _context;
  BuildContext? _dismissingContext;

  Future<bool> hide() async {
    try {
      if (_dismissingContext == null) {
        return Future.value(false);
      }
      if (_isShowing) {
        Navigator.of(_dismissingContext!).pop();

        _isShowing = false;
        return Future.value(true);
      }
      return Future.value(false);
    } catch (err) {
      debugPrint('Exception while hide the dialog');
      debugPrint(err.toString());
      return Future.value(false);
    }
  }

  Future<bool> show() async {
    try {
      if (!_isShowing) {
        DialogManager.show(
          context: _context!,
          barrierDismissible: false,
          overlay: true,
          builder: (context) {
            _dismissingContext = context;
            return CircularProgressIndicator();
          },
        );

        // // Delaying the function for 200 milliseconds
        // // [Default transitionDuration of DialogRoute]
        await Future.delayed(Duration(milliseconds: 200));

        _isShowing = true;

        return Future.value(true);
      }

      return Future.value(false);
    } catch (err) {
      _isShowing = false;
      debugPrint('Exception while showing the dialog');
      debugPrint(err.toString());

      return Future.value(false);
    }
  }
}
