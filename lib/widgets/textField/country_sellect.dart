import 'package:cherifla/utils/color/color.dart';
import 'package:cherifla/widgets/textField/textFieldWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CountryTextFieldWidget extends StatelessWidget {
  final FormFieldValidator<String>? validator;
  final bool obscure;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final String hintText;
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
  final Function ontap;

  const CountryTextFieldWidget(
      {super.key,
      this.validator,
      required this.obscure,
      required this.keyboardType,
      this.textInputAction,
      required this.onChanged,
      required this.hintText,
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
      required this.ontap});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: () => ontap(),
      controller: controller,
      readOnly: read ?? true,
      showCursor: show ?? false,
      style: TextStyle(color: textColor ?? titleTextColor, fontSize: 16),
      obscureText: obscure,
      keyboardType: keyboardType,
      decoration: appInputDecoration(
        hintText: hintText,
        prefix: prefix ?? const Icon(Icons.flag_outlined),
        suffix: suffix ?? const Icon(Icons.arrow_drop_down),
        fillColor: fillColor,
        hintColor: hintColor,
        hintSize: size,
        borderColor: borderColor,
        borderWidth: boderWidth,
      ),
      validator: validator,
      textInputAction: textInputAction ?? TextInputAction.done,
      inputFormatters: inputFormatters,
    );
  }
}
