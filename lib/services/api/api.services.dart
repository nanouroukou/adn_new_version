import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:cherifla/constants/app_texts.dart';
import 'package:cherifla/controller/dropdown_controller.dart';
import 'package:cherifla/models/adherent_creation.dart';
import 'package:cherifla/models/adherent_model.dart';
import 'package:cherifla/models/comity_model.dart';
import 'package:cherifla/models/dipole.dart';
import 'package:cherifla/models/federation_model.dart';
import 'package:cherifla/models/piece_model.dart';
import 'package:cherifla/models/section_model.dart';
import 'package:cherifla/models/sub_section_model.dart';
import 'package:cherifla/screens/changeComite/change_comite.dart';
import 'package:cherifla/screens/home/homeScreen.dart';
import 'package:cherifla/screens/login/login.dart';
import 'package:cherifla/services/authentification/auth.service.dart';
import 'package:cherifla/utils/alert/alert.util.dart';
import 'package:cherifla/utils/format/date.dart';
import 'package:cherifla/utils/log/logger.dart';
import 'package:cherifla/utils/security/token.util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    hide Options;
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';

import '../../screens/inscription/valid.dart';

class ApiServices extends GetxController {
  // Constructeur privé
  ApiServices._internal();
  // Le factory constructeur renvoie toujours la même instance
  factory ApiServices() {
    return _instance;
  }
  // final dropdownController = Get.put(DropdownController());
  // DateFormat formatter = DateFormat("yyyy-mm-dd");

  var idEventController = TextEditingController();
  var idEvent = "".obs;

  DateFormat formatter = DateFormat("yyyy-mm-dd");
  static final ApiServices _instance = ApiServices._internal();
  static String BASE_URL = "https://api24.sama.com.ml";
  final _secureStorage = const FlutterSecureStorage();
  var code = "".obs;
  var link = "".obs;
  var phone = "".obs;

  Future<Map<String, String>?> buildHeaders() async {
    //
    String? token = await _secureStorage.read(key: 'token');
    String? tokenExpirationDate =
        await _secureStorage.read(key: 'expirationDate');

    if (token != null && !isTokenExpired(tokenExpirationDate!)) {
      logger().i('Token trouve et valide');
      Map<String, String> headers = {
        'Content-type': 'application/json;charset=UTF-8',
        'Accept': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      };
      return headers;
    } else {
      logger().w('Token non trouvé ou invalide ou expirée');
      // Alert.showConfirmDialog(Texts.errorInvalidToken, () async {
      //   AuthService().clearAuthStorage();
      //   Get.off(() => const LoginScreen());
      // });
      return null;
    }
  }

  Future<List<RegionalFederation>?> getListRegionalFederal() async {
    try {
      final response = await http.get(
          Uri.parse("$BASE_URL/api/regional-federal"),
          headers: await buildHeaders());
      if (response.statusCode == 200) {
        logger().i('Liste federation regional OK');
        final data = jsonDecode(response.body);
        if (data['status'] == 1) {
          List regionalsFederation = data['body'];
          return regionalsFederation
              .map((json) => RegionalFederation.fromJson(json))
              .toList();
        } else {
          logger().e(data['message']);
          Alert.showErrorDialog(data['message']);

          return null;
        }
      } else {
        logger().e(response.body);
        Alert.showErrorDialog("${Texts.errorNetwork} (${response.statusCode})");

        return null;
      }
    } on SocketException catch (e) {
      Alert.showErrorDialog(Texts.errorNoInternet);
      logger().e(e.toString());
    } on Exception catch (e) {
      Alert.showErrorDialog(Texts.errorNetwork);
      Alert.showErrorDialog(e.toString());
    }
    return null;
  }

  Future<List<RegionalFederation>?> getListRegionalFederalNa() async {
    try {
      final response = await http.get(
          Uri.parse("$BASE_URL/api/regional-federal"),
          headers: await buildHeaders());
      if (response.statusCode == 200) {
        logger().i('Liste federation regional OK');
        final data = jsonDecode(response.body);
        if (data['status'] == 1) {
          List regionalsFederation = data['body'];
          return regionalsFederation
              .map((json) => RegionalFederation.fromJson(json))
              .toList();
        } else {
          logger().e(data['message']);

          return null;
        }
      } else {
        logger().e(response.body);

        return null;
      }
    } on SocketException catch (e) {
      logger().e(e.toString());
    } on Exception catch (e) {
      logger().e(e.toString());
    }
    return null;
  }

