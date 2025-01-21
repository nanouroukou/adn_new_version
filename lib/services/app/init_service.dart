import 'package:cherifla/controller/dropdown_controller.dart';
import 'package:cherifla/services/api/api.services.dart';
import 'package:cherifla/utils/log/logger.dart';
import 'package:get/get.dart';

class InitService {
  //  une instance privée statique de la classe
  static final InitService _instance = InitService._internal();

  // final _api = ApiServices();
  final _dropdownController = Get.put(DropdownController());

  factory InitService() {
    return _instance;
  }

  InitService._internal();

  Future preloadEssentialData() async {
    Future.delayed(const Duration(seconds: 4), () {
      _dropdownController.init();
      logger().d('Prechargement liste federation');
    });
  }
}
