import 'package:flutter/material.dart';

/// Bouton principal de l'application.
/// Par défaut il occupe toute la largeur disponible : c'est le parent
/// (souvent limité par [ResponsiveCenter]) qui contrôle sa taille.
class ButtonWidget extends StatelessWidget {
  const ButtonWidget(
      {super.key,
      this.colour,
      required this.title,
      required this.onPressed,
      this.border,
      this.size,
      this.height,
      this.width,
      this.textColor,
      this.icon,
      this.loading = false});

  final Color? colour;
  final String title;
  final double? border;
  final double? size;
  final double? height;
  final double? width;
  final Color? textColor;
  final IconData? icon;
  final bool loading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final style = ElevatedButton.styleFrom(
      backgroundColor: colour,
      foregroundColor: textColor,
      minimumSize: Size(64, height ?? 52),
      shape: border == null
          ? null
          : RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(border!)),
      textStyle: TextStyle(fontSize: size ?? 16, fontWeight: FontWeight.w600),
    );

    final label = loading
        ? SizedBox(
            height: 22,
            width: 22,
            child: CircularProgressIndicator(
                strokeWidth: 2.5, color: textColor ?? Colors.white),
          )
        : Text(title, textAlign: TextAlign.center, maxLines: 2);

    return SizedBox(
      width: width ?? double.infinity,
      child: icon == null
          ? ElevatedButton(
              style: style, onPressed: loading ? null : onPressed, child: label)
          : ElevatedButton.icon(
              style: style,
              onPressed: loading ? null : onPressed,
              icon: Icon(icon),
              label: label),
    );
  }
}
