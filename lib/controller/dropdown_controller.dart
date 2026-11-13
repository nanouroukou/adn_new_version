import 'package:cherifla/models/adherent_model.dart';
import 'package:cherifla/models/comity_model.dart';
import 'package:cherifla/models/dipole.dart';
import 'package:cherifla/models/federation_model.dart';
import 'package:cherifla/models/piece_model.dart';
import 'package:cherifla/models/section_model.dart';
import 'package:cherifla/models/sub_section_model.dart';
import 'package:cherifla/services/api/api.services.dart';
import 'package:cherifla/utils/log/logger.dart';
import 'package:cherifla/utils/format/phone_format.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:get/get.dart';

class DropdownController extends GetxController {
  final apiServices = ApiServices();
  var federationList = <RegionalFederation>[].obs;
  var codeAdherent = "".obs;
  final codeCountry = "".obs;
  var typeList = <TypePiece>[].obs;
  var diplomeList = <Diplome>[].obs;

  var picture =
      "https://img.freepik.com/vecteurs-premium/illustration-vectorielle-plate-echelle-gris-profil-utilisateur-avatar-image-profil-personne-icone-convient-pour-profils-medias-sociaux-icones-economiseurs-ecran-comme-modelex9xa_719432-1229.jpg?semt=ais_hybrid"
          .obs;
  var identityDocImage =
      "https://img.freepik.com/vecteurs-premium/illustration-vectorielle-plate-echelle-gris-profil-utilisateur-avatar-image-profil-personne-icone-convient-pour-profils-medias-sociaux-icones-economiseurs-ecran-comme-modelex9xa_719432-1229.jpg?semt=ais_hybrid"
          .obs;
  var sexList = <dynamic>[].obs;
  var phoneNumberController = TextEditingController();
  var nomController = TextEditingController();
  var prenomController = TextEditingController();
  var identityCardNumberController = TextEditingController();
  var sexController = TextEditingController();
  var identityTypeController = TextEditingController();
  var dateNaissanceController = TextEditingController();
  var dateAdhesionController = TextEditingController();
  var prenomPereController = TextEditingController();
  var nomPereController = TextEditingController();

  var indicePaysController = TextEditingController();
  var prenomMereController = TextEditingController();
  var nomMereController = TextEditingController();
  final nationalityController = TextEditingController();
  final placeOfBirthdayController = TextEditingController();
  final professionController = TextEditingController();
  final posteController = TextEditingController();

  final personToContactController = TextEditingController();

  /// Indicatif du numéro de la personne à contacter (ex. `223`).
  String contactDialCode = '';

