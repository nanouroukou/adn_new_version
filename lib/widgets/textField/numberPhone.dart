import 'package:cherifla/utils/color/color.dart';
import 'package:cherifla/widgets/textField/textFieldWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class NumberTextFieldWidget extends StatelessWidget {
  final FormFieldValidator<String>? validator;
  final bool obscure;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onChangeCountry;
  final String? countryCode;
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
  final TextEditingController? codeController;

  final Function(String value)? onFieldSubmitted;

  const NumberTextFieldWidget({
    super.key,
    this.validator,
    required this.obscure,
    required this.keyboardType,
    this.textInputAction,
    required this.onChanged,
    required this.hintText,
    this.suffix,
    this.prefix,
    this.countryCode,
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
    this.onChangeCountry,
    this.codeController,
  });

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      onCountryChanged: (country) {
        onChangeCountry?.call(country.dialCode);
      },
      initialValue: '+$countryCode',
      languageCode: 'FR',
      // ignore: deprecated_member_use
      searchText: "Rechercher votre pays",
      invalidNumberMessage: "format invalide",
      controller: controller,
      readOnly: read ?? false,
      showCursor: show ?? true,
      style: TextStyle(color: textColor ?? titleTextColor, fontSize: 16),
      dropdownTextStyle: const TextStyle(color: titleTextColor, fontSize: 16),
      flagsButtonPadding: const EdgeInsets.only(left: 12),
      obscureText: obscure,
      keyboardType: keyboardType,
      decoration: appInputDecoration(
        hintText: hintText,
        prefix: prefix,
        suffix: suffix,
        fillColor: fillColor,
        hintColor: hintColor,
        hintSize: size,
        borderColor: borderColor,
        borderWidth: boderWidth,
      ),
      textInputAction: textInputAction ?? TextInputAction.done,
      inputFormatters: inputFormatters,
    );
  }
}
