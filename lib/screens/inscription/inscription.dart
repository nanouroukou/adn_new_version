import 'dart:io';
import 'dart:math';

import 'package:cherifla/controller/dropdown_controller.dart';
import 'package:cherifla/controller/user.controller.dart';
import 'package:cherifla/models/adherent_creation.dart';
import 'package:cherifla/models/dipole.dart';
import 'package:cherifla/models/piece_model.dart';
import 'package:cherifla/services/api/api.services.dart';
import 'package:cherifla/utils/alert/alert.util.dart';
import 'package:cherifla/utils/color/color.dart';
import 'package:cherifla/utils/format/date.dart';

import 'package:cherifla/utils/format/textFormater.dart';
import 'package:cherifla/utils/loading/loading_utils.dart';
import 'package:cherifla/widgets/common/responsive_stepper.dart';
import 'package:cherifla/widgets/textField/country_sellect.dart';
import 'package:cherifla/widgets/textField/app_dropdown.dart';
import 'package:cherifla/widgets/textField/numberPhone.dart';
import 'package:cherifla/widgets/textField/textFieldWidget.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../utils/log/logger.dart';
import '../../widgets/appbar/app_bar.dart';

class InscriptionScreen extends StatefulWidget {
  const InscriptionScreen({super.key});

  @override
  State<InscriptionScreen> createState() => _InscriptionScreenState();
}

class _InscriptionScreenState extends State<InscriptionScreen> {
  final api = ApiServices();
  FocusNode focusNode = FocusNode();
  final _scrollController = ScrollController();
  final userController = Get.put(UserController());
  final dropdownController = Get.put(DropdownController());
  final apiServices = ApiServices();
  final random = Random.secure();
  final phoneNumberController = TextEditingController();
  final nomController = TextEditingController();
  final prenomController = TextEditingController();
  final identityCardNumberController = TextEditingController();
  final sexController = TextEditingController();
  final identityTypeController = TextEditingController();
  final diplomeeController = TextEditingController();
  final dateNaissanceController = TextEditingController();
  final indicePaysController = TextEditingController();
  final prenomPereController = TextEditingController();
  final prenomMereController = TextEditingController();
  final nomMereController = TextEditingController();
  final nomPereController = TextEditingController();
  final senderName = TextEditingController();
  final senderAddress = TextEditingController();
  final receiverName = TextEditingController();
  final receiverAddress = TextEditingController();
  final nationalityPereController = TextEditingController();
  final placeOfBirthdayController = TextEditingController();
  final professionController = TextEditingController();
  final posteController = TextEditingController();

  final personToContactController = TextEditingController();
  var _showLoading = false;

  var imageFileProfile;
  var imageFileIdentity;
  bool isCompleted = false;

  DateFormat formatter = DateFormat("yyyy-mm-dd");

  final List<GlobalKey<FormState>> formKey = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  int currentStep = 0;

  var dateAdhesion = '';
  var dateNaissanceValue = '';
  var dateAdhesionController = TextEditingController(
      text: DateFormat('dd-MM-yyyy').format(DateTime.now()));

  _onContinue() {
    if (formKey[currentStep].currentState!.validate() &&
        currentStep < (getSteps().length - 1)) {
      setState(() {
        currentStep += 1;
      });
      if (_scrollController.hasClients) _scrollController.jumpTo(0);
    } else if (formKey[currentStep].currentState!.validate() &&
        currentStep == (getSteps().length - 1) &&
        imageFileProfile != null) {
      //ENVOI DU FORMULAIRE
      logger().i('last step valid');
      _onSave();
    } else if (currentStep == (getSteps().length - 1) &&
        imageFileProfile == null) {
      Alert.showInfoDialog(
          'Prenez la photo de la personne avant d\'enregistrer.');
    } else {
      logger().e("current form not valid");
    }
  }

  _onCancel() {
    if (currentStep == 0) {
      null;
    } else {
      setState(() {
        currentStep -= 1;
      });
      if (_scrollController.hasClients) _scrollController.jumpTo(0);
    }
  }

