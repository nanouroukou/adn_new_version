import 'package:cherifla/services/api/api.services.dart';
import 'package:cherifla/utils/alert/alert.util.dart';
import 'package:cherifla/utils/color/color.dart';
import 'package:cherifla/utils/loading/loading_utils.dart';
import 'package:cherifla/utils/responsive/responsive.dart';
import 'package:cherifla/widgets/appbar/app_bar.dart';
import 'package:cherifla/widgets/background/background.dart';
import 'package:cherifla/widgets/common/common_widgets.dart';
import 'package:flutter/material.dart';

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
    }
  }

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(title: 'Mot de passe'),
      body: Stack(
        children: [
          const Background(),
          ResponsiveScrollView(
            maxWidth: ContentWidth.form,
            child: AppCard(
              padding: EdgeInsets.all(context.responsive(20, tablet: 32)),
              child: Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('6 caractères minimum.',
                        style: TextStyle(color: mutedTextColor, fontSize: 14)),
                    const SizedBox(height: 16),
                    TextFieldWidget(
                      validator: (String? value) {
                        if (value!.isEmpty || value.length < 6) {
                          return 'Votre mot de passe doit comporter au minimum 6 caractères.';
                        }
                        return null;
                      },
                      prefix: const Icon(Icons.lock_outline),
                      controller: oldPasswordController,
                      obscure: true,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {},
                      hintText: 'Ancien mot de passe',
                    ),
                    const SizedBox(height: 16),
                    TextFieldWidget(
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Votre mot de passe doit comporter au minimum 6 caractères.';
                        }
                        return null;
                      },
                      prefix: const Icon(Icons.lock_reset_outlined),
                      controller: newPasswordController,
                      obscure: true,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {},
                      hintText: 'Nouveau mot de passe',
                    ),
                    const SizedBox(height: 16),
                    TextFieldWidget(
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Votre mot de passe doit comporter au minimum 6 caractères.';
                        }
                        return null;
                      },
                      prefix: const Icon(Icons.lock_reset_outlined),
                      controller: confirmNewPasswordController,
                      obscure: true,
                      keyboardType: TextInputType.visiblePassword,
                      onChanged: (value) {},
                      onFieldSubmitted: (_) =>
                          showLoading ? null : onModifier(),
                      hintText: 'Confirmer le nouveau mot de passe',
                    ),
                    const SizedBox(height: 28),
                    ButtonWidget(
                      title: 'Modifier',
                      loading: showLoading,
                      onPressed: () => showLoading ? null : onModifier(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (showLoading) getLoader()
        ],
      ),
    );
  }
}
