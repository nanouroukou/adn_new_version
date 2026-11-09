import 'dart:async';

import 'package:cherifla/controller/user.controller.dart';
import 'package:cherifla/screens/home/homeScreen.dart';
import 'package:cherifla/screens/login/login.dart';
import 'package:cherifla/services/app/init_service.dart';
import 'package:cherifla/utils/loading/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _secureStorage = const FlutterSecureStorage();
  final userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    getFullName();
    Timer(const Duration(seconds: 2), () async {
      var value = await _secureStorage.read(key: 'token');
      if (value != null) {
        // Agent déjà connecté : on charge les listes dès le lancement
        InitService().preloadEssentialData();
        Get.off(() => const HomeScreen());
      } else {
        Get.to(() => const LoginScreen());
      }
    });
  }

  getFullName() async {
    var prenom = await _secureStorage.read(key: 'firstName');
    var nom = await _secureStorage.read(key: 'lastName');
    userController.prenom.value = prenom.toString();
    userController.nom.value = nom.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        body: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          child: Image.asset(
            splash,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
