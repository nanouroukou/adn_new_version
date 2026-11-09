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

  void _onSubmit() {
    if (_showLoading) return;
    if (_loginFormKey.currentState!.validate()) {
      setState(() {
        _showLoading = true;
      });
      checkFeign();
      authService.forgetPassword(emailController.value.text).then(
            (value) => setState(() {
              _showLoading = false;
            }),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final logoHeight =
        (context.screenHeight * 0.15).clamp(80.0, 140.0).toDouble();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: primaryColor,
        iconTheme: const IconThemeData(color: primaryColor),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          tooltip: 'Retour',
          onPressed: () => Get.back(),
        ),
      ),
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
                            const SectionTitle(
                              'Mot de passe oublié',
                              subtitle:
                                  'Entrez votre email, on vous envoie un nouveau mot de passe.',
                            ),
                            const SizedBox(height: 20),
                            TextFieldWidget(
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Saisissez votre email';
                                }
                                return null;
                              },
                              prefix: const Icon(Icons.email_outlined),
                              controller: emailController,
                              obscure: false,
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (value) {},
                              onFieldSubmitted: (_) => _onSubmit(),
                              hintText: 'Email',
                            ),
                            const SizedBox(height: 24),
                            ButtonWidget(
                              title: "Envoyer",
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
