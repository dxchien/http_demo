import 'dart:io';

import 'package:flutter/material.dart';

import '../transitions/fade_route.dart';
import '../transitions/slide_route.dart';

void navigatorPush(BuildContext context, Widget screen) {
  if (Platform.isIOS) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => screen));
  } else {
    Navigator.of(context).push(SlideLeftRoute(page: screen));
  }
}

void navigatorPushReplacement(BuildContext context, Widget screen) {
  if (Platform.isIOS) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => screen));
  } else {
    Navigator.of(context).pushReplacement(SlideLeftRoute(page: screen));
  }
}

void navigatorPushAndRemoveUntil(BuildContext context, Widget screen) {
  Navigator.of(context)
      .pushAndRemoveUntil(FadeRoute(page: screen), (_) => false);
}