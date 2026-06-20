import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

bool isCupertinoPlatform(BuildContext context) {
  return Theme.of(context).platform == TargetPlatform.iOS;
}

IconData getBackIcon(BuildContext context) {
  return isCupertinoPlatform(context)
      ? CupertinoIcons.back
      : Icons.arrow_back_rounded;
}

IconData getForwardIcon(BuildContext context) {
  return isCupertinoPlatform(context)
      ? CupertinoIcons.forward
      : Icons.arrow_forward_rounded;
}

IconData getCloseIcon(BuildContext context) {
  return isCupertinoPlatform(context)
      ? CupertinoIcons.xmark
      : Icons.close_rounded;
}

Future<void> showPlatformDialog({
  required BuildContext context,
  required String title,
  required String message,
  String actionText = 'OK',
}) async {
  if (isCupertinoPlatform(context)) {
    return showCupertinoDialog<void>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: Text(actionText),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
  return showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(actionText),
        ),
      ],
    ),
  );
}
