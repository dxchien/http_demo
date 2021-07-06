import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void hideKeyboard() {
  SystemChannels.textInput.invokeMethod('TextInput.hide');
}

void hideKeyboardAndUnFocus(BuildContext context) {
  FocusScope.of(context).unfocus();
  SystemChannels.textInput.invokeMethod('TextInput.hide');
}

double getScreenHeightExcludeSafeArea(BuildContext context) {
  final double height = MediaQuery.of(context).size.height;
  final EdgeInsets padding = MediaQuery.of(context).padding;
  return height - padding.top - padding.bottom;
}

double getScreenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double getScreenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}