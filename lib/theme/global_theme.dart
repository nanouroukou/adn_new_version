import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/color/color.dart';

class GlobalTheme {
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: const Color.fromARGB(255, 250, 252, 255),
    primaryColor: primaryColor, // Couleur principale
    primaryColorLight: primaryColorLight, // Couleur primaire claire
    primaryColorDark: primaryColor, // Couleur primaire foncée
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.green, // Palette de couleurs de base
    ).copyWith(
      secondary: Colors.green, // Couleur secondaire (accentuée)
    ),
    dialogTheme: const DialogTheme(
      titleTextStyle: TextStyle(fontSize: 18, color: Colors.white),
      surfaceTintColor: primaryColor,
    ),

    textTheme: const TextTheme(
      displayLarge: TextStyle(
          fontSize: 72.0, fontWeight: FontWeight.bold, color: Colors.blue),
      titleLarge: TextStyle(
          fontSize: 36.0, fontStyle: FontStyle.italic, color: Colors.blue),
      bodyMedium:
          TextStyle(fontSize: 14.0, fontFamily: 'Hind', color: Colors.black),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15),
        foregroundColor: Colors.white,
        backgroundColor: primaryColor, // Couleur du texte
      ),
    ),
    // Personnalisation de l'AppBar
    appBarTheme: AppBarTheme(
      color: Colors.blue[300], // Couleur de fond
      titleTextStyle: const TextStyle(
          color: Colors.white, fontSize: 20.0), // Style du texte du titre
      iconTheme: const IconThemeData(color: Colors.white),
      systemOverlayStyle: SystemUiOverlayStyle.light // Couleur des icônes
    ),

    iconTheme: IconThemeData(
      color: Colors.blue[200], // Couleur des icônes
    ),

    inputDecorationTheme: InputDecorationTheme(
        focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(color: primaryColor)),
        errorStyle: const TextStyle(color: redColor),
        hintStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.normal,
          color: textColor,
        ),
        filled: true,
        fillColor: Colors.black12,
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 2, color: primaryColor),
            borderRadius: BorderRadius.circular(5)),
        border: OutlineInputBorder(
            borderSide: const BorderSide(width: 0, color: primaryColor),
            borderRadius: BorderRadius.circular(15))),

    // Personnalisation des boutons flottants (FAB)
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor, // Couleur de fond
      foregroundColor: Colors.white, // Couleur de l'icône
    ),
    // Personnalisation des cartes
    cardTheme: const CardTheme(
      color: Colors.white,
      shadowColor: primaryColorLight,
      elevation: 5,
    ),
    bottomNavigationBarTheme:
        const BottomNavigationBarThemeData(backgroundColor: Colors.white),

    snackBarTheme: const SnackBarThemeData(
        backgroundColor: primaryColor,
        insetPadding: EdgeInsets.symmetric(vertical: 22, horizontal: 8)),
        dropdownMenuTheme: const DropdownMenuThemeData(
          menuStyle: MenuStyle(
            backgroundColor: WidgetStatePropertyAll(primaryColor)
          )
        ),
        
  );
}
