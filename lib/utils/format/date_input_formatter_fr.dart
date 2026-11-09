import 'package:flutter/services.dart';

/// Custom input formatter for date (dd-mm-yyyy)
class DateInputFormatterFr extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // On ne permet que les chiffres et les tirets
    var newText = newValue.text.replaceAll(RegExp(r'[^0-9-]'), '');

    // On limite la longueur à 10 caractères (dd-mm-yyyy)
    if (newText.length > 10) {
      return oldValue;
    }

    // On insère automatiquement les tirets aux bons endroits
    var buffer = StringBuffer();
    for (int i = 0; i < newText.length; i++) {
      buffer.write(newText[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 2 == 0 && nonZeroIndex != 10) {
        buffer.write('-');
      }
    }

    var newString = buffer.toString();
    return TextEditingValue(
      text: newString,
      selection: TextSelection.collapsed(offset: newString.length),
    );
  }
}
