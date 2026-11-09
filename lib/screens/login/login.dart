import 'package:cherifla/constants/app_texts.dart';
import 'package:cherifla/screens/login/froget_password.dart';
import 'package:cherifla/services/authentification/auth.service.dart';
import 'package:cherifla/utils/color/color.dart';
import 'package:cherifla/utils/loading/image.dart';
import 'package:cherifla/utils/loading/loading_utils.dart';
import 'package:cherifla/utils/responsive/responsive.dart';
import 'package:cherifla/widgets/background/background.dart';
import 'package:cherifla/widgets/button/buttonWidget.dart';
import 'package:cherifla/widgets/common/common_widgets.dart';
import 'package:cherifla/widgets/textField/textFieldWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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

  void _onSubmit() {
    if (_showLoading) return;
    if (_loginFormKey.currentState!.validate()) {
      setState(() {
        _showLoading = true;
      });
      checkFeign();
      authService
          .signin(loginController.value.text, passwordController.value.text)
          .then(
            (value) => setState(() {
              _showLoading = false;
            }),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final logoHeight =
        (context.screenHeight * 0.18).clamp(90.0, 170.0).toDouble();

    return Scaffold(
      body: Stack(
        children: [
          const Background(),
          SafeArea(
            child: Center(
              child: ResponsiveScrollView(
                maxWidth: ContentWidth.form,
                child: Column(
                  children: [
                    Image.asset(logo, height: logoHeight, fit: BoxFit.contain),
                    const SizedBox(height: 24),
                    AppCard(
                      padding:
                          EdgeInsets.all(context.responsive(20, tablet: 32)),
                      child: Form(
                        key: _loginFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SectionTitle(Texts.login),
                            const SizedBox(height: 20),
                            TextFieldWidget(
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Saisissez votre login';
                                }
                                return null;
                              },
                              prefix: const Icon(Icons.person_outline),
                              controller: loginController,
                              obscure: false,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              onChanged: (value) {},
                              hintText: 'Login',
                            ),
                            const SizedBox(height: 16),
                            TextFieldWidget(
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Saisissez votre mot de passe';
                                }
                                return null;
                              },
                              prefix: const Icon(Icons.lock_outline),
                              controller: passwordController,
                              obscure: true,
                              keyboardType: TextInputType.visiblePassword,
                              onChanged: (value) {},
                              onFieldSubmitted: (_) => _onSubmit(),
                              hintText: 'Mot de passe',
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () =>
                                    Get.to(() => const ForgetPawssordScreen()),
                                child: const Text(Texts.forgotPassword),
                              ),
                            ),
                            if (visible)
                              Center(
                                child: IconButton(
                                  iconSize: 48,
                                  color: loginColor,
                                  tooltip: 'Connexion biométrique',
                                  icon: const Icon(Icons.fingerprint),
                                  onPressed: () async {
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
                                ),
                              ),
                            const SizedBox(height: 8),
                            ButtonWidget(
                              title: Texts.signin,
                              loading: _showLoading,
                              onPressed: _onSubmit,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_showLoading) getLoader()
        ],
      ),
    );
  }
}
