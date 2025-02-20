import 'package:cherifla/constants/app_texts.dart';
import 'package:cherifla/screens/login/froget_password.dart';
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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var _showLoading = false;
  var visible = false;
  final authService = AuthService();
  final secureStorage = const FlutterSecureStorage();
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    checkFeign();
    loginController.dispose();
    passwordController.dispose();
    phoneNumberController.dispose();
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
                              Icons.person,
                              color: loginColor,
                            ),
                            controller: loginController,
                            obscure: false,
                            keyboardType: TextInputType.text,
                            onChanged: (value) {},
                            hintText: 'Login',
                            inputFormatters: const [
                              // TestMaskFormatter(
                              //   mask: 'xx xx xx xx',
                              //   separator: ' ',
                              // ),
                            ],
                          ),
                          SizedBox(
                            height: Get.height * 0.04,
                          ),
                          TextFieldWidget(
                            textColor: primaryColor,
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return 'Saisissez votre mot de passe';
                              } else {
                                return null;
                              }
                            },
                            prefix: Padding(
                              padding: EdgeInsets.fromLTRB(
                                  0, 0, Get.height * 0.004, 0),
                              child: const Icon(
                                Icons.lock,
                                color: loginColor,
                              ),
                            ),
                            fillColor: greyColor,
                            hintColor: Colors.black,
                            controller: passwordController,
                            obscure: true,
                            keyboardType: TextInputType.visiblePassword,
                            onChanged: (value) {},
                            hintText: 'Mot de  passe',
                            inputFormatters: const [],
                          ),
                          // Gap(Get.height * 0.04),

                          Visibility(
                            visible: visible,
                            child: InkWell(
                              onTap: () async {
                                setState(() {
                                  _showLoading = true;
                                });
                                authService
                                    .useBiometric()
                                    .then(
                                      (value) => setState(() {
                                        _showLoading = false;
                                      }),
                                    )
                                    .whenComplete(
                                      () => setState(() {
                                        _showLoading = false;
                                      }),
                                    );
                              },
                              child: Padding(
                                padding:
                                    EdgeInsets.only(top: Get.height * 0.035),
                                child: const Icon(
                                  Icons.fingerprint,
                                  color: loginColor,
                                  size: 50,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                  onPressed: () =>
                                      {Get.to(ForgetPawssordScreen())},
                                  child: Text("Mot de passe oublier"))
                            ],
                          ),
                          // SizedBox(
                          //   height: Get.height * 0.04,
                          // ),
                          ButtonWidget(
                            title: Texts.signin,
                            colour: loginColor,
                            onPressed: () => _showLoading
                                ? null
                                : {
                                    if (_loginFormKey.currentState!.validate())
                                      {
                                        setState(() {
                                          _showLoading = true;
                                        }),
                                        checkFeign(),
                                        authService
                                            .signin(loginController.value.text,
                                                passwordController.value.text)
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
