import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class CommonToast {
  static void showToast({
    required BuildContext context,
    required String message,
    Duration autoCloseDuration = const Duration(seconds: 5),
    AlignmentGeometry alignment = Alignment.bottomCenter,
    ToastificationType type = ToastificationType.info,
    Widget? title,
    Widget? description,
    Color? primaryColor,
    Color? backgroundColor,
    Color? foregroundColor,
    EdgeInsetsGeometry? padding,
    BorderRadiusGeometry? borderRadius,
    bool showProgressBar = false,
    DismissDirection dismissDirection = DismissDirection.vertical,
    ToastificationCallbacks callbacks = const ToastificationCallbacks(),
  }) {
    toastification.show(
      context: context,
      title: title ?? Text(message, style: TextStyle(color: foregroundColor)),
      autoCloseDuration: autoCloseDuration,
      alignment: alignment,
      type: type,
      description: description,
      primaryColor: primaryColor,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      padding: padding,
      borderRadius: borderRadius,
      showProgressBar: showProgressBar,
      dismissDirection: dismissDirection,
      callbacks: callbacks,
    );
  }
}
