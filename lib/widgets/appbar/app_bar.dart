import 'package:cherifla/utils/color/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

AppBar buildAppBar({ required String title}) {
    return AppBar(
          backgroundColor: primaryColor,
          title:  Text(title,
          maxLines: 2,
          style: const TextStyle(color: Colors.white),),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_outlined),
            color: Colors.white,
            onPressed: () {
              Get.back();
            },
          ),
        );}