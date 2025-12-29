import 'package:cherifla/screens/home/homeScreen.dart';
import 'package:cherifla/utils/color/color.dart';
import 'package:cherifla/utils/mediaQuery/size.dart';
import 'package:cherifla/widgets/appbar/app_bar.dart';
import 'package:cherifla/widgets/background/background.dart';
import 'package:cherifla/widgets/button/buttonWidget.dart';
import 'package:cherifla/widgets/button/iconButton.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controller/dropdown_controller.dart';
import '../../services/api/api.services.dart';

class ValidationScreen extends StatefulWidget {
  const ValidationScreen({super.key});

  @override
  State<ValidationScreen> createState() => _ValidationScreenState();
}

final apiServices = ApiServices();
final dropdownController = Get.put(DropdownController());

class _ValidationScreenState extends State<ValidationScreen> {
  launchWhatsappWithMobileNumber() async {
    String message =
        "merci de recevoir votre code  adehenent ${apiServices.code.value} ";
    final Uri whatsappUri = Uri.parse(
        'https://wa.me/${apiServices.phone.value}?text=${Uri.encodeComponent(message)}');
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } else {
      await launchUrl(whatsappUri, mode: LaunchMode.platformDefault);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        canvasColor: redColor,
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: primaryColor,
            ),
      ),
      child: Scaffold(
          appBar: buildAppBar(title: 'Inscription'),
          body: Stack(
            alignment: Alignment.topCenter,
            children: [const Background(), getBody()],
          )),
    );
  }

  Widget getBody() {
    return Column(
      children: [
        // Gap(displayHeight(context) * 0.04),
        // Text(
        //   "la personne inscrite recevra ",
        //   style: TextStyle(
        //     color: loginColor,
        //     fontWeight: FontWeight.bold,
        //     fontSize: Get.height * 0.025,
        //   ),
        // ),
        // Gap(displayHeight(context) * 0.005),
        // Text(
        //   "un message par SMS",
        //   style: TextStyle(
        //     color: loginColor,
        //     fontWeight: FontWeight.bold,
        //     fontSize: Get.height * 0.025,
        //   ),
        // ),
        // Gap(displayHeight(context) * 0.005),
        // Text(
        //   "contenant son numéro Matricule ",
        //   style: TextStyle(
        //       color: loginColor,
        //       fontWeight: FontWeight.bold,
        //       fontSize: Get.height * 0.025),
        // ),
        Gap(displayHeight(context) * 0.04),
        Container(
          height: displayHeight(context) * 0.30,
          width: displayWidth(context) * 0.50,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2),
              borderRadius:
                  BorderRadius.circular(displayHeight(context) * 0.0015),
              color: Colors.white),
          child: apiServices.code.value != null
              ? Image.network(
                  apiServices.link.value,
                  fit: BoxFit.fill,
                )
              : Icon(
                  color: Colors.grey,
                  Icons.person,
                  size: Get.height * 0.025,
                ),
        ),
        Gap(displayHeight(context) * 0.008),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Numéro Matricule: ",
              style: TextStyle(
                  color: loginColor,
                  fontWeight: FontWeight.bold,
                  fontSize: Get.height * 0.025),
            ),
            Text(
              apiServices.code.value,
              style: TextStyle(
                  color: loginColor,
                  fontWeight: FontWeight.bold,
                  fontSize: Get.height * 0.025),
            ),
          ],
        ),
        Gap(displayHeight(context) * 0.02),
        IconButtonWidget(
          width: Get.width * 18,
          icon: 'images/whatsapp.svg',
          title: "Envoyer par WhatsApp",
          textColor: loginColor,
          size: Get.height * 0.025,
          colour: Colors.white,
          onPressed: () => launchWhatsappWithMobileNumber(),
        ),
        Gap(displayHeight(context) * 0.005),
        ButtonWidget(
          width: Get.width * 18,
          title: "Retour au Menu Principal",
          size: Get.height * 0.025,
          colour: loginColor,
          onPressed: () => {Get.to(const HomeScreen())},
        )
      ],
    );
  }
}
