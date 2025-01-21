import 'package:cherifla/screens/changeComite/change_comite_target.dart';
import 'package:cherifla/screens/changeComite/scan_qr_code_screen.dart';
import 'package:cherifla/screens/evenement/evenementPreview.dart';
import 'package:cherifla/screens/evenement/event_scan_qr_code_screen.dart';
import 'package:cherifla/services/api/api.services.dart';
import 'package:cherifla/utils/loading/loading_utils.dart';
import 'package:cherifla/widgets/appbar/app_bar.dart';
import 'package:cherifla/widgets/button/buttonWidget.dart';
import 'package:cherifla/widgets/textField/textFieldWidget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../constants/app_texts.dart';
import '../../utils/color/color.dart';
import '../../utils/mediaQuery/size.dart';
import '../../widgets/background/background.dart';

class EvenementScreen extends StatefulWidget {
  const EvenementScreen({super.key});

  @override
  State<EvenementScreen> createState() => _ChangeComiteScreenState();
}

class _ChangeComiteScreenState extends State<EvenementScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final api = ApiServices();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final codeController = TextEditingController();
  var showLoading = false;

  onContinue() {
    if (_formKey.currentState!.validate()) {
      // print(codeAdh);
      setState(() {
        showLoading = true;
      });
      api
          .getAdherentByCodeEvent(api.idEvent.value, codeController.value.text)
          .then((value) {
        if (value != null) {
          setState(() {
            showLoading = false;
          });
          // Get.to(()=>EvenementPreview(adherent: value));
        }
      }).whenComplete(
        () => setState(() {
          showLoading = false;
        }),
      );
      //Get.to(const ChangeComiteTarget());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(title: 'Evenement'),
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            const Background(),
            getBody(),
            if (showLoading) getLoader()
          ],
        ));
  }

  Widget getBody() => Container(
        padding: EdgeInsets.symmetric(
            horizontal: displayWidth(context) * 0.01,
            vertical: displayWidth(context) * 0.01),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Gap(displayHeight(context) * 0.05),
              SizedBox(
                width: displayWidth(context) * 06,
                child: Column(
                  children: [
                    SizedBox(
                        width: displayWidth(context) * 0.8,
                        child: Form(
                          key: _formKey,
                          child: TextFieldWidget(
                              controller: codeController,
                              suffix: IconButton(
                                  onPressed: () => Get.to(
                                      () => const EventScanQrCodeScreen()),
                                  icon: const Icon(
                                    Icons.qr_code_scanner,
                                    color: Colors.white,
                                  )),
                              validator: (value) {
                                if (value!.isEmpty || value.contains(" ")) {
                                  return "Code d'adhérent incorrect";
                                }
                                return null;
                              },
                              onChanged: null,
                              obscure: false,
                              keyboardType: TextInputType.text,
                              hintText: "Code d'adhérent"),
                        )),
                    SizedBox(
                      height: displayHeight(context) * 0.05,
                    ),
                    SizedBox(
                        width: Get.width * 0.5,
                        child: ButtonWidget(
                          colour: primaryColor,
                          title: "Verifier",
                          onPressed: () {
                            onContinue();
                          },
                          size: displayWidth(context) * 0.060,
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget buildHeader() {
    const double titleSizeCoef = 0.06;
    // const double iconTitleSizeCoef = 0.1;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: displayWidth(context) * 0.06),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Verification ",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontFamily: 'Avenir Next LTPro',
                    fontSize: displayWidth(context) * titleSizeCoef,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                    color: const Color(0xfff707070)),
              ),
            ],
          ),
          SizedBox(height: displayHeight(context) * 0.02),
        ],
      ),
    );
  }
}
