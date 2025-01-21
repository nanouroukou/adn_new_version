import 'package:cherifla/utils/color/color.dart';
import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  const Background({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: backGroundDecoration,
      child: const Scaffold(
          backgroundColor: Colors.transparent),

    );
  }
}