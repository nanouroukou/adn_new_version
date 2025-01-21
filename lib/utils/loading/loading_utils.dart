import 'package:cherifla/utils/color/color.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

SpinKitFadingFour getLoader({double? size}) {
  final spinkit = SpinKitFadingFour(
    color: primaryColor,
    size: size ?? Get.height * 0.08,
  );
  return spinkit;
}
