import 'package:cherifla/controller/user.controller.dart';
import 'package:cherifla/screens/compte/modifier_mdp_screen.dart';
import 'package:cherifla/utils/color/color.dart';
import 'package:cherifla/utils/responsive/responsive.dart';
import 'package:cherifla/widgets/appbar/app_bar.dart';
import 'package:cherifla/widgets/background/background.dart';
import 'package:cherifla/widgets/common/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CompteScreen extends StatefulWidget {
  const CompteScreen({super.key});

  @override
  State<CompteScreen> createState() => _CompteScreenState();
}

class _CompteScreenState extends State<CompteScreen> {
  final userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    final name =
        "${userController.user.value.prenom ?? userController.prenom.value} ${userController.user.value.nom ?? userController.nom.value}";

    return Scaffold(
      appBar: buildAppBar(title: 'Compte'),
      body: Stack(
        children: [
          const Background(),
          ResponsiveScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppCard(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Connecté',
                                style: TextStyle(
                                    color: mutedTextColor, fontSize: 13)),
                            const SizedBox(height: 2),
                            Text(name.trim(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleMedium),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Padding(
                  padding: EdgeInsets.only(left: 4, bottom: 8),
                  child: Text('Sécurité',
                      style: TextStyle(
                          color: mutedTextColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 13)),
                ),
                MenuTile(
                  title: 'Modifier le mot de passe',
                  icon: Icons.lock_outline_rounded,
                  onTap: () => Get.to(() => const ModifierMdpScreen()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
