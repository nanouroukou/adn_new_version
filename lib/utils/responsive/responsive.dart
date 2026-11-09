import 'package:flutter/material.dart';

/// Points de rupture utilisés dans toute l'application.
class Breakpoints {
  static const double tablet = 600;
  static const double desktop = 1024;
}

/// Largeurs maximales de contenu, pour éviter que les écrans
/// s'étirent sur toute la largeur d'une tablette.
class ContentWidth {
  static const double form = 480;
  static const double content = 640;
  static const double wide = 960;
}

extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  bool get isTablet => screenWidth >= Breakpoints.tablet;
  bool get isDesktop => screenWidth >= Breakpoints.desktop;

  /// Retourne une valeur selon la taille de l'écran.
  T responsive<T>(T mobile, {T? tablet, T? desktop}) {
    if (isDesktop) return desktop ?? tablet ?? mobile;
    if (isTablet) return tablet ?? mobile;
    return mobile;
  }

  /// Marge horizontale standard des pages.
  double get pagePadding => responsive<double>(16, tablet: 24, desktop: 32);
}

/// Centre son enfant et limite sa largeur à [maxWidth].
class ResponsiveCenter extends StatelessWidget {
  const ResponsiveCenter({
    super.key,
    required this.child,
    this.maxWidth = ContentWidth.content,
    this.padding,
    this.alignment = Alignment.topCenter,
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding:
              padding ?? EdgeInsets.symmetric(horizontal: context.pagePadding),
          child: child,
        ),
      ),
    );
  }
}

/// Page défilante, centrée et à largeur limitée.
class ResponsiveScrollView extends StatelessWidget {
  const ResponsiveScrollView({
    super.key,
    required this.child,
    this.maxWidth = ContentWidth.content,
    this.controller,
    this.padding,
  });

  final Widget child;
  final double maxWidth;
  final ScrollController? controller;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: controller,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: padding ??
          EdgeInsets.symmetric(horizontal: context.pagePadding, vertical: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: child,
        ),
      ),
    );
  }
}
