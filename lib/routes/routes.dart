import 'package:cherifla/screens/changeComite/change_comite.dart';
import 'package:cherifla/screens/compte/compte_screen.dart';
import 'package:cherifla/screens/compte/modifier_mdp_screen.dart';
import 'package:cherifla/screens/evenement/evenement.dart';
import 'package:cherifla/screens/historique/historique.dart';
import 'package:cherifla/screens/home/homeScreen.dart';
import 'package:cherifla/screens/inscription/inscription.dart';
import 'package:cherifla/screens/login/login.dart';
import 'package:cherifla/screens/splash/splash_screen.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class Routes {
  static String splashRoute = '/';
  static String loginRoute = '/login';
  static String homeRoute = '/home';
  static String evenementRoute = '/evenement';
  static String inscriptionRoute = '/inscription';
  static String changeComiteRoute = '/changeComite';
  static String historiqueRoute = '/historique';
  static String compteRoute = '/compte';
  static String modifierMdpRoute = '/compte/modifier-mdp';

  static final getPages = [
    GetPage(
      name: splashRoute,
      page: () =>  const SplashScreen(),
    ),
    GetPage(
      name: loginRoute,
      page: () =>  const LoginScreen(),
    ),
    GetPage(
      name: homeRoute,
      page: () =>  const HomeScreen(),
    ),
    GetPage(
      name: inscriptionRoute,
      page: () =>  const InscriptionScreen(),
    ),
    GetPage(
      name: changeComiteRoute,
      page: () =>  const ChangeComiteScreen(),
    ),
    GetPage(
      name: historiqueRoute,
      page: () =>  const HistoriqueScreen(),
    ),

    GetPage(
      name: evenementRoute,
      page: () =>  const EvenementScreen(),
    ),
    GetPage(
      name: compteRoute,
      page: () =>  const CompteScreen(),
    ),
    GetPage(
      name: modifierMdpRoute,
      page: () =>  const ModifierMdpScreen(),
    ),
      ];
}