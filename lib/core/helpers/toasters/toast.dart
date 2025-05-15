import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class ToastService {
  final BuildContext context;

  ToastService(this.context);

  void showAwesomeSnackbar({
    required String title,
    required String message,
    required ContentType contentType,
    Duration duration = const Duration(seconds: 3),
    SnackBarBehavior behavior = SnackBarBehavior.floating,
  }) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: behavior,
      backgroundColor: Colors.transparent,
      duration: duration,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: contentType,
      ),
    );

    _showSnackbar(snackBar);
  }

  void showAwesomeMaterialBanner({
    required String title,
    required String message,
    required ContentType contentType,
    Duration duration = const Duration(seconds: 4),
  }) {
    final materialBanner = MaterialBanner(
      elevation: 0,
      backgroundColor: Colors.transparent,
      forceActionsBelow: true,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: contentType,
        inMaterialBanner: true,
      ),
      actions: const [SizedBox.shrink()],
    );

    _showMaterialBanner(materialBanner, duration);
  }

  // Private helper methods
  void _showSnackbar(SnackBar snackBar) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  void _showMaterialBanner(MaterialBanner banner, Duration duration) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.hideCurrentMaterialBanner();
    scaffold.showMaterialBanner(banner);

    Future.delayed(duration, () => scaffold.hideCurrentMaterialBanner());
  }

  void showSuccess(String message, {String title = 'Success!'}) {
    showAwesomeSnackbar(
      title: title,
      message: message,
      contentType: ContentType.success,
    );
  }

  void showError(String message, {String title = 'Oh Snap!'}) {
    showAwesomeSnackbar(
      title: title,
      message: message,
      contentType: ContentType.failure,
    );
  }

  void showWarning(String message, {String title = 'Warning!'}) {
    showAwesomeSnackbar(
      title: title,
      message: message,
      contentType: ContentType.warning,
    );
  }

  void showHelp(String message, {String title = 'Help!'}) {
    showAwesomeSnackbar(
      title: title,
      message: message,
      contentType: ContentType.help,
    );
  }
}

extension ToastServiceExtension on BuildContext {
  ToastService get toast => ToastService(this);
}
