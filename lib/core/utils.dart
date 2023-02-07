import 'package:flutter/material.dart';

class Utils {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static final BuildContext context = navigatorKey.currentState!.context;
  static void showToast(String text,
          {Color? backgroundColor, Color? textColor, int? duration}) =>
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            width: MediaQuery.of(context).size.width - 50,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: duration ?? 4),
            content: Text(
              text,
              style: TextStyle(
                color: textColor ?? Colors.white,
              ),
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: backgroundColor ?? Colors.green.withOpacity(0.7),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          ),
        );
      });

  static void showErrorToast(String text, {int? duration}) =>
      showToast(text, backgroundColor: Colors.red.withOpacity(0.7));
}