  _onSave() async {
    setState(() {
      _showLoading = true;
    });

    final adh = AdherentCreation(
      nom: nomController.value.text,
      indicePays: indicePaysController.value.text,
      prenom: prenomController.value.text,
      phone: phoneNumberController.value.text,
      dateNaissance:
          formatter.format(parseFrDate(dateNaissanceController.value.text)),
      adhesionDate:
          formatter.format(parseFrDate(dateAdhesionController.value.text)),
      prenomPere: prenomPereController.value.text,
      prenomMere: prenomMereController.value.text,
      nomMere: nomMereController.value.text,
      nomPere: nomPereController.value.text,
      sexe: dropdownController.selectedSexRegister.value,
      nationality: nationalityPereController.value.text,
      placeOfBirthday: placeOfBirthdayController.value.text,
      profession: professionController.value.text,
      position: posteController.value.text,
      personToContact: personToContactController.text,
      identityType: {'id': dropdownController.selectedTypeRegister.value?.id},
      degree: {'id': dropdownController.selectedDiplomeRegister.value?.id},
      identityCardNumber: identityCardNumberController.value.text,
    );

    imageFileIdentity == null
        ? apiServices
            .inscrireAdherentWithoutImage(file: imageFileProfile, body: adh)
            .then(
            (value) {
              setState(() {
                _showLoading = false;
              });
            },
          ).whenComplete(
            () => setState(() {
              _showLoading = false;
            }),
          )
        : apiServices
            .inscrireAdherentWithImage(
                file: imageFileProfile,
                identityDoc: imageFileIdentity,
                body: adh)
            .then(
            (value) {
              setState(() {
                _showLoading = false;
              });
            },
          ).whenComplete(
            () => setState(() {
              _showLoading = false;
            }),
          );
  }

