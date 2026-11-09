import 'package:flutter/material.dart';
import 'package:get/get.dart';

AppBar buildAppBar({required String title, List<Widget>? actions}) {
  return AppBar(
    title: Text(
      title,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
    ),
    leading: IconButton(
      icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
      tooltip: 'Retour',
      onPressed: () => Get.back(),
    ),
    actions: actions,
  );
}