  // var subSectionList = <SubSection>[].obs;
  // var comityList = <Comity>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadReferenceData();
  }

  /// Vrai pendant le chargement des listes (sexes, types de pièce, diplômes).
  final referenceLoading = false.obs;
  Future<void>? _referenceRequest;

  bool get hasReferenceData =>
      sexList.isNotEmpty && typeList.isNotEmpty && diplomeList.isNotEmpty;

  /// Charge en une fois les listes utilisées par les formulaires.
  /// Appelé au lancement (si l'agent est connecté), après la connexion
  /// et à l'ouverture des formulaires. Ne refait pas l'appel si les listes
  /// sont déjà là, et ne lance jamais deux chargements en même temps.
  Future<void> loadReferenceData({bool force = false}) {
    if (!force && hasReferenceData) return Future.value();
    return _referenceRequest ??=
        _fetchReferenceData().whenComplete(() => _referenceRequest = null);
  }

  Future<void> _fetchReferenceData() async {
    referenceLoading.value = true;
    try {
      // Les trois appels partent en parallèle
      final sexRequest = apiServices.getSex();
      final typeRequest = apiServices.getIdentityType();
      final diplomeRequest = apiServices.getDiplome();

      final sexes = await sexRequest;
      final types = await typeRequest;
      final diplomes = await diplomeRequest;

      if (sexes != null) sexList.assignAll(sexes);
      if (types != null) typeList.assignAll(types);
      if (diplomes != null) diplomeList.assignAll(diplomes);
      logger().d(
          'Listes chargées : ${sexList.length} sexes, ${typeList.length} types, ${diplomeList.length} diplômes');
    } catch (e) {
      logger().e(e.toString());
    } finally {
      referenceLoading.value = false;
      update();
    }
  }

  var selectedFederation = Rxn<RegionalFederation>(null);
  var selectedTypeUpdate = Rxn<TypePiece>();
  var selectedTypeRegister = Rxn<TypePiece>();

  var selectedDiplomeUpdate = Rxn<Diplome>();

  var selectedDiplomeRegister = Rxn<Diplome>();

  var selectedSexUpdate = Rxn<String>();
  var selectedSexRegister = Rxn<String>();

  var selectedSection = Rxn<Section>();
  var selectedSubSection = Rxn<SubSection>();
  var selectedComity = Rxn<Comity>();

  var newSelectedFederation = Rxn<RegionalFederation>(null);
  var newSelectedSection = Rxn<Section>();
  var newSelectedSubSection = Rxn<SubSection>();
  var newSelectedComity = Rxn<Comity>();

  ///Initialise les données des listes déroulantes.
  Future init() async {
    reset();
    return loadReferenceData();
  }

  Future initType() => loadReferenceData();

  ///Definit les donnees initiales du dropdown. Prend en parametre un objet de type [Adherent].
  void setInitialData(Adherent adh) {
    codeAdherent.value = adh.codeAdherent ?? "";
    codeAdherent.value = adh.codeAdherent ?? "";
    identityDocImage.value = adh.identityDocImage.toString();
    phoneNumberController.text = PhoneFormat.digits(adh.phone);
    nomController.text = adh.nom ?? "";
    prenomController.text = adh.prenom ?? "";
    identityCardNumberController.text = adh.identityCardNumber ?? "";
    selectedSexUpdate.value = adh.sexe ?? "";
    selectedTypeUpdate.value = adh.identityType;
    selectedDiplomeUpdate.value = adh.degree;
    picture.value = adh.picture.toString();
    indicePaysController.text = adh.indicePays ?? "";
    dateNaissanceController.text = adh.dateNaissance ?? "";
    prenomPereController.text = adh.prenomPere ?? "";
    prenomMereController.text = adh.prenomMere ?? "";
    nomMereController.text = adh.nomMere ?? "";
    nomPereController.text = adh.nomPere ?? "";
    dateAdhesionController.text = adh.adhesionDate.toString();
    professionController.text = adh.profession ?? "";
    codeCountry.value = adh.indicePays ?? "";
    posteController.text = adh.position ?? "";
    placeOfBirthdayController.text = adh.placeOfBirthday ?? "";
    nationalityController.text = adh.nationality ?? "";
    // Stocké au format international (+22376123456) : on sépare l'indicatif.
    final contact = PhoneFormat.split(
        adh.personToContact, countries.map((c) => c.dialCode));
    contactDialCode = contact.dialCode;
    personToContactController.text = contact.number;

    update();
  }

  void onSelectFederation(RegionalFederation federation) async {
    selectedFederation.value = federation;
    selectedSection.value = null;
    selectedSubSection.value = null;
    selectedComity.value = null;
    update();
  }

  void onSelectType(TypePiece type) async {
    selectedTypeRegister.value = type;
    selectedTypeUpdate.value = type;

    update();
  }

  void onSelectDipolem(Diplome diplome) async {
    selectedDiplomeRegister.value = diplome;
    selectedDiplomeUpdate.value = diplome;

    update();
  }

  void onSelectSex(String sex) async {
    selectedSexUpdate.value = sex;
    selectedSexRegister.value = sex;
    update();
  }

  ///Actulisation manuelle des valeurs des variables Rx<?>  du controlleur DropdownController
  void refreshData() {
    selectedDiplomeRegister.refresh();
    selectedTypeRegister.refresh();
    selectedDiplomeUpdate.refresh();
    selectedTypeUpdate.refresh();
    selectedSexRegister.refresh();
    selectedSexUpdate.refresh();
  }

  void reset() {
    logger().w('dropdown controller reset evoked');
    update();
    selectedDiplomeRegister.refresh();
    selectedTypeRegister.refresh();
    selectedDiplomeUpdate.refresh();
    selectedTypeUpdate.refresh();
    selectedSexRegister.refresh();
    selectedSexUpdate.refresh();
  }
}
