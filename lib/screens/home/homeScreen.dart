// ignore_for_file: prefer_const_constructors

import 'package:cherifla/controller/user.controller.dart';
import 'package:cherifla/routes/routes.dart';
import 'package:cherifla/screens/evenement/eventList.dart';
import 'package:cherifla/services/api/api.services.dart';
import 'package:cherifla/services/authentification/auth.service.dart';
import 'package:cherifla/utils/loading/image.dart';
import 'package:cherifla/utils/loading/loading_utils.dart';
import 'package:cherifla/widgets/background/background.dart';
import 'package:cherifla/widgets/header/CustomHeaderText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../constants/app_texts.dart';
import '../../services/app/init_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final userController = Get.find<UserController>();
  final authService = AuthService();
  final apiServices = ApiServices();
  final _showLoading = false.obs;

  @override
  void initState() {
    super.initState();
    apiServices.getSex();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      InitService().preloadEssentialData();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Choice> choicesHomeList = [
      Choice(
        title: "Inscription",
        icon: 'images/inscription.svg',
      ),
      Choice(
        title: "Historique",
        icon: 'images/historique.svg',
      ),
      Choice(
        title: "Compte",
        icon: 'images/compte.svg',
      ),
      Choice(
        title: "Modification",
        icon: 'images/change-comite.svg',
      ),
      Choice(
        title: "Evenement",
        icon: 'images/compte.svg',
      ),
      Choice(
        title: "Déconnexion",
        icon: 'images/logout.svg',
      ),
    ];
    return Stack(
      children: [
        const Background(),
        getBody(choicesHomeList),
        if (_showLoading.value) getLoader()
      ],
    );
  }

  Widget getBody(List<Choice> choicesHomeList) => SafeArea(
        child: ListView(children: [
          CustomHeaderText(
            height: Get.height * 0.070,
            icon: Icons.home,
            text: "Accueil",
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Column(
                  children: [
                    Container(
                        color: Colors.white,
                        height: Get.height * 0.15,
                        width: Get.width,
                        child: Image.asset(
                          logo,
                          fit: BoxFit.scaleDown,
                        )),
                    SizedBox(
                      height: Get.height * 0.01,
                    ),
                    Text(
                      Texts.welcome,
                      maxLines: 2,
                      style: TextStyle(
                          fontFamily: 'Avenir Next LTPro',
                          fontSize: Get.height * 0.025,
                          fontWeight: FontWeight.normal,
                          decoration: TextDecoration.none,
                          color: Color(0xfff707070)),
                    ),
                    SizedBox(
                      height: Get.height * 0.005,
                    ),
                    Text(
                      "${userController.user.value.prenom ?? userController.prenom.value} ${userController.user.value.nom ?? userController.nom.value}",
                      style: TextStyle(
                          fontFamily: 'Avenir Next LTPro',
                          fontSize: Get.height * 0.025,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                          color: Color(0xfff707070)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SingleChildScrollView(child: _getGridView(choicesHomeList)),
        ]),
      );

  Widget _getGridView(List<Choice> choicesHomeList) => Container(
        margin: EdgeInsets.all(Get.width * 0.015),
        padding: EdgeInsets.all(Get.height * 0.015),
        decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF).withOpacity(.0),
            borderRadius: BorderRadius.circular(10)),
        child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.3,
            children: List.generate(choicesHomeList.length, (index) {
              return Center(
                child: ChoiceCard(
                  choice: choicesHomeList[index],
                  indexCC: index,
                  onTap: () {
                    goToNextPage(index);
                  },
                ),
              );
            })),
      );

  goToNextPage(int i) {
    switch (i) {
      case 0:
        {
          Get.toNamed(Routes.inscriptionRoute);
        }
        break;

      case 1:
        {
          Get.toNamed(Routes.historiqueRoute);
        }
        break;

      case 2:
        {
          Get.toNamed(Routes.compteRoute);
        }
        break;

      case 3:
        {
          Get.toNamed(Routes.changeComiteRoute);
        }
        break;

      case 4:
        {
          Get.to(() => const EventListScreen());
        }
        break;

      case 5:
        {
          //Get.toNamed(Routes.homeRoute);
          _showLoading.value = true;
          authService.signout().then(
            (value) {
              _showLoading.value = false;
            },
          );
        }
        break;
    }
  }
}

class Choice {
  const Choice({this.title, this.icon, this.taille});

  final String? title;
  final String? icon;
  final double? taille;
}

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({super.key, this.choice, this.indexCC, this.onTap});
  final Choice? choice;
  final int? indexCC;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: Get.height * 0.08,
        child: Container(
          alignment: Alignment.center,
          height: Get.height * 0.20,
          width: Get.width * 0.40,
          padding: EdgeInsets.only(
              bottom: Get.height * 0.05, top: Get.height * 0.025),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.all(Radius.circular(Get.height * 0.015)),
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset(
                  choice!.icon!,
                  height: Get.height * 0.05,
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      choice?.title ?? '',
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: Get.width * 0.035,
                        color: Colors.black,
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
