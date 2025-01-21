import 'package:cherifla/controller/dropdown_controller.dart';
import 'package:cherifla/models/adherent_model.dart';
import 'package:cherifla/screens/changeComite/change_comite_form_screen.dart';
import 'package:cherifla/services/api/api.services.dart';
import 'package:cherifla/widgets/button/buttonWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/color/color.dart';
import '../../utils/mediaQuery/size.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(title: 'Information de l\'adherent'),
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            const Background(),
            getBody(),
          ],
        ));
  }

  @override
  void initState() {
    checkStatus();
    // TODO: implement initState
    super.initState();
  }

  Widget getBody() => Container(
        padding: EdgeInsets.symmetric(
            horizontal: displayWidth(context) * 0.01,
            vertical: displayWidth(context) * 0.01),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: displayHeight(context) * 0.05),
              SizedBox(
                width: displayWidth(context) * 06,
                child: Column(
                  children: [
                    buildInfoRow("Numéro Matricule", blueColor,
                        widget.adherent.codeAdherent!),
                    buildInfoRow(
                        "Nom", blueColor, widget.adherent.nom ?? 'NULL'),
                    buildInfoRow("Prénom(s)", blueColor,
                        widget.adherent.prenom ?? 'NULL'),
                    buildInfoRow("Comité", blueColor,
                        widget.adherent.level?.name ?? 'NULL'),
                    buildInfoRow("Profession", blueColor,
                        widget.adherent.profession ?? 'NULL'),
                    buildInfoRow("Nationalité", blueColor,
                        widget.adherent.nationality ?? 'NULL'),
                    buildInfoRow("Date Naissance", blueColor,
                        widget.adherent.dateNaissance ?? 'NULL'),
                    buildInfoRow("Date adhesion", blueColor,
                        widget.adherent.adhesionDate ?? 'NULL'),
                    Visibility(
                        visible: !deactivated || !blocked,
                        child:
                            buildInfoRow("Status", Colors.red, status.value)),
                    Visibility(
                        visible: deactivated && blocked,
                        child: buildInfoRow("Status", blueColor, status.value)),
                    Visibility(
                        visible: !deactivated,
                        child: buildInfoRow("Raison", Colors.red,
                            widget.adherent.deactivateReason ?? '')),
                    Visibility(
                        visible: !blocked,
                        child: buildInfoRow("Raison", Colors.red,
                            widget.adherent.suspendReason ?? '')),
                    SizedBox(height: displayHeight(context) * 0.05),
                    Visibility(
                      visible: deactivated && blocked,
                      child: SizedBox(
                          width: displayWidth(context) * 0.45,
                          child: ButtonWidget(
                            colour: primaryColor,
                            title: 'Modifier',
                            onPressed: () {
                              Get.to(ChangeComiteFormScreen(
                                adherent: widget.adherent,
                              ));
                            },
                            size: displayWidth(context) * 0.05,
                          )),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget buildHeader() {
    const double titleSizeCoef = 0.055;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: displayWidth(context) * 0.06),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Changement de comité",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontFamily: 'Avenir Next LTPro',
                    fontSize: displayWidth(context) * titleSizeCoef,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                    color: const Color(0xfff707070)),
              ),
            ],
          ),
          SizedBox(height: displayHeight(context) * 0.02),
        ],
      ),
    );
  }

  Widget buildInfoRow(String title, Color? color, String value) {
    return SizedBox(
      width: displayWidth(context) * 0.9,
      child: Padding(
        padding: EdgeInsets.all(displayHeight(context) * 0.01),
        child: Wrap(
          //mainAxisAlignment: MainAxisAlignment.center,
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.center,
          children: [
            Text(
              "$title:",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: displayWidth(context) * 0.045,
              ),
            ),
            Text(
              " $value",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color ?? blueColor,
                  fontSize: displayWidth(context) * 0.045),
            )
          ],
        ),
      ),
    );
  }

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
      status.value = "ACTIVER";
      deactivated = true;
      blocked = true;
    }
  }
}
