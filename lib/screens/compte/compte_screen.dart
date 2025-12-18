import 'package:cherifla/screens/compte/modifier_mdp_screen.dart';
import 'package:cherifla/widgets/appbar/app_bar.dart';
import 'package:cherifla/widgets/background/background.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../utils/color/color.dart';
import '../../utils/mediaQuery/size.dart';

class CompteScreen extends StatefulWidget {
  const CompteScreen({super.key});

  @override
  State<CompteScreen> createState() => _CompteScreenState();
}

class _CompteScreenState extends State<CompteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(title: 'Compte'),
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            const Background(),
            getBody(),
          ],
        ));
  }

  Widget getBody() {
    return Container(
        padding: EdgeInsets.symmetric(
            horizontal: displayWidth(context) * 0.01,
            vertical: displayWidth(context) * 0.01),
        child: ListView(
          physics: const ClampingScrollPhysics(),
          children: <Widget>[
            Gap(displayHeight(context) * 0.03),
            SizedBox(height: displayHeight(context) * 0.06),
            SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    buildButtonParam("Modifier le mot de passe",
                        () => Get.to(ModifierMdpScreen())),
                  ],
                ),
              ),
            )
          ],
        ));
  }

  Container buildButtonParam(String title, void Function() onPressed) {
    return Container(
      width: displayWidth(context),
      margin: EdgeInsets.symmetric(
          vertical: displayHeight(context) * 0.01,
          horizontal: displayWidth(context) * 0.06),
      child: ElevatedButton(
          style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.white),
              elevation: WidgetStatePropertyAll(4),
              shadowColor: WidgetStatePropertyAll(Colors.grey)),
          onPressed: onPressed,
          child: Text(
            title,
            style: TextStyle(
                color: primaryColor, fontSize: displayWidth(context) * 0.045),
          )),
    );
  }
}
