import 'package:cherifla/screens/evenement/evenement.dart';
import 'package:cherifla/services/api/api.services.dart';
import 'package:cherifla/utils/loading/loading_utils.dart';
import 'package:cherifla/utils/log/logger.dart';
import 'package:cherifla/widgets/appbar/app_bar.dart';
import 'package:cherifla/widgets/background/background.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../utils/color/color.dart';
import '../../utils/mediaQuery/size.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  final api = ApiServices();
  List evenement = [];
  var _showLoading = true;
  final f = new DateFormat('yyyy-MM-dd hh:mm');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    api.getEvenement().then(
      (value) {
        setState(() {
          _showLoading = true;
        });
        if (value != null) {
          setState(() {
            evenement = value;
          });
          logger().d('length historique ${evenement.length}');
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
          appBar: buildAppBar(title: 'Evenement'),
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
            horizontal: displayWidth(context) * 0.01,
            vertical: displayWidth(context) * 0.01),
        child: ListView(physics: const ClampingScrollPhysics(), children: [
          Gap(displayHeight(context) * 0.01),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              "Total : ${evenement.length}",
              style: const TextStyle(
                  fontFamily: 'Avenir Next LTPro',
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  decoration: TextDecoration.none,
                  color: Color(0xfff707070)),
            ),
          ),
          Gap(displayHeight(context) * 0.01),
          Column(
            children: List.generate(evenement.length, (index) {
              var item = evenement[index];
              var value = item['id'] ?? '';
              api.idEvent.value = value.toString();
              var nom = item['name'] ?? '';
              return buildButtonParam(nom, () {
                Get.to(() => const EvenementScreen());
              });
            }),
          )
        ]));
  }

  Container buildButtonParam(
    String title,
    void Function() onPressed,
  ) {
    return Container(
      width: displayWidth(context),
      margin: EdgeInsets.symmetric(
          vertical: displayHeight(context) * 0.01,
          horizontal: displayWidth(context) * 0.06),
      child: ElevatedButton(
          style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.white),
              elevation: WidgetStatePropertyAll(4),
              shadowColor: WidgetStatePropertyAll(Colors.grey)),
          onPressed: onPressed,
          child: Text(
            title,
            style: TextStyle(
                color: primaryColor, fontSize: displayWidth(context) * 0.045),
          )),
    );
  }
}
