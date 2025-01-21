import 'package:cherifla/utils/color/color.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../utils/mediaQuery/size.dart';
import '../../widgets/background/background.dart';

class ModifierCompteScreen extends StatefulWidget {
  const ModifierCompteScreen({super.key});

  @override
  State<ModifierCompteScreen> createState() => _ModifierCompteScreenState();
}

class _ModifierCompteScreenState extends State<ModifierCompteScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: primaryColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_outlined),
                color: Colors.white,
                onPressed: () {
                  Get.back();
                },
              ),
            ),
            body: Stack(
              alignment: Alignment.topCenter,
              children: [
                const Background(),
                getBody(),
              ],
            )));
  }

  Widget getBody(){
    return Container(
      height: displayHeight(context)*0.6,
      padding: EdgeInsets.symmetric(
          horizontal: displayWidth(context) * 0.01,
          vertical: displayWidth(context) * 0.01),
   child: ListView(
    children: [
      Column(children: [
         Gap(displayHeight(context)*0.02),
        SizedBox(
              width: displayWidth(context) * 06,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                
                  Text(
                    "Modification du profil",
                    style: TextStyle(
                        fontFamily: 'Avenir Next LTPro',
                        fontSize: displayHeight(context) * 0.04,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                        color: const Color(0xfff707070)),
                  ),
                ],
              ),
            ),
         
      //TextFormField()
      ],)
      
    ],

   ), ); 
  }
}

 