import 'package:cherifla/utils/color/color.dart';
import 'package:flutter/material.dart';

class CustomHeaderText extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final FontWeight? weight;
  final double? width;
  final double? height;

  const CustomHeaderText(
      {super.key,
      required this.icon,
      this.text,
      this.weight,
      this.width,
      this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      constraints: BoxConstraints(minHeight: height ?? 56),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: backGroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.white, size: 26),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Text(
              text ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: weight ?? FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
