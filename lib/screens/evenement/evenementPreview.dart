import 'package:cherifla/controller/dropdown_controller.dart';
import 'package:cherifla/models/adherent_model.dart';
import 'package:cherifla/screens/changeComite/change_comite_form_screen.dart';
import 'package:cherifla/services/api/api.services.dart';
import 'package:cherifla/utils/responsive/responsive.dart';
import 'package:cherifla/widgets/button/buttonWidget.dart';
import 'package:cherifla/widgets/common/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/appbar/app_bar.dart';
import '../../widgets/background/background.dart';

class EvenementPreview extends StatefulWidget {
  const EvenementPreview({super.key, required this.adherent});
  final Adherent adherent;

  @override
  State<EvenementPreview> createState() => _EvenementPreviewState();
}

class _EvenementPreviewState extends State<EvenementPreview> {
  final apiServices = ApiServices();
  final dropdownController = Get.put(DropdownController());

  @override
  Widget build(BuildContext context) {
    final a = widget.adherent;
    return Scaffold(
      appBar: buildAppBar(title: 'Information de l\'adhérent'),
      body: Stack(
        children: [
          const Background(),
          ResponsiveScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppCard(
                  child: Column(
                    children: [
                      InfoRow(label: "Code", value: a.codeAdherent ?? '-'),
                      InfoRow(label: "Nom", value: a.nom ?? '-'),
                      InfoRow(label: "Prénom(s)", value: a.prenom ?? '-'),
                      InfoRow(label: "Comité", value: a.level?.name ?? '-'),
                      InfoRow(label: "Profession", value: a.profession ?? '-'),
                      InfoRow(
                          label: "Nationalité", value: a.nationality ?? '-'),
                      InfoRow(
                          label: "Date de naissance",
                          value: a.dateNaissance ?? '-'),
                      InfoRow(
                          label: "Date d'adhésion",
                          value: a.adhesionDate ?? '-',
                          showDivider: false),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                ResponsiveCenter(
                  maxWidth: ContentWidth.form,
                  padding: EdgeInsets.zero,
                  child: ButtonWidget(
                    title: 'Valider',
                    onPressed: () {
                      Get.to(() => ChangeComiteFormScreen(adherent: a));
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