  Future pickImageProfileFromCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      setState(() {
        imageFileProfile = File(image.path);
      });
    } on PlatformException catch (e) {
      logger().e('Erreur survenu $e');
    } on Exception catch (e) {
      logger().e(e);
    }
  }

  Future pickImageIdentityFromCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return imageFileIdentity = image as File?;
      setState(() {
        imageFileIdentity = File(image.path);
      });
    } on PlatformException catch (e) {
      logger().e('Erreur survenu $e');
    } on Exception catch (e) {
      logger().e(e);
    }
  }

  @override
  void initState() {
    super.initState();
    dropdownController.init();
  }

  // @override
  // void initState() {

  //   super.initState();
  // }

  @override
  void dispose() {
    phoneNumberController.dispose();
    nomController.dispose();
    identityCardNumberController.dispose();
    identityTypeController.dispose();
    diplomeeController.dispose();
    sexController.dispose();
    prenomController.dispose();
    prenomPereController.dispose();
    prenomMereController.dispose();
    nomMereController.dispose();
    dateAdhesionController.dispose();
    dateNaissanceController.dispose();
    professionController.dispose();
    posteController.dispose();
    nationalityPereController.dispose();
    placeOfBirthdayController.dispose();
    personToContactController.dispose();
    Future.delayed(
        const Duration(seconds: 2), () => dropdownController.reset());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: surfaceColor,
      appBar: buildAppBar(title: 'Inscription'),
      body: Stack(
        children: [
          ResponsiveStepper(
            steps: getSteps(),
            currentStep: currentStep,
            scrollController: _scrollController,
            loading: _showLoading,
            lastStepLabel: 'Enregistrer',
            onContinue: () => _onContinue(),
            onCancel: () => _onCancel(),
          ),
          if (_showLoading) getLoader()
        ],
      ),
    );
  }

  static const _fieldGap = SizedBox(height: 16);

  /// Champ date (saisie au clavier jj-mm-aaaa ou via le calendrier).
  Widget _dateField({
    required TextEditingController controller,
    required String hint,
    required FormFieldValidator<String> validator,
    required ValueChanged<DateTime> onPicked,
    ValueChanged<String>? onFieldSubmitted,
  }) {
    return TextFormField(
      validator: validator,
      keyboardType: TextInputType.datetime,
      inputFormatters: [TestMaskFormatter(mask: 'xx-xx-xxxx', separator: '-')],
      style: const TextStyle(color: titleTextColor, fontSize: 16),
      controller: controller,
      decoration: appInputDecoration(
        hintText: hint,
        prefix: IconButton(
          tooltip: 'Ouvrir le calendrier',
          icon: const Icon(Icons.calendar_month_outlined),
          onPressed: () async {
            var pickedDate = await showDatePicker(
                context: context,
                firstDate: DateTime(1900),
                lastDate: DateTime.now());
            if (pickedDate != null) onPicked(pickedDate);
          },
        ),
      ),
      onFieldSubmitted: onFieldSubmitted,
      onTap: () => controller.clear(),
    );
  }

  List<FormStep> getSteps() => [
        //----  STEP 1 -------//
        FormStep(
          title: 'Identité',
          content: Form(
            key: formKey[0],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFieldWidget(
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Nom obligatoire';
                    }
                    return null;
                  },
                  controller: nomController,
                  obscure: false,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  onChanged: (value) {},
                  hintText: 'Nom',
                ),
                _fieldGap,
                TextFieldWidget(
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Prénom obligatoire';
                    }
                    return null;
                  },
                  controller: prenomController,
                  obscure: false,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  onChanged: (value) {},
                  hintText: 'Prénom(s)',
                ),
                _fieldGap,
                _buildSexDw(),
                _fieldGap,
                _dateField(
                  controller: dateNaissanceController,
                  hint: 'Date de naissance (jj-mm-aaaa)',
                  validator: (value) {
                    if (value == null || value == '') {
                      return 'Selectionnez la date de naissance';
                    } else if (value.length < 10) {
                      return 'Format invalide';
                    }
                    return null;
                  },
                  onPicked: (pickedDate) {
                    dateNaissanceController.text =
                        DateFormat('dd-MM-yyyy').format(pickedDate);
                    setState(() {
                      dateNaissanceValue =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                    });
                  },
                  onFieldSubmitted: (newValue) async {
                    setState(() {
                      dateNaissanceValue = DateFormat('yyyy-mm-dd')
                          .format(parseFrDate(newValue));
                    });
                  },
                ),
                _fieldGap,
                TextFieldWidget(
                  controller: placeOfBirthdayController,
                  obscure: false,
                  keyboardType: TextInputType.name,
                  onChanged: (value) {},
                  hintText: 'Lieu de naissance',
                ),
              ],
            ),
          ),
        ),

        //----  STEP 2 -------//
        FormStep(
          title: 'Contact et famille',
          content: Form(
            key: formKey[1],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                NumberTextFieldWidget(
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Numero de telephone obligatoire';
                    }
                    return null;
                  },
                  controller: phoneNumberController,
                  obscure: false,
                  keyboardType: TextInputType.phone,
                  onChanged: (value) {},
                  onChangeCountry: (value) {
                    indicePaysController.text = value;
                  },
                  hintText: 'Numéro de téléphone',
                ),
                const SizedBox(height: 4),
                TextFieldWidget(
                  controller: prenomPereController,
                  obscure: false,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  onChanged: (value) {},
                  hintText: 'Prénom(s) du père',
                ),
                _fieldGap,
                TextFieldWidget(
                  controller: nomPereController,
                  obscure: false,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  onChanged: (value) {},
                  hintText: 'Nom du père',
                ),
                _fieldGap,
                TextFieldWidget(
                  controller: prenomMereController,
                  obscure: false,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  onChanged: (value) {},
                  hintText: 'Prénom(s) de la mère',
                ),
                _fieldGap,
                TextFieldWidget(
                  controller: nomMereController,
                  obscure: false,
                  keyboardType: TextInputType.name,
                  onChanged: (value) {},
                  hintText: 'Nom de la mère',
                ),
                _fieldGap,
                _buildTypePieceDw(),
                _fieldGap,
                TextFieldWidget(
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'numero de la piece d\'identite obligatoire';
                    }
                    return null;
                  },
                  controller: identityCardNumberController,
                  obscure: false,
                  keyboardType: TextInputType.name,
                  onChanged: (value) {},
                  hintText: 'Numéro de la pièce d\'identité',
                ),
              ],
            ),
          ),
        ),

        //----  STEP 3 -------//
        FormStep(
          title: 'Profession et adhésion',
          content: Form(
            key: formKey[2],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CountryTextFieldWidget(
                  ontap: () => {
                    showCountryPicker(
                        context: context,
                        onSelect: (Country country) {
                          setState(() {
                            nationalityPereController.text = country.name;
                          });
                        })
                  },
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'La nationalité obligatoire';
                    }
                    return null;
                  },
                  controller: nationalityPereController,
                  obscure: false,
                  keyboardType: TextInputType.name,
                  onChanged: (value) {},
                  hintText: 'Nationalité',
                ),
                _fieldGap,
                TextFieldWidget(
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Profession obligatoire';
                    }
                    return null;
                  },
                  controller: professionController,
                  obscure: false,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  onChanged: (value) {},
                  hintText: 'Profession',
                ),
                _fieldGap,
                TextFieldWidget(
                  controller: posteController,
                  obscure: false,
                  keyboardType: TextInputType.name,
                  onChanged: (value) {},
                  hintText: 'Poste occupé',
                ),
                _fieldGap,
                _buildDipDw(),
                _fieldGap,
                TextFieldWidget(
                  controller: personToContactController,
                  obscure: false,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {},
                  hintText: 'Numéro de la personne à contacter',
                ),
                _fieldGap,
                _dateField(
                  controller: dateAdhesionController,
                  hint: "Date d'adhésion (jj-mm-aaaa)",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Selectionnez une date';
                    }
                    return null;
                  },
                  onPicked: (pickedDate) {
                    setState(() {
                      dateAdhesionController.text =
                          DateFormat('dd-MM-yyyy').format(pickedDate);
                      dateAdhesion =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                    });
                  },
                ),
              ],
            ),
          ),
        ),

        //----  STEP 4 -------//
        FormStep(
          title: "Pièce d'identité",
          content: Form(
            key: formKey[3],
            child: PhotoStepContent(
              buttonLabel: "Photographier la pièce d'identité",
              onPick: () => pickImageIdentityFromCamera(),
              preview: imageFileIdentity != null
                  ? Image.file(imageFileIdentity!, fit: BoxFit.cover)
                  : null,
            ),
          ),
        ),

        //----  STEP 5 -------//
        FormStep(
          title: "Photo de l'adhérent",
          content: Form(
            key: formKey[4],
            child: PhotoStepContent(
              buttonLabel: 'Photographier la personne',
              onPick: () => pickImageProfileFromCamera(),
              preview: imageFileProfile != null
                  ? Image.file(imageFileProfile!, fit: BoxFit.cover)
                  : null,
            ),
          ),
        ),
      ];

  Widget _buildTypePieceDw() {
    return Obx(() => AppDropdown<TypePiece>(
          items: dropdownController.typeList.toList(),
          value: dropdownController.selectedTypeRegister.value,
          hint: 'Type de pièce',
          labelOf: (v) => v.name ?? '',
          loading: dropdownController.referenceLoading.value,
          onRetry: () => dropdownController.loadReferenceData(force: true),
          onChanged: dropdownController.onSelectType,
        ));
  }

  Widget _buildSexDw() {
    return Obx(() => AppDropdown<String>(
          items: dropdownController.sexList.map((e) => e.toString()).toList(),
          value: dropdownController.selectedSexRegister.value,
          hint: 'Sexe',
          labelOf: (v) => v,
          loading: dropdownController.referenceLoading.value,
          onRetry: () => dropdownController.loadReferenceData(force: true),
          onChanged: dropdownController.onSelectSex,
        ));
  }

  Widget _buildDipDw() {
    return Obx(() => AppDropdown<Diplome>(
          items: dropdownController.diplomeList.toList(),
          value: dropdownController.selectedDiplomeRegister.value,
          hint: 'Diplôme',
          labelOf: (v) => v.degreeTitle ?? '',
          loading: dropdownController.referenceLoading.value,
          onRetry: () => dropdownController.loadReferenceData(force: true),
          onChanged: dropdownController.onSelectDipolem,
        ));
  }
}