  Future<File?> generateQrcode(String code) async {
    try {
      final response = await http.get(
          Uri.parse("$BASE_URL/api/adherent/generate?text=${code}"),
          headers: await buildHeaders());
      if (response.statusCode == 200) {
        logger().i('Liste federation regional OK');
        final data = jsonDecode(response.body);
      } else {
        logger().e(response.body);

        return null;
      }
    } on SocketException catch (e) {
      logger().e(e.toString());
    } on Exception catch (e) {
      logger().e(e.toString());
    }
    return null;
  }

  Future<List<Section>?> getListSections() async {
    try {
      final response = await http.get(Uri.parse("$BASE_URL/api/section"),
          headers: await buildHeaders());
      if (response.statusCode == 200) {
        logger().i('Liste section section OK');
        final data = jsonDecode(response.body);
        if (data['status'] == 1) {
          List sections = data['body'];
          return sections.map((json) => Section.fromJson(json)).toList();
        }
        return [];
      } else {
        logger().e(response.body);
        return null;
      }
    } on SocketException catch (e) {
      Alert.showErrorDialog('Connexion à internet impossible !');
      logger().e(e.toString());
    } on Exception catch (e) {
      Alert.showErrorDialog('Erreur inattendue !');
      Alert.showErrorDialog(e.toString());
    }
    return null;
  }

  Future<List<SubSection>?> getListSousSection() async {
    try {
      final response = await http.get(Uri.parse("$BASE_URL/api/sub-section"),
          headers: await buildHeaders());
      if (response.statusCode == 200) {
        logger().i('Liste  sous section OK');
        final data = jsonDecode(response.body);
        if (data['status'] == 1) {
          List subSections = data['body'];
          return subSections.map((json) => SubSection.fromJson(json)).toList();
        }
        return [];
      } else {
        logger().e(response.body);
        return null;
      }
    } on SocketException catch (e) {
      Alert.showErrorDialog('Connexion à internet impossible !');
      logger().e(e.toString());
    } on Exception catch (e) {
      Alert.showErrorDialog('Erreur inattendue !');
      Alert.showErrorDialog(e.toString());
    }
    return null;
  }

