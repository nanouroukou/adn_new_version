import 'package:cherifla/constants/app_texts.dart';
import 'package:cherifla/services/authentification/auth.service.dart';
import 'package:cherifla/utils/color/color.dart';
import 'package:cherifla/utils/loading/image.dart';
import 'package:cherifla/utils/loading/loading_utils.dart';
import 'package:cherifla/utils/mediaQuery/size.dart';
import 'package:cherifla/widgets/background/background.dart';
import 'package:cherifla/widgets/button/buttonWidget.dart';
import 'package:cherifla/widgets/textField/textFieldWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ForgetPawssordScreen extends StatefulWidget {
  const ForgetPawssordScreen({super.key});

  @override
  State<ForgetPawssordScreen> createState() => _ForgetPawssordScreenState();
}

class _ForgetPawssordScreenState extends State<ForgetPawssordScreen> {
  var _showLoading = false;
  var visible = false;
  final authService = AuthService();
  final secureStorage = const FlutterSecureStorage();
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    checkFeign();
  }

  checkFeign() {
    var locale = secureStorage.read(key: 'userPassword');
    if (locale.toString().isEmpty) {
      setState(() {
        visible = !visible;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Background(),
        SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Container(
                    height: Get.height * 0.25,
                    width: Get.width * 0.9,
                    margin: EdgeInsets.only(
                        top: Get.height * 0.02, bottom: Get.height * 0.075),
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: Get.height * 0.025,
                      ),
                      child: Image.asset(
                        logo,
                        fit: BoxFit.contain,
                        width: Get.height * 0.15,
                      ),
                    )),
              ),
              Padding(
                  padding: EdgeInsets.only(bottom: Get.width * 0.05),
                  child: Card(
                    elevation: Get.height * 0.01,
                    color: const Color(0xFFFFFFFF),
                    child: Form(
                      key: _loginFormKey,
                      child: Container(
                        width: Get.width * 0.95,
                        color: Colors.transparent,
                        padding: EdgeInsets.fromLTRB(
                            Get.width * 0.07,
                            Get.width * 0.03,
                            Get.width * 0.09,
                            Get.height * 0.05),
                        child: Column(children: [
                          SizedBox(
                            height: Get.height * 0.03,
                          ),
                          TextFieldWidget(
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return '';
                              } else {
                                return null;
                              }
                            },
                            textColor: primaryColor,
                            fillColor: greyColor,
                            hintColor: Colors.black,
                            prefix: const Icon(
                              Icons.email,
                              color: loginColor,
                            ),
                            controller: emailController,
                            obscure: false,
                            keyboardType: TextInputType.text,
                            onChanged: (value) {},
                            hintText: 'Saisissez votre Email',
                          ),
                          Gap(Get.height * 0.04),
                          ButtonWidget(
                            title: "Envoyer",
                            colour: loginColor,
                            onPressed: () => {
                              if (_loginFormKey.currentState!.validate())
                                {
                                  setState(() {
                                    _showLoading = true;
                                  }),
                                  checkFeign(),
                                  authService
                                      .forgetPassword(
                                          emailController.value.text)
                                      .then(
                                        (value) => setState(() {
                                          _showLoading = false;
                                        }),
                                      )
                                  // Get.to(const HomeScreen())
                                }
                            },
                          )
                        ]),
                      ),
                    ),
                  )),
            ],
          ),
        ),
        if (_showLoading) getLoader()
      ],
    );
  }
}
