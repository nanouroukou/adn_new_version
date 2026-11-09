import 'package:cherifla/theme/global_theme.dart';
import 'package:cherifla/utils/color/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Décoration commune à tous les champs de saisie.
/// Les valeurs non fournies proviennent du thème global.
InputDecoration appInputDecoration({
  String? hintText,
  String? labelText,
  Widget? prefix,
  Widget? suffix,
  Color? fillColor,
  Color? hintColor,
  Color? borderColor,
  double? borderWidth,
  double? hintSize,
}) {
  OutlineInputBorder? customBorder(double width) => borderColor == null
      ? null
      : OutlineInputBorder(
          borderRadius: BorderRadius.circular(GlobalTheme.radius),
          borderSide: BorderSide(color: borderColor, width: width),
        );

  // Libellé flottant : le nom du champ reste visible une fois rempli.
  return InputDecoration(
    labelText: labelText ?? hintText,
    prefixIcon: prefix,
    suffixIcon: suffix,
    fillColor: fillColor,
    labelStyle: (hintColor != null || hintSize != null)
        ? TextStyle(
            color: hintColor ?? mutedTextColor, fontSize: hintSize ?? 15)
        : null,
    enabledBorder: customBorder(borderWidth ?? 1),
    border: customBorder(borderWidth ?? 1),
  );
}

class TextFieldWidget extends StatefulWidget {
  final FormFieldValidator<String>? validator;
  final bool obscure;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final String hintText;
  final String? labelText;
  final Color? hintColor;
  final Widget? suffix;
  final Widget? prefix;
  final bool? disable;
  final double? boderWidth;
  final double? size;
  final Color? borderColor;
  final Color? fillColor;
  final Color? textColor;
  final bool? show;
  final bool? read;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;
  final Function(String value)? onFieldSubmitted;
  final VoidCallback? onTap;

  const TextFieldWidget(
      {super.key,
      this.validator,
      required this.obscure,
      required this.keyboardType,
      this.textInputAction,
      required this.onChanged,
      required this.hintText,
      this.labelText,
      this.suffix,
      this.prefix,
      this.disable,
      this.show,
      this.controller,
      this.inputFormatters,
      this.boderWidth,
      this.borderColor,
      this.read,
      this.size,
      this.fillColor,
      this.hintColor,
      this.textColor,
      this.onFieldSubmitted,
      this.onTap});

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  late bool _hidden = widget.obscure;

  @override
  Widget build(BuildContext context) {
    // Bouton afficher / masquer pour les mots de passe
    final Widget? suffix = widget.suffix ??
        (widget.obscure
            ? IconButton(
                tooltip: _hidden ? 'Afficher' : 'Masquer',
                icon: Icon(_hidden
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined),
                onPressed: () => setState(() => _hidden = !_hidden),
              )
            : null);

    return TextFormField(
      controller: widget.controller,
      readOnly: widget.read ?? false,
      enabled: widget.disable == null ? null : !widget.disable!,
      showCursor: widget.show,
      onTap: widget.onTap,
      style: TextStyle(
        color: widget.textColor ?? titleTextColor,
        fontSize: 16,
      ),
      onChanged: widget.onChanged,
      obscureText: _hidden,
      keyboardType: widget.keyboardType,
      decoration: appInputDecoration(
        hintText: widget.hintText,
        labelText: widget.labelText,
        prefix: widget.prefix,
        suffix: suffix,
        fillColor: widget.fillColor,
        hintColor: widget.hintColor,
        hintSize: widget.size,
        borderColor: widget.borderColor,
        borderWidth: widget.boderWidth,
      ),
      validator: widget.validator,
      textInputAction: widget.textInputAction ?? TextInputAction.done,
      inputFormatters: widget.inputFormatters,
      onFieldSubmitted: widget.onFieldSubmitted,
    );
  }
}
