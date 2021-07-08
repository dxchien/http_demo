import 'package:flutter/material.dart';

class DialogManager {
  static Future<T?> show<T>({
    required BuildContext context,
    required DialogBuilder builder,
    bool overlay = false,
    bool barrierDismissible = true,
    Color barrierColor = const Color(0x80000000),
    Duration transitionDuration = const Duration(milliseconds: 1),
    RouteTransitionsBuilder? transitionsBuilder,
  }) async {
    if (!overlay) {
      Navigator.of(context).popUntil((route) => route is PageRoute);
    }

    return showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return BaseDialog(builder: builder);
      },
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      transitionDuration: transitionDuration,
      transitionBuilder: transitionsBuilder ??
          (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                  parent: animation, curve: Curves.easeInOutCubic),
              child: child,
            );
          },
    );
  }
}

typedef DialogBuilder = Widget Function(BuildContext context);

class BaseDialog extends StatefulWidget {
  final DialogBuilder builder;

  const BaseDialog({Key? key, required this.builder}) : super(key: key);

  @override
  _BaseDialogState createState() => _BaseDialogState();
}

class _BaseDialogState extends State<BaseDialog> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: widget.builder(context),
      ),
    );
  }
}
