import 'package:cherifla/constants/app_texts.dart';
import 'package:cherifla/controller/user.controller.dart';
import 'package:cherifla/routes/routes.dart';
import 'package:cherifla/screens/evenement/eventList.dart';
import 'package:cherifla/services/api/api.services.dart';
import 'package:cherifla/services/authentification/auth.service.dart';
import 'package:cherifla/utils/color/color.dart';
import 'package:cherifla/utils/loading/image.dart';
import 'package:cherifla/utils/loading/loading_utils.dart';
import 'package:cherifla/utils/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

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

  static const List<Choice> choicesHomeList = [
    Choice(title: "Inscription", icon: 'images/inscription.svg'),
    Choice(title: "Historique", icon: 'images/historique.svg'),
    Choice(title: "Compte", icon: 'images/compte.svg'),
    Choice(title: "Modification", icon: 'images/change-comite.svg'),
    // Icône différente de « Compte » pour ne pas les confondre
    Choice(title: "Evénement", materialIcon: Icons.event_outlined),
    Choice(title: "Déconnexion", icon: 'images/logout.svg', danger: true),
  ];

  @override
  void initState() {
    super.initState();
    // Après connexion : charge les listes si elles ne le sont pas déjà
    InitService().preloadEssentialData();
  }

  /// "KOUYATE MOUSTAPHA" -> "Kouyate Moustapha"
  String _titleCase(String value) => value
      .trim()
      .split(RegExp(r'\s+'))
      .where((w) => w.isNotEmpty && w != 'null')
      .map((w) => w[0].toUpperCase() + w.substring(1).toLowerCase())
      .join(' ');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: surfaceColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(Texts.home),
      ),
      body: Obx(
        () => Stack(
          children: [
            ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                _buildWelcome(context),
                const SizedBox(height: 20),
                ResponsiveCenter(
                  maxWidth: ContentWidth.wide,
                  child: _getGridView(),
                ),
              ],
            ),
            if (_showLoading.value) getLoader(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcome(BuildContext context) {
    final name = _titleCase(
        "${userController.user.value.prenom ?? userController.prenom.value} ${userController.user.value.nom ?? userController.nom.value}");

    return Stack(
      children: [
        // Prolongement de la barre verte derrière la carte
        Container(height: 64, color: primaryColor),
        ResponsiveCenter(
          maxWidth: ContentWidth.wide,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Image.asset(
                  logo,
                  height: context.responsive<double>(96, tablet: 120),
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 14),
                const Text(
                  Texts.welcome,
                  style: TextStyle(fontSize: 15, color: mutedTextColor),
                ),
                const SizedBox(height: 2),
                Text(
                  name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: titleTextColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _getGridView() {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      final columns = width >= 840
          ? 4
          : width >= 520
              ? 3
              : 2;
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: choicesHomeList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: 1.2,
        ),
        itemBuilder: (context, index) => ChoiceCard(
          choice: choicesHomeList[index],
          indexCC: index,
          onTap: () => goToNextPage(index),
        ),
      );
    });
  }

  goToNextPage(int i) {
    switch (i) {
      case 0:
        Get.toNamed(Routes.inscriptionRoute);
        break;
      case 1:
        Get.toNamed(Routes.historiqueRoute);
        break;
      case 2:
        Get.toNamed(Routes.compteRoute);
        break;
      case 3:
        Get.toNamed(Routes.changeComiteRoute);
        break;
      case 4:
        Get.to(() => const EventListScreen());
        break;
      case 5:
        // signout() affiche sa propre confirmation
        authService.signout();
        break;
    }
  }
}

class Choice {
  const Choice({
    this.title,
    this.icon,
    this.materialIcon,
    this.taille,
    this.danger = false,
  });

  final String? title;
  final String? icon;
  final IconData? materialIcon;
  final double? taille;
  final bool danger;
}

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({super.key, this.choice, this.indexCC, this.onTap});
  final Choice? choice;
  final int? indexCC;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = (choice?.danger ?? false) ? redColor : primaryColor;
    final iconSize = context.responsive<double>(40, tablet: 46);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (choice?.icon != null)
                  SvgPicture.asset(
                    choice!.icon!,
                    height: iconSize,
                    width: iconSize,
                    // Icônes à la couleur de la marque
                    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                  )
                else
                  Icon(choice?.materialIcon, size: iconSize, color: color),
                const SizedBox(height: 12),
                Text(
                  choice?.title ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: (choice?.danger ?? false) ? redColor : titleTextColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
