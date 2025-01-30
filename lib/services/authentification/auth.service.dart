import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cherifla/screens/home/homeScreen.dart';
import 'package:cherifla/screens/login/login.dart';
import 'package:cherifla/utils/alert/alert.util.dart';
import 'package:cherifla/utils/log/logger.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    hide Options;
import 'package:get/get.dart' hide Response;
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

import '../../controller/user.controller.dart';
import '../../models/user.model.dart';

class AuthService {
  static String BASE_URL = "https://api24.sama.com.ml";

  final _secureStorage = const FlutterSecureStorage();
  final LocalAuthentication localAuth = LocalAuthentication();
  var user = User();

  final userController = Get.find<UserController>();

  Future forgetPassword(
    String email,
  ) async {
    try {
      // var payloadJson = jsonEncode({
      //   "email": email,
      // });
      final response = await http.get(
        Uri.parse('$BASE_URL/api/users/reset-password/$email'),

        // body: payloadJson,
      );

      if (response.statusCode == 200) {
        final bodyJson = jsonDecode(response.body);
        if (bodyJson['status'] == 1) {
          Alert.showInfoDialog(bodyJson['message'],
              backTo: const LoginScreen());
        } else {
          Alert.showErrorDialog(bodyJson['message']);
          logger().e(bodyJson['message']);
        }
      } else {
        Alert.showErrorDialog(
            'Erreur inattendue !(status ${response.statusCode})');
        logger().e('Erreur inattendue ![change comity] ! ${response.body}');
      }
    } on SocketException catch (e) {
      Alert.showErrorDialog('Connexion à internet impossible !');
      logger().e(e.toString());
    } on Exception catch (e) {
      Alert.showErrorDialog('Erreur inattendue ![change comity] !');
      logger().e(e.toString());
    }
    return null;
  }

  Future signin(String login, String password) async {
    var url = '$BASE_URL/api/auth';
    final body = jsonEncode({'login': login, 'password': password});
    final headers = {"Content-Type": "application/json"};
    try {
      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == 1) {
          await _secureStorage.write(
              key: 'token', value: data['body']['token']);

          await _secureStorage.write(
              key: 'expirationDate', value: data['body']['expirationDate']);

          await _secureStorage.write(key: 'userPassword', value: password);

          await _secureStorage.write(key: 'login', value: login);

          await _secureStorage.write(key: 'biometricEnabled', value: 'true');

          //
          user = User.fromJson(data['body']['user']);

          await _secureStorage.write(key: 'id', value: user.id.toString());
          await _secureStorage.write(key: 'firstName', value: user.prenom);
          await _secureStorage.write(key: 'lastName', value: user.nom);

          // set user on state management
          userController.setUser(user);

          logger().d('Connecte en tant que ${user.prenom} ${user.nom}');
          Get.off(() => const HomeScreen());
        } else {
          Alert.showErrorDialog(data['message']);
          logger().e(data);
        }
      } else {
        var body = jsonDecode(response.body);

        logger().e('Erreur inattendue ! Code ${response.statusCode}');

        Alert.showErrorDialog(
            body['message'] + ' Code : ${response.statusCode} ');
      }
    } on SocketException catch (e) {
      Alert.showErrorDialog(
          "Connexion internet impossile ! Verifier votre connexion internet !");
      logger().e(e);
    } on Exception catch (e) {
      // TODO
      logger().e(e);
      Alert.showErrorDialog(e.toString());
    }
  }

  Future signout() async {
    Alert.showConfirmDialog('Confirmez-vous votre déconnexion ?', () {
      clearAuthStorage();
      Get.offAll(() => const LoginScreen());
      logger().i("Déconnexion effectuée avec succès. À bientôt !");
    });
  }

  clearAuthStorage() async {
    await _secureStorage.delete(key: 'token');
    await _secureStorage.delete(key: 'expirationDate');
  }

  Future useBiometric() async {
    String? isEnabled = await _secureStorage.read(key: 'biometricEnabled');

    final bool canAuthenticateWithBiometrics =
        await localAuth.canCheckBiometrics;

    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await localAuth.isDeviceSupported();

    if (isEnabled == 'true' &&
        canAuthenticateWithBiometrics &&
        canAuthenticate) {
      logger().d('Biometric disponible');

      //LANCEMENT BIOMETRIQUE
      _launchBiometricAndLogin();
    } else {
      Alert.showInfoDialog(
          "Oups ! Authentification biometrique non disponible !");
      logger().w('Biometric non disponible');
      return null;
    }
  }

  _launchBiometricAndLogin() async {
    try {
      final bool didAuthenticate = await localAuth.authenticate(
          localizedReason: 'Authentifiez-vous pour continuer. !',
          options: const AuthenticationOptions(useErrorDialogs: false));

      if (didAuthenticate) {
        logger().d('Auth biometric avec success');
        var login = await _secureStorage.read(key: 'login');

        var password = await _secureStorage.read(key: 'userPassword');

        //CONNEXION
        signin(login ?? '', password ?? '');
      }
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable) {
        // Add handling of no hardware here.
      } else if (e.code == auth_error.notEnrolled) {
        // ...
      } else {
        // ...
      }
    }
  }

  Future<bool?> launchBiometric() async {
    String? isEnabled = await _secureStorage.read(key: 'biometricEnabled');

    final bool canAuthenticateWithBiometrics =
        await localAuth.canCheckBiometrics;

    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await localAuth.isDeviceSupported();

    if (isEnabled == 'true' &&
        canAuthenticateWithBiometrics &&
        canAuthenticate) {
      try {
        final bool didAuthenticate = await localAuth.authenticate(
            localizedReason: 'Authentifiez-vous pour continuer. !',
            options: const AuthenticationOptions(useErrorDialogs: false));

        return didAuthenticate;
      } on PlatformException catch (e) {
        if (e.code == auth_error.notAvailable) {
          // Add handling of no hardware here.
        } else if (e.code == auth_error.notEnrolled) {
          return null;
        } else {
          // ...
          return null;
        }
      }
    } else {
      Alert.showInfoDialog(
          "Oups ! Authentification biometrique non disponible !");
      logger().w('Biometric non disponible');
      return null;
    }
    return null;
  }
}
