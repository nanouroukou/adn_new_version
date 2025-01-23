import 'package:cherifla/routes/routes.dart';
import 'package:cherifla/theme/global_theme.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'controller/user.controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //BLOCK ORIENTATION SCREEN
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Initialisation du controller user
  Get.put(UserController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: GlobalTheme.lightTheme,
      initialRoute: Routes.splashRoute,
      fallbackLocale: const Locale('fr', 'FR'),
      supportedLocales: const [
        Locale('fr'),
      ],
      localizationsDelegates: const [
        CountryLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      getPages: Routes.getPages,
    );
  }
}
