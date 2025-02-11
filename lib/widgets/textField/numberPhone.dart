import 'package:cherifla/utils/color/color.dart';
import 'package:cherifla/utils/mediaQuery/size.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
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

  NumberTextFieldWidget({
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IntlPhoneField(
            onCountryChanged: (country) {
              onChangeCountry!(country.dialCode);
            },
            initialValue: '+$countryCode',
            languageCode: 'FR',
            searchText: "Rechercher votre pays",
            invalidNumberMessage: "format invalide",
            controller: controller,
            readOnly: read ?? false,
            showCursor: show,
            style: TextStyle(
                color: textColor ?? Colors.white,
                fontSize: displayWidth(context) * 0.04,
                fontWeight: FontWeight.normal),
            // textAlign: TextAlign.center,
            obscureText: obscure,
            keyboardType: keyboardType,
            decoration: InputDecoration(
                focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide(color: loginColor)),
                suffixIcon: suffix,
                prefixIcon: prefix,
                hintText: hintText,
                errorStyle: const TextStyle(color: redColor),
                errorMaxLines: 2,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                hintStyle: TextStyle(
                  fontSize: size ?? displayWidth(context) * 0.04,
                  fontWeight: FontWeight.normal,
                  color: hintColor ?? Colors.white,
                ),
                filled: true,
                fillColor: fillColor ?? primaryColorLight,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: boderWidth ?? 2,
                        color: borderColor ?? loginColor),
                    borderRadius: BorderRadius.circular(5)),
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: boderWidth ?? 0,
                        color: borderColor ?? loginColor),
                    borderRadius: BorderRadius.circular(15))),

            textInputAction: textInputAction ?? TextInputAction.done,
            inputFormatters: inputFormatters,
          ),
        ],
      ),
    );
  }
}
