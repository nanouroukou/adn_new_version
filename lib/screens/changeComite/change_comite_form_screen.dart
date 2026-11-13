import 'dart:io';

import 'package:cherifla/controller/dropdown_controller.dart';
import 'package:cherifla/models/adherent_creation.dart';
import 'package:cherifla/models/adherent_model.dart';
import 'package:cherifla/models/dipole.dart';

import 'package:cherifla/models/piece_model.dart';

import 'package:cherifla/services/api/api.services.dart';
import 'package:cherifla/services/authentification/auth.service.dart';
import 'package:cherifla/utils/alert/alert.util.dart';
import 'package:cherifla/utils/color/color.dart';
import 'package:cherifla/utils/format/date.dart';
import 'package:cherifla/utils/format/textFormater.dart';
import 'package:cherifla/utils/format/phone_format.dart';
import 'package:cherifla/utils/loading/loading_utils.dart';
import 'package:cherifla/utils/log/logger.dart';

import 'package:cherifla/widgets/appbar/app_bar.dart';
import 'package:cherifla/widgets/textField/country_sellect.dart';
import 'package:cherifla/widgets/textField/app_dropdown.dart';
import 'package:cherifla/widgets/textField/numberPhone.dart';
import 'package:cherifla/widgets/textField/textFieldWidget.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../widgets/common/responsive_stepper.dart';
import '../../widgets/button/buttonWidget.dart';

class ChangeComiteFormScreen extends StatefulWidget {
  const ChangeComiteFormScreen({super.key, required this.adherent});
  final Adherent adherent;

  @override
  State<ChangeComiteFormScreen> createState() => _ChangeComiteFormScreenState();
}

class _ChangeComiteFormScreenState extends State<ChangeComiteFormScreen> {
  final dropdownController = Get.put(DropdownController());
  final apiServices = ApiServices();
  final authService = AuthService();
  final _secureStorage = const FlutterSecureStorage();
  var passwordFieldValue = '';
  var showLoading = false;
  // final GlobalKey<FormState> _formkey = GlobalKey();
  final TextEditingController passwordController = TextEditingController();
  final _scrollController = ScrollController();
  var _showLoading = false;
  File? imageFileProfile;
  File? imageFileIdentity;

  bool isCompleted = false;

  final List<GlobalKey<FormState>> formKey = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  int currentStep = 0;

  var dateAdhesion = '';
  // var dateNaissanceValue = '';

