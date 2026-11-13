import 'package:flutter/services.dart';

/// Outils de formatage des numéros de téléphone.
///
/// Convention de stockage (inchangée côté serveur) :
/// - `indicePays` : l'indicatif seul, en chiffres (ex. `221`) ;
/// - `phone`      : le numéro national, en chiffres seuls (ex. `771234567`).
///
/// À l'écran, le numéro est groupé pour être lisible (ex. `77 123 45 67`).
class PhoneFormat {
  PhoneFormat._();

  /// Ne garde que les chiffres.
  static String digits(String? value) =>
      (value ?? '').replaceAll(RegExp(r'\D'), '');

  /// Indicatif en chiffres seuls (`+221` → `221`).
  static String dialCode(String? value) => digits(value);

  /// Numéro national en chiffres seuls. Si le numéro a été saisi ou collé au
  /// format international (`+221…` ou `00221…`), l'indicatif est retiré pour
  /// ne pas être enregistré en double.
  static String national(String? value, {String? dialCode}) {
    final raw = (value ?? '').trim();
    var d = digits(raw);
    final code = PhoneFormat.dialCode(dialCode);
    if (code.isEmpty) return d;
    if (raw.startsWith('+') && d.startsWith(code)) {
      d = d.substring(code.length);
    } else if (d.startsWith('00$code')) {
      d = d.substring(code.length + 2);
    }
    return d;
  }

  /// Groupe les chiffres pour l'affichage.
  /// - Sénégal / Mali et numéros à 9 chiffres : `77 123 45 67`
  /// - France : `6 12 34 56 78`
  /// - nombre pair de chiffres : par paires `07 12 34 56 78`
  /// - sinon : `123 45 67`
  static String display(String? value, {String? dialCode}) {
    final d = digits(value);
    if (d.length <= 3) return d;
    final code = PhoneFormat.dialCode(dialCode);

    List<int> sizes;
    if (code == '33' && d.length == 9) {
      sizes = [1, 2, 2, 2, 2];
    } else if (d.length == 9) {
      sizes = [2, 3, 2, 2];
    } else if (d.length.isEven) {
      sizes = List.filled(d.length ~/ 2, 2);
    } else {
      sizes = [3, ...List.filled((d.length - 3) ~/ 2, 2)];
    }

    final parts = <String>[];
    var i = 0;
    for (final s in sizes) {
      if (i >= d.length) break;
      final end = (i + s).clamp(0, d.length);
      parts.add(d.substring(i, end));
      i = end;
    }
    if (i < d.length) parts.add(d.substring(i));
    return parts.join(' ');
  }

  /// Numéro au format international compact, pour le stockage :
  /// `+22376123456`. Vide si aucun chiffre.
  static String e164(String? dialCode, String? number) {
    final code = PhoneFormat.dialCode(dialCode);
    final n = national(number, dialCode: code);
    if (n.isEmpty) return '';
    return code.isEmpty ? n : '+$code$n';
  }

  /// Sépare un numéro international (`+22376123456`) en indicatif et numéro
  /// national, en reconnaissant l'indicatif parmi [knownDialCodes] (le plus
  /// long qui correspond). Un numéro sans `+` / `00` est considéré national.
  static ({String dialCode, String number}) split(
      String? value, Iterable<String> knownDialCodes) {
    final raw = (value ?? '').trim();
    var d = digits(raw);
    final international = raw.startsWith('+') || d.startsWith('00');
    if (!international) return (dialCode: '', number: d);
    if (d.startsWith('00')) d = d.substring(2);
    final codes = knownDialCodes.toSet().toList()
      ..sort((a, b) => b.length.compareTo(a.length));
    for (final c in codes) {
      if (c.isNotEmpty && d.startsWith(c)) {
        return (dialCode: c, number: d.substring(c.length));
      }
    }
    return (dialCode: '', number: d);
  }

  /// Numéro pour un lien WhatsApp (`wa.me/22376123456`) : chiffres seuls,
  /// indicatif compris. Ajoute [dialCode] s'il manque.
  static String whatsapp(String? number, String? dialCode) {
    final raw = (number ?? '').trim();
    var d = digits(raw);
    if (raw.startsWith('+')) return d;
    if (d.startsWith('00')) return d.substring(2);
    final code = PhoneFormat.dialCode(dialCode);
    if (code.isEmpty) return d;
    // Déjà précédé de l'indicatif (numéro national d'au moins 7 chiffres).
    if (d.startsWith(code) && d.length - code.length >= 7) return d;
    return '$code$d';
  }

  /// Numéro complet lisible : `+221 77 123 45 67`.
  static String international(String? number, String? dialCode) {
    final code = PhoneFormat.dialCode(dialCode);
    final n = display(number, dialCode: code);
    return code.isEmpty ? n : '+$code $n';
  }
}

/// Formate le numéro pendant la saisie (`771234567` → `77 123 45 67`),
/// limite la longueur au maximum du pays et garde le curseur à sa place.
class PhoneInputFormatter extends TextInputFormatter {
  PhoneInputFormatter({this.dialCode, this.maxDigits});

  final String? dialCode;
  final int? maxDigits;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var d = PhoneFormat.national(newValue.text, dialCode: dialCode);
    if (maxDigits != null && d.length > maxDigits!) {
      d = d.substring(0, maxDigits!);
    }
    final text = PhoneFormat.display(d, dialCode: dialCode);

    // Position du curseur : même nombre de chiffres avant lui qu'avant.
    final cursor = newValue.selection.end.clamp(0, newValue.text.length);
    var digitsBefore =
        PhoneFormat.digits(newValue.text.substring(0, cursor)).length;
    if (digitsBefore > d.length) digitsBefore = d.length;
    var offset = 0;
    var seen = 0;
    while (offset < text.length && seen < digitsBefore) {
      if (RegExp(r'\d').hasMatch(text[offset])) seen++;
      offset++;
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: offset),
    );
  }
}
