import 'package:cherifla/utils/color/color.dart';
import 'package:cherifla/utils/mediaQuery/size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      width: width ?? displayWidth(context),
      height: height ?? Get.height * 0.08,
      decoration: backGroundColor,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: Get.height * 0.05),
            Text(
              text!,
              style: TextStyle(
                  backgroundColor: Colors.transparent,
                  decoration: TextDecoration.none,
                  fontFamily: 'Segoe UI',
                  fontSize: Get.height * 0.04,
                  fontWeight: weight ?? FontWeight.bold,
                  color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
