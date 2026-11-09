import 'dart:ui';

import 'package:cherifla/utils/color/color.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Voile de chargement plein écran (à placer dans un Stack), comme Yelen :
/// la page est floutée et grisée derrière, un petit carré avec l'indicateur
/// au centre, et rien en dessous ne répond (ni appui, ni retour).
Widget getLoader({double? size, String? message}) => const BusyVeil();

class BusyVeil extends StatelessWidget {
  const BusyVeil({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: SizedBox.expand(
        child: AbsorbPointer(
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: ColoredBox(
                // Léger gris par-dessus le flou
                color: Colors.black.withValues(alpha: 0.12),
                child: const PageLoading(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Carré arrondi avec l'indicateur, centré dans ce qu'il recouvre.
class PageLoading extends StatelessWidget {
  const PageLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Opacity(
      opacity: 0.75,
      child: Center(
        child: SizedBox(
          height: 100,
          width: 100,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Color(0xFFF1F2F6),
            ),
            child: Center(
              child: CircularProgressIndicator(color: primaryColor),
            ),
          ),
        ),
      ),
    );
  }
}

/// Balayage commun à tous les squelettes. Enveloppe une liste ENTIÈRE :
/// un seul balayage qui traverse l'écran se lit comme « l'écran charge ».
class AppShimmer extends StatelessWidget {
  const AppShimmer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFC9C9C9),
      highlightColor: const Color(0xFFEDEDED),
      period: const Duration(milliseconds: 1400),
      child: child,
    );
  }
}

/// Bloc d'un squelette. Peint en blanc opaque : le balayage remplace
/// la couleur de ce qu'il recouvre.
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    super.key,
    this.width,
    this.height = 10,
    this.radius = 4,
    this.circle = false,
  });

  final double? width;
  final double height;
  final double radius;
  final bool circle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: circle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: circle ? null : BorderRadius.circular(radius),
      ),
    );
  }
}

/// Liste squelette : même géométrie que les lignes réelles
/// (avatar rond, nom, code, date à droite).
class SkeletonList extends StatelessWidget {
  const SkeletonList({super.key, this.count = 7, this.showAvatar = true});

  final int count;
  final bool showAvatar;

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Column(
        children: [
          for (var i = 0; i < count; i++)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  if (showAvatar) ...[
                    const SkeletonBox(width: 40, height: 40, circle: true),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonBox(width: i.isEven ? 140 : 110),
                        const SizedBox(height: 8),
                        const SkeletonBox(width: 90, height: 8),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  const SkeletonBox(width: 64, height: 8),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
