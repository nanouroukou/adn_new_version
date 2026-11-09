import 'package:cherifla/utils/color/color.dart';
import 'package:flutter/material.dart';

/// Carte blanche avec un padding standard.
class AppCard extends StatelessWidget {
  const AppCard({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(20),
        child: child,
      ),
    );
  }
}

/// Titre de section avec sous-titre optionnel.
class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title,
      {super.key, this.subtitle, this.icon, this.center = false});

  final String title;
  final String? subtitle;
  final IconData? icon;
  final bool center;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment:
          center ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(title,
            textAlign: center ? TextAlign.center : TextAlign.start,
            style: theme.textTheme.titleLarge),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(subtitle!,
              textAlign: center ? TextAlign.center : TextAlign.start,
              style:
                  theme.textTheme.bodyMedium?.copyWith(color: mutedTextColor)),
        ],
      ],
    );
  }
}

/// Ligne « libellé : valeur » qui s'adapte à la largeur disponible.
class InfoRow extends StatelessWidget {
  const InfoRow(
      {super.key,
      required this.label,
      required this.value,
      this.valueColor,
      this.showDivider = true});

  final String label;
  final String value;
  final Color? valueColor;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: showDivider
          ? const BoxDecoration(
              border: Border(bottom: BorderSide(color: borderColor)))
          : null,
      child: LayoutBuilder(builder: (context, constraints) {
        final labelWidget = Text(label,
            style: const TextStyle(color: mutedTextColor, fontSize: 14));
        final valueWidget = Text(value,
            style: TextStyle(
                color: valueColor ?? blueColor,
                fontWeight: FontWeight.w600,
                fontSize: 15));
        // Sur écran très étroit, le libellé passe au-dessus de la valeur.
        if (constraints.maxWidth < 220) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [labelWidget, const SizedBox(height: 4), valueWidget],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 2, child: labelWidget),
            const SizedBox(width: 12),
            Expanded(flex: 3, child: valueWidget),
          ],
        );
      }),
    );
  }
}

/// Élément de menu cliquable (liste de paramètres, d'événements…).
class MenuTile extends StatelessWidget {
  const MenuTile(
      {super.key,
      required this.title,
      required this.onTap,
      this.icon,
      this.subtitle});

  final String title;
  final String? subtitle;
  final IconData? icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: icon == null ? null : Icon(icon, color: primaryColor),
        title: Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: titleTextColor)),
        subtitle: subtitle == null ? null : Text(subtitle!),
        trailing:
            const Icon(Icons.chevron_right_rounded, color: mutedTextColor),
        onTap: onTap,
      ),
    );
  }
}

/// Message affiché quand une liste est vide.
class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.message, this.icon});

  final String message;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Icon(icon ?? Icons.inbox_outlined, size: 56, color: mutedTextColor),
          const SizedBox(height: 12),
          Text(message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: mutedTextColor, fontSize: 15)),
        ],
      ),
    );
  }
}

/// Zone d'aperçu photo à ratio fixe, limitée en taille.
class PhotoPreview extends StatelessWidget {
  const PhotoPreview({super.key, this.child, this.maxWidth = 260});

  final Widget? child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: AspectRatio(
          aspectRatio: 3 / 4,
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor, width: 1.5),
            ),
            child: child ??
                const Center(
                  child: Icon(Icons.person_outline_rounded,
                      size: 96, color: borderColor),
                ),
          ),
        ),
      ),
    );
  }
}
