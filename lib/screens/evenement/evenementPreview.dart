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

                buildInfoRow("Code", widget.adherent.codeAdherent!),
                buildInfoRow("Nom", widget.adherent.nom??'NULL'),
                buildInfoRow("Prénom(s)", widget.adherent.prenom??'NULL'),
                buildInfoRow("Comité", widget.adherent.level?.name??'NULL'),
                buildInfoRow("Profession", widget.adherent.profession??'NULL'),
                buildInfoRow("Nationalité", widget.adherent.nationality??'NULL'),
                buildInfoRow("Date Naissance", widget.adherent.dateNaissance??'NULL'),
                buildInfoRow("Date adhesion", widget.adherent.adhesionDate??'NULL'),
                // buildInfoRow("Sous-section", widget.adherent.subSection.nom??'NULL'),
                // buildInfoRow("Section", widget.adherent.section.nom??'NULL'),
                // buildInfoRow("Fédération Régionale", widget.adherent.regionalFederation.nom??'NULL'),
                SizedBox(height: displayHeight(context) * 0.05),
                SizedBox(
                    width: displayWidth(context) * 0.45,
                    child: ButtonWidget(
                      colour: primaryColor,
                      title: 'Valider',
                      onPressed: () {
                        Get.to( ChangeComiteFormScreen(adherent: widget.adherent,));
                      },
                      size: displayWidth(context) * 0.05,
                    ))
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
                "Les informations d'adherent",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontFamily: 'Avenir Next LTPro',
                    fontSize: displayWidth(context)* titleSizeCoef,
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

  Widget buildInfoRow(String title, String value) {
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
                  color: blueColor,
                  fontSize: displayWidth(context) * 0.045),
            )
          ],
        ),
      ),
    );
  }
}
