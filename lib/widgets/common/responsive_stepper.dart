import 'package:cherifla/utils/color/color.dart';
import 'package:cherifla/utils/responsive/responsive.dart';
import 'package:flutter/material.dart';

/// Description d'une étape de formulaire.
class FormStep {
  const FormStep({required this.title, required this.content, this.subtitle});

  final String title;
  final String? subtitle;
  final Widget content;
}

/// Formulaire en étapes, simple et pratique :
/// - en haut, une barre de progression et le nom de l'étape ;
/// - au milieu, le contenu de l'étape (défilant) ;
/// - en bas, les boutons Précédent / Suivant, toujours visibles.
class ResponsiveStepper extends StatelessWidget {
  const ResponsiveStepper({
    super.key,
    required this.steps,
    required this.currentStep,
    required this.onContinue,
    required this.onCancel,
    required this.lastStepLabel,
    this.scrollController,
    this.loading = false,
  });

  final List<FormStep> steps;
  final int currentStep;
  final VoidCallback onContinue;
  final VoidCallback onCancel;
  final String lastStepLabel;
  final ScrollController? scrollController;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final step = steps[currentStep];
    final isLast = currentStep == steps.length - 1;
    final padding = context.pagePadding;

    return Column(
      children: [
        // --- En-tête : progression ---
        Container(
          color: Colors.white,
          child: ResponsiveCenter(
            maxWidth: ContentWidth.content,
            padding: EdgeInsets.fromLTRB(padding, 16, padding, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        step.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: titleTextColor,
                        ),
                      ),
                    ),
                    Text(
                      '${currentStep + 1} sur ${steps.length}',
                      style:
                          const TextStyle(fontSize: 13, color: mutedTextColor),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: (currentStep + 1) / steps.length,
                    minHeight: 4,
                    color: primaryColor,
                    backgroundColor: borderColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(height: 1, color: borderColor),

        // --- Contenu de l'étape ---
        Expanded(
          child: SingleChildScrollView(
            controller: scrollController,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.fromLTRB(padding, 20, padding, 24),
            child: Center(
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(maxWidth: ContentWidth.content),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: KeyedSubtree(
                    key: ValueKey(currentStep),
                    child: step.content,
                  ),
                ),
              ),
            ),
          ),
        ),

        // --- Boutons fixés en bas ---
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: borderColor)),
          ),
          child: SafeArea(
            top: false,
            child: ResponsiveCenter(
              maxWidth: ContentWidth.content,
              padding: EdgeInsets.fromLTRB(padding, 12, padding, 12),
              child: Row(
                children: [
                  if (currentStep > 0) ...[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: loading ? null : onCancel,
                        child: const Text('Précédent'),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    flex: currentStep > 0 ? 1 : 2,
                    child: ElevatedButton(
                      onPressed: loading ? null : onContinue,
                      child: Text(isLast ? lastStepLabel : 'Suivant'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Bouton pour prendre une photo + aperçu.
class PhotoStepContent extends StatelessWidget {
  const PhotoStepContent({
    super.key,
    required this.buttonLabel,
    required this.onPick,
    this.preview,
  });

  final String buttonLabel;
  final VoidCallback onPick;
  final Widget? preview;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 260),
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor, width: 1.5),
                ),
                child: preview ??
                    const Center(
                      child: Icon(Icons.add_a_photo_outlined,
                          size: 64, color: mutedTextColor),
                    ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        OutlinedButton.icon(
          icon: const Icon(Icons.camera_alt_outlined),
          onPressed: onPick,
          label: Text(buttonLabel, textAlign: TextAlign.center),
        ),
      ],
    );
  }
}
