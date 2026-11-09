import 'package:cherifla/controller/dropdown_controller.dart';
import 'package:cherifla/models/adherent_model.dart';
import 'package:cherifla/screens/changeComite/change_comite_form_screen.dart';
import 'package:cherifla/services/api/api.services.dart';
import 'package:cherifla/utils/responsive/responsive.dart';
import 'package:cherifla/widgets/button/buttonWidget.dart';
import 'package:cherifla/widgets/common/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/color/color.dart';
import '../../widgets/appbar/app_bar.dart';
import '../../widgets/background/background.dart';

class ChangeComiteTarget extends StatefulWidget {
  const ChangeComiteTarget({super.key, required this.adherent});
  final Adherent adherent;

  @override
  State<ChangeComiteTarget> createState() => _ChangeComiteTargetState();
}

class _ChangeComiteTargetState extends State<ChangeComiteTarget> {
  final apiServices = ApiServices();
  var status = "".obs;
  var deactivated = false;
  var blocked = false;
  final dropdownController = Get.put(DropdownController());

  @override
  void initState() {
    checkStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(title: 'Information de l\'adhérent'),
      body: Stack(
        children: [
          const Background(),
          getBody(),
        ],
      ),
    );
  }

  Widget getBody() {
    final a = widget.adherent;
    final isActive = deactivated && blocked;
    final statusColor = isActive ? primaryColor : redColor;

    return ResponsiveScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppCard(
            child: Column(
              children: [
                InfoRow(
                    label: "Statut",
                    value: isActive ? 'Actif' : _statusLabel,
                    valueColor: statusColor),
                InfoRow(
                    label: "Numéro matricule", value: a.codeAdherent ?? '-'),
                InfoRow(label: "Nom", value: a.nom ?? '-'),
                InfoRow(label: "Prénom(s)", value: a.prenom ?? '-'),
                InfoRow(label: "Comité", value: a.level?.name ?? '-'),
                InfoRow(label: "Profession", value: a.profession ?? '-'),
                InfoRow(label: "Nationalité", value: a.nationality ?? '-'),
                InfoRow(
                    label: "Date de naissance", value: a.dateNaissance ?? '-'),
                InfoRow(
                    label: "Date d'adhésion",
                    value: a.adhesionDate ?? '-',
                    showDivider: !deactivated || !blocked),
                if (!deactivated)
                  InfoRow(
                      label: "Raison",
                      value: a.deactivateReason ?? '-',
                      valueColor: redColor,
                      showDivider: false),
                if (!blocked)
                  InfoRow(
                      label: "Raison",
                      value: a.suspendReason ?? '-',
                      valueColor: redColor,
                      showDivider: false),
              ],
            ),
          ),
          const SizedBox(height: 24),
          if (isActive)
            ResponsiveCenter(
              maxWidth: ContentWidth.form,
              padding: EdgeInsets.zero,
              child: ButtonWidget(
                title: 'Modifier',
                icon: Icons.edit_outlined,
                onPressed: () {
                  Get.to(() => ChangeComiteFormScreen(adherent: a));
                },
              ),
            ),
        ],
      ),
    );
  }

  String get _statusLabel => status.value == 'COMPTE DESACTIVÉ'
      ? 'Désactivé'
      : status.value == 'COMPTE SUSPENDU'
          ? 'Suspendu'
          : status.value;

  checkStatus() {
    if (widget.adherent.deactivate.toString() == "true") {
      status.value = "COMPTE DESACTIVÉ";
      deactivated = false;
      blocked = true;
    } else if (widget.adherent.suspend.toString() == "true") {
      status.value = "COMPTE SUSPENDU";
      deactivated = true;
      blocked = false;
    } else if (widget.adherent.deactivate.toString() == "false" &&
        widget.adherent.suspend.toString() == "false") {
      status.value = "ACTIF";
      deactivated = true;
      blocked = true;
    }
  }
}
