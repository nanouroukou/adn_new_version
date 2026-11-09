import 'package:cherifla/utils/color/color.dart';
import 'package:flutter/material.dart';

/// Fond dégradé qui remplit tout l'espace disponible (à placer dans un Stack).
class Background extends StatelessWidget {
  const Background({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.expand(
      child: DecoratedBox(decoration: backGroundDecoration),
    );
  }
}
