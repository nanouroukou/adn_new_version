import 'package:cherifla/utils/color/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Bouton secondaire (contour) avec une icône SVG.
class IconButtonWidget extends StatelessWidget {
  const IconButtonWidget(
      {super.key,
      this.colour,
      required this.title,
      required this.onPressed,
      this.border,
      this.size,
      this.height,
      this.width,
      this.textColor,
      this.icon});

  final Color? colour;
  final String title;
  final double? border;
  final double? size;
  final double? height;
  final double? width;
  final Color? textColor;
  final String? icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: colour ?? Colors.white,
          foregroundColor: textColor ?? primaryColor,
          minimumSize: Size(64, height ?? 52),
          side: BorderSide(color: textColor ?? primaryColor, width: 1.5),
          shape: border == null
              ? null
              : RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(border!)),
          textStyle:
              TextStyle(fontSize: size ?? 16, fontWeight: FontWeight.w600),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              SvgPicture.asset(icon!, height: 24, width: 24),
              const SizedBox(width: 12),
            ],
            Flexible(
              child: Text(title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}
