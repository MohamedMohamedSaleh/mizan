import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class AppToast {
  static void success(BuildContext context, String message) {
    _show(
      context: context,
      message: message,
      type: ToastificationType.success,
      icon: Icons.check_circle_outline,
    );
  }

  static void error(BuildContext context, String message) {
    _show(
      context: context,
      message: message,
      type: ToastificationType.error,
      icon: Icons.error_outline,
    );
  }

  static void warning(BuildContext context, String message) {
    _show(
      context: context,
      message: message,
      type: ToastificationType.warning,
      icon: Icons.warning_amber_outlined,
    );
  }

  static void info(BuildContext context, String message) {
    _show(
      context: context,
      message: message,
      type: ToastificationType.info,
      icon: Icons.info_outline,
    );
  }

  static void _show({
    required BuildContext context,
    required String message,
    required ToastificationType type,
    required IconData icon,
  }) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    toastification.show(
      context: context,
      type: type,
      style: ToastificationStyle.flatColored,
      autoCloseDuration: const Duration(seconds: 4),
      alignment: isMobile ? Alignment.topCenter : Alignment.topRight,
      direction: TextDirection.ltr,
      icon: Icon(icon),
      title: Text(message),
      // ignore: deprecated_member_use
      closeButtonShowType: CloseButtonShowType.onHover,
      dragToClose: true,
      pauseOnHover: true,
      applyBlurEffect: false,
      showProgressBar: true,
    );
  }
}
