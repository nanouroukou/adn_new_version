import 'package:cherifla/services/api/api.services.dart';
import 'package:cherifla/utils/alert/alert.util.dart';
import 'package:cherifla/utils/loading/loading_utils.dart';
import 'package:cherifla/widgets/background/background.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../utils/color/color.dart';
import '../../utils/mediaQuery/size.dart';
import '../../widgets/button/buttonWidget.dart';
import '../../widgets/textField/textFieldWidget.dart';

class ModifierMdpScreen extends StatefulWidget {
  const ModifierMdpScreen({super.key});

  @override
  State<ModifierMdpScreen> createState() => _ModifierMdpScreenState();
}

class _ModifierMdpScreenState extends State<ModifierMdpScreen> {
  final _formkey = GlobalKey<FormState>();
  final apiServices = ApiServices();
  var showLoading = false;

  //final _secureStorage = const FlutterSecureStorage();

  final TextEditingController oldPasswordController = TextEditingController();

  final TextEditingController newPasswordController = TextEditingController();

  final TextEditingController confirmNewPasswordController =
      TextEditingController();

  onModifier() async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        showLoading = true;
      });
      if (newPasswordController.text.trim().toString() ==
          confirmNewPasswordController.text.trim().toString()) {
        apiServices
            .changePassword(oldPasswordController.text,
                newPasswordController.text, confirmNewPasswordController.text)
            .then(
              (value) => setState(() {
                showLoading = false;
              }),
            );
      } else {
        Alert.showInfoDialog("les deux mots de passes sont different",
            backTo: null);
        setState(() {
          showLoading = false;
        });
      }

      //var truePassword = await _secureStorage.read(key: 'userPassword');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: loginColor,
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
            getBody(context),
            if (showLoading) getLoader()
          ],
        ));
  }

  Widget getBody(BuildContext context) {
    const double titleSizeCoef = 0.05;
    return Container(
        padding: EdgeInsets.symmetric(
            horizontal: displayWidth(context) * 0.01,
            vertical: displayWidth(context) * 0.01),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Gap(displayHeight(context) * 0.02),
              SizedBox(
                width: displayWidth(context) * 06,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Modification du mot de passe ",
                      style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontFamily: 'Avenir Next LTPro',
                          fontSize: displayWidth(context) * titleSizeCoef,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                          color: const Color(0xfff707070)),
                    ),
                  ],
                ),
              ),
              Gap(displayHeight(context) * 0.01),
              Padding(
                  padding: EdgeInsets.all(displayWidth(context) * 0.05),
                  child: Form(
                    key: _formkey,
                    child: Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.fromLTRB(
                          displayWidth(context) * 0.09,
                          displayHeight(context) * 0.03,
                          displayWidth(context) * 0.09,
                          displayHeight(context) * 0.05),
                      child: Column(children: [
                        Gap(displayHeight(context) * 0.04),
                        TextFieldWidget(
                          validator: (String? value) {
                            if (value!.isEmpty || value.length < 6) {
                              return 'Votre mot de passe doit comporter au minimum 6 caractères.';
                            } else {
                              return null;
                            }
                          },
                          controller: oldPasswordController,
                          obscure: true,
                          keyboardType: TextInputType.visiblePassword,
                          onChanged: (value) {},
                          hintText: 'Ancien Mot De Passe',
                          inputFormatters: const [],
                        ),
                        Gap(displayHeight(context) * 0.04),
                        TextFieldWidget(
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Votre mot de passe doit comporter au minimum 6 caractères.';
                            } else {
                              return null;
                            }
                          },
                          controller: newPasswordController,
                          obscure: true,
                          keyboardType: TextInputType.visiblePassword,
                          onChanged: (value) {},
                          hintText: 'Nouveau Mot de  passe',
                          inputFormatters: const [],
                        ),
                        Gap(displayHeight(context) * 0.04),
                        TextFieldWidget(
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Votre mot de passe doit comporter au minimum 6 caractères.';
                            } else {
                              return null;
                            }
                          },
                          controller: confirmNewPasswordController,
                          obscure: true,
                          keyboardType: TextInputType.visiblePassword,
                          onChanged: (value) {},
                          hintText: ' Confirmer nouveau Mot de  passe',
                          inputFormatters: const [],
                        ),
                        Gap(displayHeight(context) * 0.04),
                        ButtonWidget(
                          title: 'Modifier',
                          colour: loginColor,
                          onPressed: showLoading ? null : onModifier(),
                        )
                      ]),
                    ),
                  ))
            ],
          ),
        ));
  }
}
