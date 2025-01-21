import 'package:cherifla/utils/mediaQuery/size.dart';
import 'package:flutter/material.dart';

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
      this.textColor});

  final Color? colour;
  final String title;
  final double? border;
  final double? size;
  final double? height;
  final double? width;
  final Color? textColor;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? displayWidth(context)*0.5,
      height: height ?? 60,
      child: TextButton(
        style: TextButton.styleFrom(foregroundColor: Colors.transparent),
        onPressed: onPressed,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(border ?? 10),
              color: colour ?? Colors.white),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                  fontSize: size?? displayWidth(context)*0.05,
                  letterSpacing: 1,
                  color: textColor ?? Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
