import 'package:cherifla/screens/evenement/event_scan_qr_code_screen.dart';
import 'package:cherifla/services/api/api.services.dart';
import 'package:cherifla/utils/loading/loading_utils.dart';
import 'package:cherifla/utils/responsive/responsive.dart';
import 'package:cherifla/widgets/appbar/app_bar.dart';
import 'package:cherifla/widgets/button/buttonWidget.dart';
import 'package:cherifla/widgets/common/common_widgets.dart';
import 'package:cherifla/widgets/textField/textFieldWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/background/background.dart';

class EvenementScreen extends StatefulWidget {
  const EvenementScreen({super.key, required this.id});
  final String id;

  @override
  State<EvenementScreen> createState() => _ChangeComiteScreenState();
}

class _ChangeComiteScreenState extends State<EvenementScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final api = ApiServices();
  final codeController = TextEditingController();
  var showLoading = false;

  onContinue() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        showLoading = true;
      });
      api
          .getAdherentByCodeEvent(widget.id, codeController.value.text)
          .then((value) {
        if (value != null) {
          setState(() {
            showLoading = false;
          });
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
      appBar: buildAppBar(title: 'Evénement'),
      body: Stack(
        children: [
          const Background(),
          getBody(widget.id),
          if (showLoading) getLoader()
        ],
      ),
    );
  }

  Widget getBody(String id) => ResponsiveScrollView(
        maxWidth: ContentWidth.form,
        child: AppCard(
          padding: EdgeInsets.all(context.responsive(20, tablet: 32)),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SectionTitle("Vérifier un participant"),
                const SizedBox(height: 16),
                TextFieldWidget(
                  controller: codeController,
                  prefix: const Icon(Icons.badge_outlined),
                  suffix: IconButton(
                    tooltip: 'Scanner un QR code',
                    onPressed: () =>
                        Get.to(() => EventScanQrCodeScreen(id: id)),
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
                  hintText: "Code d'adhérent",
                ),
                const SizedBox(height: 24),
                ButtonWidget(
                  title: "Vérifier",
                  loading: showLoading,
                  onPressed: () => showLoading ? null : onContinue(),
                ),
              ],
            ),
          ),
        ),
      );
}