  Future inscrireAdherent(AdherentCreation body) async {
    final bodyJson = jsonEncode(body.toJson());
    logger().i('body nouveau adherant $bodyJson');
    try {
      final response = await http.post(Uri.parse("$BASE_URL/api/adherent"),
          body: bodyJson, headers: await buildHeaders());
      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);
        if (responseJson['status'] == 1) {
          logger().d('Inscription adh ${responseJson['message']}');
          Alert.showInfoDialog(responseJson['message'],
              backTo: const HomeScreen());
          return 1;
        } else {
          logger().e(response.body);
          Alert.showInfoDialog(responseJson['message']);
          return 0;
        }
      } else {
        Alert.showErrorDialog('Erreur inattendue !');
        logger().e(response.body);
        return response.body;
      }
    } on SocketException catch (e) {
      Alert.showErrorDialog('Connexion à internet impossible !');
      logger().e(e.toString());
    } on Exception catch (e) {
      Alert.showErrorDialog('Erreur inattendue !');
      Alert.showErrorDialog(e.toString());
    }
  }

  Future<Adherent?> getAdherentByCode(String code,
      {bool showAlert = true}) async {
    try {
      var bodyJson = jsonEncode({"codeAdherent": code});
      final response = await http.post(
          Uri.parse('$BASE_URL/api/adherent/search'),
          body: bodyJson,
          headers: await buildHeaders());
      if (response.statusCode == 200) {
        final bodyJson = jsonDecode(response.body);
        if (bodyJson['status'] == 1) {
          List contents = bodyJson['body']['content'];
          if (contents.isNotEmpty) {
            final adh = Adherent.fromJson(bodyJson['body']['content'][0]);
            print("=========================================");
            print(adh);
            logger().d('Adherent OK');
            logger().d(bodyJson);
            return adh;
          } else {
            logger().d('Adherent OK MAIS PAS DE CORRESPONDANCE');
            if (showAlert) {
              Alert.showErrorDialog('Aucun adherant trouvé');
            }
            return null;
          }
        } else {
          if (showAlert) {
            Alert.showErrorDialog(bodyJson['message']);
          }
          logger().e(response.body);
          return null;
        }
      } else {
        if (showAlert) {
          Alert.showErrorDialog(
              'Erreur inattendue ![fetch adherent] (status ${response.statusCode})');
        }
        logger().e(response.body);
        return null;
      }
    } on SocketException catch (e) {
      Alert.showErrorDialog('Connexion à internet impossible !');
      logger().e(e.toString());
    } on Exception catch (e) {
      Alert.showErrorDialog('Erreur inattendue ![fetch adherent] !');
      logger().e(e.toString());
    }
    return null;
  }

  Future<Adherent?> getAdherentByCodeEvent(String id, String code,
      {bool showAlert = true}) async {
    print("qrcodehgjggjhgh");
    try {
      var bodyJson = jsonEncode({
        "event": {"id": id},
        "codeAdherent": code
      });
      final response = await http.post(
          Uri.parse('$BASE_URL/api/event/validate-adh-to-event'),
          body: bodyJson,
          headers: await buildHeaders());
      if (response.statusCode == 200) {
        final bodyJson = jsonDecode(response.body);
        if (bodyJson['status'] == 1) {
          Alert.showInfoDialog(bodyJson['message']);
        } else {
          if (showAlert) {
            Alert.showErrorDialog(bodyJson['message']);
          }
          logger().e(response.body);
          return null;
        }
      } else {
        if (showAlert) {
          Alert.showErrorDialog(
              'Erreur inattendue ![fetch adherent] (status ${response.statusCode})');
        }
        logger().e(response.body);
        return null;
      }
    } on SocketException catch (e) {
      Alert.showErrorDialog('Connexion à internet impossible !');
      logger().e(e.toString());
    } on Exception catch (e) {
      Alert.showErrorDialog('Erreur inattendue ![fetch adherent] !');
      logger().e(e.toString());
    }
    return null;
  }

  Future changeComity(
    String codeAdherent,
    RegionalFederation federation,
    Section section,
    SubSection subSection,
    Comity comity,
  ) async {
    try {
      var payloadJson = jsonEncode({
        "regionalFederation": federation,
        "section": section,
        'subSection': subSection,
        'comity': comity
      });
      logger().d("Change Comity Request $payloadJson");
      final response = await http.put(
          Uri.parse('$BASE_URL/api/adherent/change-comity/$codeAdherent'),
          body: payloadJson,
          headers: await buildHeaders());

      if (response.statusCode == 200) {
        final bodyJson = jsonDecode(response.body);
        if (bodyJson['status'] == 1) {
          Alert.showInfoDialog(bodyJson['message'], backTo: const HomeScreen());
          logger().d('changement comity reussie. Code adh $codeAdherent');
        } else {
          Alert.showErrorDialog(bodyJson['message']);
          logger().e(bodyJson['message']);
        }
      } else {
        Alert.showErrorDialog(
            'Erreur inattendue !(status ${response.statusCode})');
        logger().e('Erreur inattendue ![change comity] ! ${response.body}');
      }
    } on SocketException catch (e) {
      Alert.showErrorDialog('Connexion à internet impossible !');
      logger().e(e.toString());
    } on Exception catch (e) {
      Alert.showErrorDialog('Erreur inattendue ![change comity] !');
      logger().e(e.toString());
    }
    return null;
  }

  Future updateData(Adherent adherent) async {
    try {
      var payloadJson = jsonEncode({
        "nom": adherent.nom,
        "indicePays": adherent.indicePays,
        "prenom": adherent.prenom,
        "phone": adherent.phone,
        "dateNaissance": formatter.format(parseFrDate(adherent.dateNaissance!)),
        "adhesionDate": formatter.format(parseFrDate(adherent.adhesionDate!)),
        "prenomPere": adherent.prenomPere,
        "prenomMere": adherent.prenomMere,
        "nomMere": adherent.nomMere,
        "profession": adherent.profession,
        "personToContact": adherent.personToContact,
        "placeOfBirthday": adherent.placeOfBirthday,
        "nationality": adherent.nationality,
        "sexe": adherent.sexe,
        "identityType": adherent.identityType,
        "identityCardNumber": adherent.identityCardNumber,
      });

      final response = await http.put(
          Uri.parse(
              '$BASE_URL/api/adherent/update-profil/${adherent.codeAdherent}'),
          body: payloadJson,
          headers: await buildHeaders());

      if (response.statusCode == 200) {
        final bodyJson = jsonDecode(response.body);
        if (bodyJson['status'] == 1) {
          Alert.showInfoDialog(bodyJson['message'], backTo: const HomeScreen());
          logger().d(
              'changement comity reussie. Code adh ${adherent.codeAdherent}');
        } else {
          Alert.showErrorDialog(bodyJson['message']);
          logger().e(bodyJson['message']);
        }
      } else {
        Alert.showErrorDialog(
            'Erreur inattendue !(status ${response.statusCode})');
        logger().e('Erreur inattendue ![change comity] ! ${response.body}');
      }
    } on SocketException catch (e) {
      Alert.showErrorDialog('Connexion à internet impossible !');
      logger().e(e.toString());
    } on Exception catch (e) {
      Alert.showErrorDialog('Erreur inattendue ![change comity] !');
      logger().e(e.toString());
    }
    return null;
  }

  Future changePassword(
    String oldPassword,
    String newPassword,
    String confirmPassword,
  ) async {
    try {
      var payloadJson = jsonEncode({
        "oldPassword": oldPassword,
        "newPassword": newPassword,
        'confirmPassword': confirmPassword,
      });
      logger().d("Change Comity Request $payloadJson");
      final response = await http.post(
          Uri.parse('$BASE_URL/api/users/change-password'),
          body: payloadJson,
          headers: await buildHeaders());

      if (response.statusCode == 200) {
        final bodyJson = jsonDecode(response.body);
        if (bodyJson['status'] == 1) {
          Alert.showInfoDialog(bodyJson['message'],
              backTo: const LoginScreen());
        } else {
          Alert.showErrorDialog(bodyJson['message']);
          logger().e(bodyJson['message']);
        }
      } else {
        Alert.showErrorDialog(
            'Erreur inattendue !(status ${response.statusCode})');
        logger().e('Erreur inattendue ![change comity] ! ${response.body}');
      }
    } on SocketException catch (e) {
      Alert.showErrorDialog('Connexion à internet impossible !');
      logger().e(e.toString());
    } on Exception catch (e) {
      Alert.showErrorDialog('Erreur inattendue ![change comity] !');
      logger().e(e.toString());
    }
    return null;
  }

  Future<List<TypePiece>?> getIdentityType() async {
    try {
      final response = await http.get(
          Uri.parse('$BASE_URL/api/adherent/identity-list'),
          headers: await buildHeaders());
      if (response.statusCode == 200) {
        final bodyJson = jsonDecode(response.body);
        if (bodyJson['status'] == 1) {
          print("le dat sont ${bodyJson['status']}");
          List types = bodyJson['body'];
          return types.map((json) => TypePiece.fromJson(json)).toList();
          // logger().d('Historique OK');
          // return types;
        } else {
          Alert.showErrorDialog(bodyJson['message']);
          logger().e(response.body);
          return null;
        }
      } else {
        // Alert.showErrorDialog(
        //     'Erreur inattendue ![fetch adherents piece type] (status ${response.statusCode})');
        // logger().e(response.body);
        return null;
      }
    } on SocketException catch (e) {
      Alert.showErrorDialog('Connexion à internet impossible !');
      logger().e(e.toString());
    } on Exception catch (e) {
      Alert.showErrorDialog('Erreur inattendue ![fetch historique] !');
      logger().e(e.toString());
    }
    return null;
  }

  Future<List<dynamic>?> getSex() async {
    try {
      final response = await http.get(
          Uri.parse('$BASE_URL/api/adherent/genders'),
          headers: await buildHeaders());
      if (response.statusCode == 200) {
        final bodyJson = jsonDecode(response.body);
        print("les sexes sont + ${bodyJson['body']}");
        List sexList = bodyJson['body'];

        if (bodyJson['status'] == 1) {
          List sexList = bodyJson['body'];
          return sexList;
        } else {
          // Alert.showErrorDialog(bodyJson['message']);
          // logger().e(response.body);
          return null;
        }
      } else {
        // Alert.showErrorDialog(
        //     'Erreur inattendue ![fetch adherents piece type] (status ${response.statusCode})');
        // logger().e(response.body);
        return null;
      }
    } on SocketException catch (e) {
      Alert.showErrorDialog('Connexion à internet impossible !');
      logger().e(e.toString());
    } on Exception catch (e) {
      Alert.showErrorDialog('Erreur inattendue ![fetch historique] !');
      logger().e(e.toString());
    }
    return null;
  }

  Future<List<dynamic>?> getHistorique() async {
    try {
      var body =
          jsonEncode({"registerAgentId": await _secureStorage.read(key: 'id')});
      final response = await http.post(
          Uri.parse('$BASE_URL/api/adherent/search'),
          body: body,
          headers: await buildHeaders());
      if (response.statusCode == 200) {
        final bodyJson = jsonDecode(response.body);
        if (bodyJson['status'] == 1) {
          List events = bodyJson['body']['content'];
          logger().d('Historique OK');
          return events;
        } else {
          // Alert.showErrorDialog(bodyJson['message']);
          // logger().e(response.body);
          return null;
        }
      } else {
        Alert.showErrorDialog(
            'Erreur inattendue ![fetch adherents historique] (status ${response.statusCode})');
        logger().e(response.body);
        return null;
      }
    } on SocketException catch (e) {
      Alert.showErrorDialog('Connexion à internet impossible !');
      logger().e(e.toString());
    } on Exception catch (e) {
      Alert.showErrorDialog('Erreur inattendue ![fetch historique] !');
      logger().e(e.toString());
    }
    return null;
  }

  Future<List<Diplome>?> getDiplome() async {
    try {
      final response = await http.post(
          Uri.parse('$BASE_URL/api/study-level/search'),
          headers: await buildHeaders());
      if (response.statusCode == 200) {
        final bodyJson = jsonDecode(response.body);
        if (bodyJson['status'] == 1) {
          print("le dat sont ${bodyJson['status']}");
          List types = bodyJson['body'];
          return types.map((json) => Diplome.fromJson(json)).toList();
          // logger().d('Historique OK');
          // return types;
        } else {
          Alert.showErrorDialog(bodyJson['message']);
          logger().e(response.body);
          return null;
        }
      } else {
        // Alert.showErrorDialog(
        //     'Erreur inattendue ![fetch adherents piece type] (status ${response.statusCode})');
        // logger().e(response.body);
        return null;
      }
    } on SocketException catch (e) {
      Alert.showErrorDialog('Connexion à internet impossible !');
      logger().e(e.toString());
    } on Exception catch (e) {
      Alert.showErrorDialog('Erreur inattendue ![fetch historique] !');
      logger().e(e.toString());
    }
    return null;
  }

  Future<List<dynamic>?> getEvenement() async {
    try {
      var body =
          jsonEncode({"registerAgentId": await _secureStorage.read(key: 'id')});
      final response = await http.post(Uri.parse('$BASE_URL/api/event/search'),
          body: body, headers: await buildHeaders());
      if (response.statusCode == 200) {
        final bodyJson = jsonDecode(response.body);
        if (bodyJson['status'] == 1) {
          List adherents = bodyJson['body']['content'];
          logger().d('Historique OK');
          return adherents;
        } else {
          Alert.showErrorDialog(bodyJson['message']);
          logger().e(response.body);
          return null;
        }
      } else {
        Alert.showErrorDialog(
            'Erreur inattendue ![fetch adherents historique] (status ${response.statusCode})');
        logger().e(response.body);
        return null;
      }
    } on SocketException catch (e) {
      Alert.showErrorDialog('Connexion à internet impossible !');
      logger().e(e.toString());
    } on Exception catch (e) {
      Alert.showErrorDialog('Erreur inattendue ![fetch historique] !');
      logger().e(e.toString());
    }
    return null;
  }

  Future inscrireAdherentWithImage(
      File file, File identityDoc, AdherentCreation body) async {
    // Récupérer le token et sa date d'expiration

    print("les data${body}");
    String? token = await _secureStorage.read(key: 'token');
    String? tokenExpirationDate =
        await _secureStorage.read(key: 'expirationDate');

    // Validation du token
    if (token != null && !isTokenExpired(tokenExpirationDate!)) {
      var request =
          http.MultipartRequest('POST', Uri.parse('$BASE_URL/api/adherent'));

      request.headers['Authorization'] = 'Bearer $token';

      // Préparer l'image à partir du fichier
      var imageProfile = await http.MultipartFile.fromPath('file', file.path,
          contentType: MediaType.parse(lookupMimeType(file.path)!));

      var imageIdentity = await http.MultipartFile.fromPath(
          'identityDoc', identityDoc.path,
          contentType: MediaType.parse(lookupMimeType(identityDoc.path)!));

      //
      request.files.add(imageProfile);
      request.files.add(imageIdentity);
      logger().d('MIME FICHIER ${lookupMimeType(file.path)}');

      //
      request.files.add(http.MultipartFile.fromString(
        'subscribeMemberReq',
        json.encode(body), // Données JSON
        contentType: MediaType(
            'application', 'json'), // Spécifiez le type MIME pour le JSON
      ));

      //
      http.Response response =
          await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        final bodyJson = jsonDecode(response.body);

        if (bodyJson['status'] == 1) {
          code.value = bodyJson['body']['codeAdherent'];
          link.value = bodyJson['body']['link'];
          phone.value = bodyJson['body']['phone'];

          // Alert.showInfoDialog(resJson['message'],
          Get.offAll(ValidationScreen());
          return bodyJson;
        }

        // if (bodyJson['status'] == 1) {
        //   print("le message st${bodyJson['message']} ");
        //   Get.offAll(ValidationScreen());
        //   // Alert.showInfoDialog(bodyJson['message'], backTo: const HomeScreen());
        // }
        else {
          Alert.showErrorDialog(bodyJson['message']);
          logger().e(bodyJson['message']);
        }
      } else {
        logger().w('INSCRIPTION STATUS NOT 200');
        logger().w('${response.statusCode} : ${response.body}');
        Alert.showErrorDialog(
            "Erreur interne ! (Status ${response.statusCode})");
        return null;
      }
    } else {
      // Gestion du cas où le token est invalide ou expiré
      logger().w('Token non trouvé, invalide ou expiré');
      Alert.showConfirmDialog(Texts.errorInvalidToken, () async {
        AuthService().clearAuthStorage();
        Get.off(() => const LoginScreen());
      });
      return null;
    }
  }

  Future updateAdherentWithImage(
      File file, File identityDoc, AdherentCreation body) async {
    String? token = await _secureStorage.read(key: 'token');
    String? tokenExpirationDate =
        await _secureStorage.read(key: 'expirationDate');

    // Validation du token
    if (token != null && !isTokenExpired(tokenExpirationDate!)) {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('$BASE_URL/api/adherent/${body.codeAdherent}'),
      );

      request.headers['Authorization'] = 'Bearer $token';

      var imageProfile = await http.MultipartFile.fromPath('file', file.path,
          contentType: MediaType.parse(lookupMimeType(file.path)!));

      var imageIdentity = await http.MultipartFile.fromPath(
          'identityDoc', identityDoc.path,
          contentType: MediaType.parse(lookupMimeType(identityDoc.path)!));

      request.files.add(imageProfile);
      request.files.add(imageIdentity);
      request.files.add(http.MultipartFile.fromString(
        'subscribeMemberReq',
        json.encode(body), // Données JSON
        contentType: MediaType(
            'application', 'json'), // Spécifiez le type MIME pour le JSON
      ));

      //
      http.Response response =
          await http.Response.fromStream(await request.send());
      //
      if (response.statusCode == 200) {
        final bodyJson = jsonDecode(response.body);
        if (bodyJson['status'] == 1) {
          Alert.showInfoDialog(bodyJson['message'], backTo: const HomeScreen());
          logger()
              .d('changement comity reussie. Code adh ${body.codeAdherent}');
        } else {
          Alert.showErrorDialog(bodyJson['message']);
          logger().e(bodyJson['message']);
        }
      } else {
        Alert.showErrorDialog(
            'Erreur inattendue !(status ${response.statusCode})');
        logger().e('Erreur inattendue ![change comity] ! ${response.body}');
      }
    }
    return null;
  }

  Future updateAdherentWithOutProfileImage(
      File file, AdherentCreation body) async {
    print("les data${file}");
    String? token = await _secureStorage.read(key: 'token');
    String? tokenExpirationDate =
        await _secureStorage.read(key: 'expirationDate');

    // Validation du token
    if (token != null && !isTokenExpired(tokenExpirationDate!)) {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('$BASE_URL/api/adherent/${body.codeAdherent}'),
      );

      request.headers['Authorization'] = 'Bearer $token';

      var imageProfile = await http.MultipartFile.fromPath('file', file.path,
          contentType: MediaType.parse(lookupMimeType(file.path)!));

      request.files.add(imageProfile);
      request.files.add(http.MultipartFile.fromString(
        'subscribeMemberReq',
        json.encode(body), // Données JSON
        contentType: MediaType(
            'application', 'json'), // Spécifiez le type MIME pour le JSON
      ));

      //
      http.Response response =
          await http.Response.fromStream(await request.send());
      //
      if (response.statusCode == 200) {
        final bodyJson = jsonDecode(response.body);
        if (bodyJson['status'] == 1) {
          Alert.showInfoDialog(bodyJson['message'], backTo: const HomeScreen());
          logger()
              .d('changement comity reussie. Code adh ${body.codeAdherent}');
        } else {
          Alert.showErrorDialog(bodyJson['message']);
          logger().e(bodyJson['message']);
        }
      } else {
        Alert.showErrorDialog(
            'Erreur inattendue !(status ${response.statusCode})');
        logger().e('Erreur inattendue ![change comity] ! ${response.body}');
      }
    }
    return null;
  }

  Future updateAdherentWithOutDocImage(
      File identityDoc, AdherentCreation body) async {
    String? token = await _secureStorage.read(key: 'token');
    String? tokenExpirationDate =
        await _secureStorage.read(key: 'expirationDate');

    // Validation du token
    if (token != null && !isTokenExpired(tokenExpirationDate!)) {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('$BASE_URL/api/adherent/${body.codeAdherent}'),
      );

      request.headers['Authorization'] = 'Bearer $token';

      var imageIdentity = await http.MultipartFile.fromPath(
          'identityDoc', identityDoc.path,
          contentType: MediaType.parse(lookupMimeType(identityDoc.path)!));
      request.files.add(imageIdentity);
      request.files.add(http.MultipartFile.fromString(
        'subscribeMemberReq',
        json.encode(body), // Données JSON
        contentType: MediaType(
            'application', 'json'), // Spécifiez le type MIME pour le JSON
      ));

      //
      http.Response response =
          await http.Response.fromStream(await request.send());
      //
      if (response.statusCode == 200) {
        final bodyJson = jsonDecode(response.body);
        if (bodyJson['status'] == 1) {
          Alert.showInfoDialog(bodyJson['message'], backTo: const HomeScreen());
          logger()
              .d('changement comity reussie. Code adh ${body.codeAdherent}');
        } else {
          Alert.showErrorDialog(bodyJson['message']);
          logger().e(bodyJson['message']);
        }
      } else {
        Alert.showErrorDialog(
            'Erreur inattendue !(status ${response.statusCode})');
        logger().e('Erreur inattendue ![change comity] ! ${response.body}');
      }
    }
    return null;
  }

  Future updateAdherentWithoutImage(AdherentCreation body) async {
    String? token = await _secureStorage.read(key: 'token');
    String? tokenExpirationDate =
        await _secureStorage.read(key: 'expirationDate');
    // Validation du token
    if (token != null && !isTokenExpired(tokenExpirationDate!)) {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('$BASE_URL/api/adherent/${body.codeAdherent}'),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.files.add(http.MultipartFile.fromString(
        'subscribeMemberReq',
        json.encode(body), // Données JSON
        contentType: MediaType(
            'application', 'json'), // Spécifiez le type MIME pour le JSON
      ));

      //
      http.Response response =
          await http.Response.fromStream(await request.send());
      //
      if (response.statusCode == 200) {
        final bodyJson = jsonDecode(response.body);
        if (bodyJson['status'] == 1) {
          Alert.showInfoDialog(bodyJson['message'], backTo: const HomeScreen());
          logger()
              .d('changement comity reussie. Code adh ${body.codeAdherent}');
        } else {
          Alert.showErrorDialog(bodyJson['message']);
          logger().e(bodyJson['message']);
        }
      } else {
        Alert.showErrorDialog(
            'Erreur inattendue !(status ${response.statusCode})');
        logger().e('Erreur inattendue ![change comity] ! ${response.body}');
      }
    }
    return null;
  }
}
