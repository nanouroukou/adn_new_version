import 'package:cherifla/utils/color/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum _AlertKind { error, info, confirm }

/// Boîte de dialogue sobre, dans le style des dialogues natifs :
/// titre et texte alignés à gauche, boutons texte en bas à droite.
class _AppDialog extends StatelessWidget {
  const _AppDialog({
    required this.kind,
    required this.title,
    required this.message,
    required this.actions,
  });

  final _AlertKind kind;
  final String title;
  final String message;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      titlePadding: const EdgeInsets.fromLTRB(24, 22, 24, 0),
      contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 4),
      actionsPadding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: kind == _AlertKind.error ? redColor : titleTextColor,
        ),
      ),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 360,
          maxHeight: MediaQuery.sizeOf(context).height * 0.5,
        ),
        child: SingleChildScrollView(
          child: Text(
            message,
            style: const TextStyle(
                fontSize: 15, height: 1.45, color: Color(0xFF374151)),
          ),
        ),
      ),
      actions: actions,
    );
  }
}

class Alert {
  static showInfoSnackbar(BuildContext context) {
    const snackBar = SnackBar(
      content: Text('Yay! A SnackBar!'),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(bottom: 100.0, left: 20.0, right: 20.0),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static Widget _button(String label, VoidCallback onPressed,
      {Color? color, bool outlined = false}) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: outlined ? mutedTextColor : (color ?? primaryColor),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }

  static showErrorDialog(String textContent, {bool? isGoBack, Widget? backTo}) {
    return Get.dialog(
      _AppDialog(
        kind: _AlertKind.error,
        title: 'Erreur',
        message: textContent,
        actions: [
          _button('OK', () {
            Navigator.of(Get.context!).pop();
            if (isGoBack != null && isGoBack) {
              Get.back();
            } else if (backTo != null) {
              Get.to(() => backTo);
            }
          }),
        ],
      ),
      barrierDismissible: false,
    );
  }

  static showInfoDialog(String textContent, {bool? isGoBack, Widget? backTo}) {
    return Get.dialog(
      _AppDialog(
        kind: _AlertKind.info,
        title: 'Information',
        message: textContent,
        actions: [
          _button('OK', () {
            Navigator.of(Get.context!).pop();
            if (isGoBack != null && isGoBack) {
              Get.back();
            } else if (backTo != null) {
              Get.offAll(() => backTo);
            }
          }),
        ],
      ),
      barrierDismissible: false,
    );
  }

  static showConfirmDialog(String textContent, Function() onConfirm) {
    return Get.dialog(
      _AppDialog(
        kind: _AlertKind.confirm,
        title: 'Confirmation',
        message: textContent,
        actions: [
          _button('Annuler', () => Get.back(), outlined: true),
          _button('Oui', () => onConfirm(), color: redColor),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
