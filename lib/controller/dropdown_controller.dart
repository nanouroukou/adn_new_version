import 'package:cherifla/models/adherent_model.dart';
import 'package:cherifla/models/comity_model.dart';
import 'package:cherifla/models/dipole.dart';
import 'package:cherifla/models/federation_model.dart';
import 'package:cherifla/models/piece_model.dart';
import 'package:cherifla/models/section_model.dart';
import 'package:cherifla/models/sub_section_model.dart';
import 'package:cherifla/services/api/api.services.dart';
import 'package:cherifla/utils/log/logger.dart';
import 'package:flutter/material.dart';
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
  var indicePaysController = TextEditingController();
  var prenomMereController = TextEditingController();
  var nomMereController = TextEditingController();
  final nationalityController = TextEditingController();
  final placeOfBirthdayController = TextEditingController();
  final professionController = TextEditingController();
  final posteController = TextEditingController();

  final personToContactController = TextEditingController();

  // var subSectionList = <SubSection>[].obs;
  // var comityList = <Comity>[].obs;

  @override
  void onInit() {
    init();
    initType();
    super.onInit();
  }

  var selectedFederation = Rxn<RegionalFederation>(null);
  var selectedType = Rxn<TypePiece>();
  var selectedDiplome = Rxn<Diplome>();

  var selectedSex = Rxn<String>();
  var selectedSection = Rxn<Section>();
  var selectedSubSection = Rxn<SubSection>();
  var selectedComity = Rxn<Comity>();

  var newSelectedFederation = Rxn<RegionalFederation>(null);
  var newSelectedSection = Rxn<Section>();
  var newSelectedSubSection = Rxn<SubSection>();
  var newSelectedComity = Rxn<Comity>();

  ///Initialise toutes les donnees necessaires du dropdown (Liste des federations). Obligatoire pour rendre fonctionnel
  ///le dropdown.
  Future init() async {
    try {
      reset();
      apiServices
          .getIdentityType()
          .then((value) => typeList.value = value ?? []);
      apiServices.getDiplome().then((value) => diplomeList.value = value ?? []);
      apiServices.getSex().then((value) => sexList.value = value ?? []);
    } catch (e) {
      logger().e(e.toString());
    }
  }

  Future initType() async {
    try {
      reset();
      apiServices
          .getIdentityType()
          .then((value) => typeList.value = value ?? []);

      apiServices.getSex().then((value) => sexList.value = value ?? []);
    } catch (e) {
      logger().e(e.toString());
    }
  }

  ///Definit les donnees initiales du dropdown. Prend en parametre un objet de type [Adherent].
  void setInitialData(Adherent adh) {
    codeAdherent.value = adh.codeAdherent!;
    codeAdherent.value = adh.codeAdherent!;
    identityDocImage.value = adh.identityDocImage.toString();
    phoneNumberController.text = adh.phone!.replaceAll(" ", "");
    nomController.text = adh.nom!;
    prenomController.text = adh.prenom!;
    identityCardNumberController.text = adh.identityCardNumber!;
    selectedSex.value = adh.sexe!;
    selectedType.value = adh.identityType;
    selectedDiplome.value = adh.degree;
    picture.value = adh.picture.toString();
    indicePaysController.text = adh.indicePays!;
    dateNaissanceController.text = adh.dateNaissance!;
    prenomPereController.text = adh.prenomPere!;
    prenomMereController.text = adh.prenomMere!;
    nomMereController.text = adh.nomMere!;
    dateAdhesionController.text = adh.adhesionDate.toString();
    professionController.text = adh.profession!;
    codeCountry.value = adh.indicePays!;
    posteController.text = adh.profession!;
    placeOfBirthdayController.text = adh.placeOfBirthday!;
    nationalityController.text = adh.nationality!;
    personToContactController.text = adh.personToContact!;

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
    selectedType.value = type;
    update();
  }

  void onSelectDipolem(Diplome diplome) async {
    selectedDiplome.value = diplome;
    update();
  }

  void onSelectSex(String sex) async {
    selectedSex.value = sex;
    update();
  }

  void onSelectSection(Section section) async {
    selectedSection.value = section;
    selectedSubSection.value = null;
    selectedSubSection.refresh();
    selectedComity.value = null;
    update();
  }

  void onSelectSubSection(SubSection subSection) async {
    selectedSubSection.value = subSection;
    selectedComity.value = null;
    update();
  }

  void onSelectComity(Comity comity) async {
    selectedComity.value = comity;
    update();
  }

  ///Actulisation manuelle des valeurs des variables Rx<?>  du controlleur DropdownController
  void refreshData() {
    selectedDiplome.refresh();
    selectedType.refresh();
    selectedSex.refresh();
  }

  void reset() {
    logger().w('dropdown controller reset evoked');
    update();
  }
}
