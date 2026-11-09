import 'package:cherifla/utils/color/color.dart';
import 'package:cherifla/widgets/textField/textFieldWidget.dart';
import 'package:flutter/material.dart';

/// Liste déroulante des formulaires (sexe, type de pièce, diplôme).
///
/// - pendant le chargement : « Chargement… » avec un petit indicateur ;
/// - liste vide après chargement : bouton pour réessayer ;
/// - se reconstruit quand la liste arrive (clé liée au nombre d'éléments),
///   pour reprendre la valeur déjà sélectionnée.
class AppDropdown<T> extends StatelessWidget {
  const AppDropdown({
    super.key,
    required this.items,
    required this.value,
    required this.hint,
    required this.labelOf,
    required this.onChanged,
    this.loading = false,
    this.onRetry,
    this.validator,
  });

  final List<T> items;
  final T? value;
  final String hint;
  final String Function(T item) labelOf;
  final ValueChanged<T> onChanged;
  final bool loading;
  final VoidCallback? onRetry;
  final FormFieldValidator<T>? validator;

  @override
  Widget build(BuildContext context) {
    final empty = items.isEmpty;
    // La valeur n'est gardée que si elle fait partie de la liste
    final current = (value != null && items.contains(value)) ? value : null;

    Widget? suffix;
    if (loading) {
      suffix = const Padding(
        padding: EdgeInsets.all(14),
        child: SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2, color: primaryColor),
        ),
      );
    } else if (empty && onRetry != null) {
      suffix = IconButton(
        tooltip: 'Réessayer',
        icon: const Icon(Icons.refresh_rounded),
        onPressed: onRetry,
      );
    }

    return DropdownButtonFormField<T>(
      key: ValueKey('$hint-${items.length}'),
      initialValue: current,
      isExpanded: true,
      validator: validator,
      // Même style de texte que les autres champs
      style: const TextStyle(
          fontSize: 16, fontWeight: FontWeight.w400, color: titleTextColor),
      disabledHint: Text(
        loading ? 'Chargement…' : 'Indisponible',
        style: const TextStyle(color: mutedTextColor, fontSize: 15),
      ),
      decoration: appInputDecoration(labelText: hint, suffix: suffix),
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(12),
      icon: suffix == null ? null : const SizedBox.shrink(),
      items: empty
          ? null
          : items
              .map((v) => DropdownMenuItem<T>(
                    value: v,
                    child: Text(labelOf(v), overflow: TextOverflow.ellipsis),
                  ))
              .toList(),
      onChanged: empty ? null : (v) => v == null ? null : onChanged(v),
    );
  }
}
