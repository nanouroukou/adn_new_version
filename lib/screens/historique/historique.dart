import 'package:cherifla/services/api/api.services.dart';
import 'package:cherifla/utils/loading/loading_utils.dart';
import 'package:cherifla/utils/log/logger.dart';
import 'package:cherifla/widgets/appbar/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../utils/color/color.dart';
import '../../utils/mediaQuery/size.dart';
import '../../widgets/background/background.dart';

class HistoriqueScreen extends StatefulWidget {
  const HistoriqueScreen({super.key});

  @override
  State<HistoriqueScreen> createState() => _HistoriqueScreenState();
}

class _HistoriqueScreenState extends State<HistoriqueScreen> {
  final api = ApiServices();
  List historique = [];
  var _showLoading = true;
  final f = new DateFormat('yyyy-MM-dd hh:mm');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    api.getHistorique().then(
      (value) {
        setState(() {
          _showLoading = true;
        });
        if (value != null) {
          setState(() {
            historique = value;
          });
          logger().d('length historique ${historique.length}');
        }
      },
    ).whenComplete(() => setState(() {
          _showLoading = false;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        canvasColor: redColor,
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: loginColor,
            ),
      ),
      child: Scaffold(
          appBar: buildAppBar(title: 'Historique'),
          body: Stack(
            alignment: Alignment.topCenter,
            children: [
              const Background(),
              getBody(),
              if (_showLoading) getLoader()
            ],
          )),
    );
  }

  Widget getBody() {
    return Container(
        padding: EdgeInsets.symmetric(
            horizontal: Get.width * 0.01, vertical: Get.width * 0.01),
        child: ListView(physics: const ClampingScrollPhysics(), children: [
          Gap(Get.height * 0.01),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.height * 0.015),
            child: Text(
              "Total : ${historique.length}",
              style: TextStyle(
                  fontFamily: 'Avenir Next LTPro',
                  fontSize: Get.height * 0.025,
                  fontWeight: FontWeight.normal,
                  decoration: TextDecoration.none,
                  color: Color(0xfff707070)),
            ),
          ),
          Gap(Get.height * 0.01),
          Column(
            children: List.generate(historique.length, (index) {
              //logger().d(historique[index]);

              var item = historique[index];
              // logger().d(item['comity']['region']);
              var prenom = item['prenom'] ?? '';
              var nom = item['nom'] ?? '';
              var pays = item['comity']?['pays']?['nom'] ?? 'Pays';
              // var pays =  'Mali';
              var region = item['level6']['name'] ?? 'level';
              var createdAt = DateFormat.yMd()
                      .format(DateTime.parse(item['adhesionDate'])) ??
                  'Date d\'adhesion';
              var quarter = item['codeAdherent'] ?? 'Code ';
              // var commune = item['comity']?['commune']?['nom'] ?? 'Commune';
              var cerlce = item['comity']?['cercle']?['nom'] ?? 'Cercle';

              return _buildHistItems(prenom, nom, pays, region, cerlce, quarter,
                  createdAt.toString());
            }),
          )
        ]));
  }

  Container _buildHistItems(
      String prenom,
      String nom,
      String pays,
      String region,
      String cercle,
      String quarter,
      // String commune,
      String createdAt) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: Get.width * 0.03, vertical: Get.height * 0.015),
      padding: const EdgeInsets.all(2),
      //color: Colors.white,
      decoration: const BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 0.15, color: Colors.black87))),
      width: Get.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: Get.width * 0.4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "$nom $prenom ",
                  style: const TextStyle(
                      color: primaryColor, fontWeight: FontWeight.bold),
                ),
                Text(
                  '$quarter',
                  style: const TextStyle(
                      color: redColor, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          SizedBox(
            width: Get.width * 0.4,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$createdAt',
                    style: const TextStyle(
                        color: redColor, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '$region',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: primaryColor, fontWeight: FontWeight.bold),
                  )
                ]),
          )
        ],
      ),
    );
  }
}
