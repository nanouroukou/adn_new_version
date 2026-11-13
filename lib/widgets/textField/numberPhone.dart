import 'package:cherifla/utils/color/color.dart';
import 'package:cherifla/utils/format/phone_format.dart';
import 'package:cherifla/widgets/textField/textFieldWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class NumberTextFieldWidget extends StatefulWidget {
  final FormFieldValidator<String>? validator;
  final bool obscure;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onChangeCountry;

  /// Indicatif initial (ex. `221` ou `+221`). Vide → pays par défaut.
  final String? countryCode;

  /// Pays affiché quand aucun indicatif n'est connu (code ISO).
  final String defaultCountryIso;
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
    this.defaultCountryIso = 'ML',
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
  State<NumberTextFieldWidget> createState() => _NumberTextFieldWidgetState();
}

class _NumberTextFieldWidgetState extends State<NumberTextFieldWidget> {
  late Country _country;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _country = _initialCountry();

    // Remet le numéro existant (ex. en modification) au bon format.
    var national =
        PhoneFormat.national(_controller.text, dialCode: _country.dialCode);
    // Ancien enregistrement avec l'indicatif collé au numéro (ex. 22376123456).
    if (national.length > _country.maxLength &&
        national.startsWith(_country.dialCode)) {
      national = national.substring(_country.dialCode.length);
    }
    _controller.text =
        PhoneFormat.display(national, dialCode: _country.dialCode);

    // Enregistre l'indicatif affiché même si l'utilisateur ne change pas de pays.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onChangeCountry?.call(_country.dialCode);
    });
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  Country _initialCountry() {
    final code = PhoneFormat.dialCode(widget.countryCode);
    if (code.isNotEmpty) {
      for (final c in countries) {
        if (c.fullCountryCode == code) return c;
      }
      for (final c in countries) {
        if (c.dialCode == code) return c;
      }
    }
    return countries.firstWhere((c) => c.code == widget.defaultCountryIso,
        orElse: () => countries.first);
  }

  String? _validate(String? _) {
    final digits = PhoneFormat.digits(_controller.text);
    final custom = widget.validator?.call(digits);
    if (custom != null) return custom;
    if (digits.isNotEmpty &&
        (digits.length < _country.minLength ||
            digits.length > _country.maxLength)) {
      return 'Format invalide (${_country.minLength == _country.maxLength ? _country.maxLength : '${_country.minLength} à ${_country.maxLength}'} chiffres)';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: _validate,
      builder: (field) => IntlPhoneField(
        initialCountryCode: _country.code,
        onCountryChanged: (country) {
          setState(() => _country = country);
          final national = PhoneFormat.national(_controller.text,
              dialCode: country.dialCode);
          final limited = national.length > country.maxLength
              ? national.substring(0, country.maxLength)
              : national;
          _controller.text =
              PhoneFormat.display(limited, dialCode: country.dialCode);
          widget.onChangeCountry?.call(country.dialCode);
          field.didChange(_controller.text);
        },
        onChanged: (phone) {
          widget.onChanged?.call(PhoneFormat.digits(phone.number));
          field.didChange(phone.number);
        },
        // La longueur est vérifiée par _validate (le numéro contient des espaces).
        disableLengthCheck: true,
        autovalidateMode: AutovalidateMode.disabled,
        languageCode: 'FR',
        // ignore: deprecated_member_use
        searchText: "Rechercher votre pays",
        invalidNumberMessage: "format invalide",
        controller: _controller,
        readOnly: widget.read ?? false,
        showCursor: widget.show ?? true,
        style:
            TextStyle(color: widget.textColor ?? titleTextColor, fontSize: 16),
        dropdownTextStyle: const TextStyle(color: titleTextColor, fontSize: 16),
        flagsButtonPadding: const EdgeInsets.only(left: 12),
        obscureText: widget.obscure,
        keyboardType: widget.keyboardType,
        decoration: appInputDecoration(
          hintText: widget.hintText,
          prefix: widget.prefix,
          suffix: widget.suffix,
          fillColor: widget.fillColor,
          hintColor: widget.hintColor,
          hintSize: widget.size,
          borderColor: widget.borderColor,
          borderWidth: widget.boderWidth,
        ).copyWith(errorText: field.errorText),
        textInputAction: widget.textInputAction ?? TextInputAction.done,
        inputFormatters: [
          PhoneInputFormatter(
            dialCode: _country.dialCode,
            maxDigits: _country.maxLength,
          ),
          ...?widget.inputFormatters,
        ],
        onSubmitted: widget.onFieldSubmitted,
      ),
    );
  }
}
