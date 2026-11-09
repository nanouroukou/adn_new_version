import 'package:cherifla/routes/routes.dart';
import 'package:cherifla/theme/global_theme.dart';
import 'package:cherifla/utils/responsive/responsive.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'controller/user.controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Orientation : portrait uniquement sur téléphone,
  // toutes orientations autorisées sur tablette.
  final view = WidgetsBinding.instance.platformDispatcher.views.first;
  final shortestSide = view.physicalSize.shortestSide / view.devicePixelRatio;
  if (shortestSide < Breakpoints.tablet) {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

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
      // Limite l'agrandissement du texte système pour éviter
      // que les mises en page cassent, tout en restant accessible.
      builder: (context, child) => MediaQuery.withClampedTextScaling(
        minScaleFactor: 0.85,
        maxScaleFactor: 1.3,
        child: child ?? const SizedBox.shrink(),
      ),
      getPages: Routes.getPages,
    );
  }
}