  _onContinue() {
    if (formKey[currentStep].currentState!.validate() &&
        currentStep < (getSteps().length - 1)) {
      setState(() {
        currentStep += 1;
      });
      if (_scrollController.hasClients) _scrollController.jumpTo(0);
    } else if (formKey[currentStep].currentState!.validate() &&
        currentStep == (getSteps().length - 1)) {
      onValider();
    } else {}
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
      if (image == null) return;
      setState(() {
        imageFileIdentity = File(image.path);
      });
    } on PlatformException catch (e) {
      logger().e('Erreur survenu $e');
    } on Exception catch (e) {
      logger().e(e);
    }
  }

  update() async {
    setState(() {
      _showLoading = true;
    });

    final adh = AdherentCreation(
      codeAdherent: dropdownController.codeAdherent.value,
      nom: dropdownController.nomController.value.text,
      prenom: dropdownController.prenomController.value.text,
      nomPere: dropdownController.nomPereController.value.text,
      phone: PhoneFormat.digits(dropdownController.phoneNumberController.text),
      dateNaissance: dropdownController.dateNaissanceController.value.text,
      adhesionDate: dropdownController.dateAdhesionController.value.text,
      prenomPere: dropdownController.prenomPereController.value.text,
      prenomMere: dropdownController.prenomMereController.value.text,
      nomMere: dropdownController.nomMereController.value.text,
      sexe: dropdownController.selectedSexUpdate.value,
      indicePays: dropdownController.indicePaysController.value.text,
      nationality: dropdownController.nationalityController.value.text,
      placeOfBirthday: dropdownController.placeOfBirthdayController.value.text,
      profession: dropdownController.professionController.value.text,
      position: dropdownController.posteController.value.text,
      personToContact: PhoneFormat.e164(dropdownController.contactDialCode,
          dropdownController.personToContactController.text),
      identityType: dropdownController.selectedTypeUpdate.value,
      degree: dropdownController.selectedDiplomeUpdate.value,
      identityCardNumber:
          dropdownController.identityCardNumberController.value.text,
    );

    if (imageFileProfile == null && imageFileIdentity == null) {
      apiServices.updateAdherentWithoutImage(adh).then(
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
    } else if (imageFileProfile == null && imageFileIdentity != null) {
      apiServices.updateAdherentWithOutDocImage(imageFileIdentity!, adh).then(
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
    } else if (imageFileProfile != null && imageFileIdentity == null) {
      apiServices
          .updateAdherentWithOutProfileImage(imageFileProfile!, adh)
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
    } else {
      apiServices
          .updateAdherentWithImage(imageFileProfile!, imageFileIdentity!, adh)
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
  }

  onValider() async {
    var truePassword = await _secureStorage.read(key: 'userPassword');

    showDialog(
        context: Get.context!,
        builder: (dialogContext) => AlertDialog(
              title: const Text(
                "Confirmez avec votre mot de passe",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              content: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 360),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFieldWidget(
                        validator: (value) {
                          if (value == null || value == '') {
                            return "Saissisez votre mot de passe";
                          }
                          return null;
                        },
                        prefix: const Icon(Icons.lock_outline),
                        obscure: true,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.go,
                        onFieldSubmitted: (value) {},
                        onChanged: (value) {
                          setState(() {
                            passwordFieldValue = value;
                          });
                        },
                        hintText: "Mot de passe",
                        controller: passwordController,
                      ),
                      const SizedBox(height: 24),
                      ButtonWidget(
                        title: 'Continuer',
                        onPressed: () => showLoading
                            ? null
                            : {
                                if (passwordFieldValue != truePassword)
                                  {
                                    Alert.showErrorDialog(
                                        'Mot passe incorrecte'),
                                  }
                                else
                                  {
                                    Navigator.of(dialogContext).pop(),
                                    setState(() {
                                      showLoading = true;
                                    }),
                                    update().then(
                                      (value) {
                                        setState(() {
                                          showLoading = false;
                                        });
                                      },
                                    ).whenComplete(
                                      () => setState(() {
                                        showLoading = false;
                                      }),
                                    ),
                                  }
                              },
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }

  @override
  void initState() {
    super.initState();
    dropdownController.setInitialData(widget.adherent);
    dropdownController.loadReferenceData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => dropdownController.reset());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: surfaceColor,
      appBar: buildAppBar(title: 'Modification des informations'),
      body: Stack(
        children: [
          ResponsiveStepper(
            steps: getSteps(),
            currentStep: currentStep,
            scrollController: _scrollController,
            loading: _showLoading || showLoading,
            lastStepLabel: 'Modifier',
            onContinue: () => _onContinue(),
            onCancel: () => _onCancel(),
          ),
          if (_showLoading || showLoading) getLoader()
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

  Widget _networkPreview(String url) => Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Center(
          child: Icon(Icons.broken_image_outlined,
              size: 64, color: mutedTextColor),
        ),
      );

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
                  controller: dropdownController.nomController,
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
                  controller: dropdownController.prenomController,
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
                  controller: dropdownController.dateNaissanceController,
                  hint: 'Date de naissance',
                  validator: (value) {
                    if (value == null || value == '') {
                      return 'Selectionnez la date de naissance';
                    } else if (value.length < 10) {
                      return 'Format invalide';
                    }
                    return null;
                  },
                  onPicked: (pickedDate) {
                    setState(() {
                      dropdownController.dateNaissanceController.text =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                    });
                  },
                  onFieldSubmitted: (newValue) async {
                    setState(() {
                      dropdownController.dateNaissanceController.text =
                          DateFormat('yyyy-mm-dd')
                              .format(parseFrDate(newValue));
                    });
                  },
                ),
                _fieldGap,
                TextFieldWidget(
                  controller: dropdownController.placeOfBirthdayController,
                  obscure: false,
                  keyboardType: TextInputType.name,
                  onChanged: (value) {},
                  hintText: 'Lieu de naissance',
                ),
                _fieldGap,
                CountryTextFieldWidget(
                  ontap: () => {
                    showCountryPicker(
                        context: context,
                        onSelect: (Country country) {
                          setState(() {
                            dropdownController.nationalityController.text =
                                country.name;
                          });
                        })
                  },
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'La nationalité obligatoire';
                    }
                    return null;
                  },
                  controller: dropdownController.nationalityController,
                  obscure: false,
                  keyboardType: TextInputType.name,
                  onChanged: (value) {},
                  hintText: 'Nationalité',
                ),
              ],
            ),
          ),
        ),

        //----  STEP 2 -------//
        FormStep(
          title: 'Filiation',
          content: Form(
            key: formKey[1],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFieldWidget(
                  controller: dropdownController.prenomPereController,
                  obscure: false,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  onChanged: (value) {},
                  hintText: 'Prénom(s) du père',
                ),
                _fieldGap,
                TextFieldWidget(
                  controller: dropdownController.nomPereController,
                  obscure: false,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  onChanged: (value) {},
                  hintText: 'Nom du père',
                ),
                _fieldGap,
                TextFieldWidget(
                  controller: dropdownController.prenomMereController,
                  obscure: false,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  onChanged: (value) {},
                  hintText: 'Prénom(s) de la mère',
                ),
                _fieldGap,
                TextFieldWidget(
                  controller: dropdownController.nomMereController,
                  obscure: false,
                  keyboardType: TextInputType.name,
                  onChanged: (value) {},
                  hintText: 'Nom de la mère',
                ),
              ],
            ),
          ),
        ),

        //----  STEP 3 -------//
        FormStep(
          title: 'Coordonnées',
          content: Form(
            key: formKey[2],
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
                  controller: dropdownController.phoneNumberController,
                  obscure: false,
                  countryCode: dropdownController.codeCountry.value,
                  keyboardType: TextInputType.phone,
                  hintText: 'Numéro de téléphone',
                  onChanged: (String value) {},
                  onChangeCountry: (value) {
                    dropdownController.indicePaysController.text = value;
                    dropdownController.codeCountry.value = value;
                  },
                ),
                _fieldGap,
                NumberTextFieldWidget(
                  controller: dropdownController.personToContactController,
                  obscure: false,
                  countryCode: dropdownController.contactDialCode,
                  keyboardType: TextInputType.phone,
                  onChanged: (value) {},
                  onChangeCountry: (value) {
                    dropdownController.contactDialCode = value;
                  },
                  hintText: 'Numéro de la personne à contacter',
                ),
              ],
            ),
          ),
        ),

        //----  STEP 4 -------//
        FormStep(
          title: 'Profession et adhésion',
          content: Form(
            key: formKey[3],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFieldWidget(
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Profession obligatoire';
                    }
                    return null;
                  },
                  controller: dropdownController.professionController,
                  obscure: false,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  onChanged: (value) {},
                  hintText: 'Profession',
                ),
                _fieldGap,
                TextFieldWidget(
                  controller: dropdownController.posteController,
                  obscure: false,
                  keyboardType: TextInputType.name,
                  onChanged: (value) {},
                  hintText: 'Poste occupé',
                ),
                _fieldGap,
                _buildDipDw(),
                _fieldGap,
                _dateField(
                  controller: dropdownController.dateAdhesionController,
                  hint: "Date d'adhésion",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Selectionnez une date';
                    }
                    return null;
                  },
                  onPicked: (pickedDate) {
                    setState(() {
                      dropdownController.dateAdhesionController.text =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                    });
                  },
                ),
              ],
            ),
          ),
        ),

        //----  STEP 5 -------//
        FormStep(
          title: "Pièce d'identité",
          content: Form(
            key: formKey[4],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTypePieceDw(),
                _fieldGap,
                TextFieldWidget(
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Numéro de la pièce obligatoire';
                    }
                    return null;
                  },
                  controller: dropdownController.identityCardNumberController,
                  obscure: false,
                  keyboardType: TextInputType.name,
                  onChanged: (value) {},
                  hintText: 'Numéro de la pièce d\'identité',
                ),
                _fieldGap,
                PhotoStepContent(
                  buttonLabel: "Photographier la pièce d'identité",
                  onPick: () => pickImageIdentityFromCamera(),
                  preview: imageFileIdentity == null
                      ? _networkPreview(
                          '${ApiServices.BASE_URL}/api/adherent/doc-image/${dropdownController.identityDocImage.value}')
                      : Image.file(imageFileIdentity!, fit: BoxFit.cover),
                ),
              ],
            ),
          ),
        ),

        //----  STEP 6 -------//
        FormStep(
          title: "Photo de l'adhérent",
          content: Form(
            key: formKey[5],
            child: PhotoStepContent(
              buttonLabel: 'Photographier la personne',
              onPick: () => pickImageProfileFromCamera(),
              preview: imageFileProfile == null
                  ? _networkPreview(
                      '${ApiServices.BASE_URL}/api/adherent/photo/${dropdownController.picture.value}')
                  : Image.file(imageFileProfile!, fit: BoxFit.cover),
            ),
          ),
        ),
      ];

  Widget _buildTypePieceDw() {
    return Obx(() => AppDropdown<TypePiece>(
          items: dropdownController.typeList.toList(),
          value: dropdownController.selectedTypeUpdate.value,
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
          value: dropdownController.selectedSexUpdate.value,
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
          value: dropdownController.selectedDiplomeUpdate.value,
          hint: 'Diplôme',
          labelOf: (v) => v.degreeTitle ?? '',
          loading: dropdownController.referenceLoading.value,
          onRetry: () => dropdownController.loadReferenceData(force: true),
          onChanged: dropdownController.onSelectDipolem,
        ));
  }
}
