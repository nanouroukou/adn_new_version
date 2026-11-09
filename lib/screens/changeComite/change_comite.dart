import 'package:cherifla/screens/changeComite/change_comite_target.dart';
import 'package:cherifla/screens/changeComite/scan_qr_code_screen.dart';
import 'package:cherifla/services/api/api.services.dart';
import 'package:cherifla/utils/loading/loading_utils.dart';
import 'package:cherifla/utils/responsive/responsive.dart';
import 'package:cherifla/widgets/appbar/app_bar.dart';
import 'package:cherifla/widgets/button/buttonWidget.dart';
import 'package:cherifla/widgets/common/common_widgets.dart';
import 'package:cherifla/widgets/textField/textFieldWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_texts.dart';
import '../../widgets/background/background.dart';

class ChangeComiteScreen extends StatefulWidget {
  const ChangeComiteScreen({super.key});

  @override
  State<ChangeComiteScreen> createState() => _ChangeComiteScreenState();
}

class _ChangeComiteScreenState extends State<ChangeComiteScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final api = ApiServices();
  final codeController = TextEditingController();
  var showLoading = false;

  onContinue() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        showLoading = true;
      });
      api.getAdherentByCode(codeController.value.text).then((value) {
        if (value != null) {
          setState(() {
            showLoading = false;
          });
          Get.to(() => ChangeComiteTarget(adherent: value));
        }
      }).whenComplete(
        () => setState(() {
          showLoading = false;
        }),
      );
    }
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(title: 'Modification'),
      body: Stack(
        children: [const Background(), getBody(), if (showLoading) getLoader()],
      ),
    );
  }

  Widget getBody() => ResponsiveScrollView(
        maxWidth: ContentWidth.form,
        child: AppCard(
          padding: EdgeInsets.all(context.responsive(20, tablet: 32)),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SectionTitle('Rechercher un adhérent'),
                const SizedBox(height: 16),
                TextFieldWidget(
                  controller: codeController,
                  prefix: const Icon(Icons.badge_outlined),
                  suffix: IconButton(
                    tooltip: 'Scanner un QR code',
                    onPressed: () => Get.to(() => const ScanQrCodeScreen()),
                    icon: const Icon(Icons.qr_code_scanner),
                  ),
                  validator: (value) {
                    if (value!.isEmpty || value.contains(" ")) {
                      return "Code d'adhérent incorrect";
                    }
                    return null;
                  },
                  onChanged: null,
                  obscure: false,
                  keyboardType: TextInputType.text,
                  onFieldSubmitted: (_) => showLoading ? null : onContinue(),
                  hintText: "Code d'adhérent ou téléphone",
                ),
                const SizedBox(height: 24),
                ButtonWidget(
                  title: Texts.next,
                  loading: showLoading,
                  onPressed: () => showLoading ? null : onContinue(),
                ),
              ],
            ),
          ),
        ),
      );
}
