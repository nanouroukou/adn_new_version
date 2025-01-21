import 'package:cherifla/utils/color/color.dart';
import 'package:cherifla/utils/mediaQuery/size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Alert {
  static showInfoSnackbar(BuildContext context) {
    const snackBar = SnackBar(
      content: Text('Yay! A SnackBar!'),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(bottom: 100.0, left: 20.0, right: 20.0),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static showErrorDialog(String textContent, {bool? isGoBack, Widget? backTo}) {
    return Get.defaultDialog(
      barrierDismissible: false,
      backgroundColor: Colors.white,
      title: 'Erreur',
      titleStyle: const TextStyle(color: redColor),
      content: SizedBox(
          height: displayHeight(Get.context!) * 0.1,
          child: Center(
            child: SingleChildScrollView(
              child: Text(
                            textContent,
                            textAlign: TextAlign.center,
                          ),
            ),
          )),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(Get.context!).pop();
              if (isGoBack != null && isGoBack) {
                Get.back();
              } else if (backTo != null) {
                Get.to(() => backTo);
              }
            },
            child: const Text('OK'))
      ],
    );
  }

  static showInfoDialog(String textContent, {bool? isGoBack, Widget? backTo}) {
    return Get.defaultDialog(
      title: '',
      barrierDismissible: false,
      backgroundColor: Colors.white,
      content: SizedBox(
          height: displayHeight(Get.context!) * 0.06,
          child: Center(
              child: SingleChildScrollView(
                child: Text(
                            textContent,
                            textAlign: TextAlign.center,
                          ),
              ))),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(Get.context!).pop();
              if (isGoBack != null && isGoBack) {
                Get.back();
              } else if (backTo != null) {
                Get.offAll(() => backTo);
              }
            },
            child: const Text('OK'))
      ],
    );
  }

  static showConfirmDialog(String textContent,Function() onConfirm){
    return Get.defaultDialog(
      title: '',
      barrierDismissible: false,
      backgroundColor: Colors.white,
      content: SizedBox(
          height: displayHeight(Get.context!) * 0.06,
          child: Center(
              child: SingleChildScrollView(
                child: Text(
                            textContent,
                            textAlign: TextAlign.center,
                          ),
              ))),
      actions: [],
      confirm:  TextButton(child: const Text('Oui',style: TextStyle(color: redColor),) ,onPressed: () => onConfirm(),),
      cancel: TextButton(child: const Text('Annuler') ,onPressed: () => Get.back(),),      
    );

  }
}
