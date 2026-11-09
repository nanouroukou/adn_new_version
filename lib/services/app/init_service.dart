import 'package:cherifla/controller/dropdown_controller.dart';
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

  /// Précharge les listes des formulaires (sexes, types de pièce, diplômes).
  /// Sans délai : appelé dès qu'un agent est connecté.
  Future preloadEssentialData() async {
    logger().d('Préchargement des listes');
    return _dropdownController.loadReferenceData();
  }
}
