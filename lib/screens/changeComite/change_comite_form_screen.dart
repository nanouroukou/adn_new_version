import 'dart:io';

import 'package:cherifla/controller/dropdown_controller.dart';
import 'package:cherifla/models/adherent_creation.dart';
import 'package:cherifla/models/adherent_model.dart';
import 'package:cherifla/models/comity_model.dart';
import 'package:cherifla/models/dipole.dart';
import 'package:cherifla/models/federation_model.dart';
import 'package:cherifla/models/piece_model.dart';
import 'package:cherifla/models/section_model.dart';
import 'package:cherifla/models/sub_section_model.dart';
import 'package:cherifla/services/api/api.services.dart';
import 'package:cherifla/services/authentification/auth.service.dart';
import 'package:cherifla/utils/alert/alert.util.dart';
import 'package:cherifla/utils/color/color.dart';
import 'package:cherifla/utils/format/date.dart';
import 'package:cherifla/utils/format/textFormater.dart';
import 'package:cherifla/utils/loading/loading_utils.dart';
import 'package:cherifla/utils/log/logger.dart';

import 'package:cherifla/widgets/appbar/app_bar.dart';
import 'package:cherifla/widgets/textField/country_sellect.dart';
import 'package:cherifla/widgets/textField/numberPhone.dart';
import 'package:cherifla/widgets/textField/textFieldWidget.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../utils/mediaQuery/size.dart';
import '../../widgets/background/background.dart';
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
  final GlobalKey<FormState> _formkey = GlobalKey();
  final TextEditingController passwordController = TextEditingController();
  final _scrollController = ScrollController();
  var _showLoading = false;
  File? imageFileProfile;
  File? imageFileIdentity;

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
      _scrollController.jumpTo(0);
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
      _scrollController.jumpTo(0);
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
      phone: dropdownController.phoneNumberController.value.text,
      dateNaissance: formatter.format(
          parseFrDate(dropdownController.dateNaissanceController.value.text)),
      adhesionDate:
          formatter.format(parseFrDate(dateAdhesionController.value.text)),
      prenomPere: dropdownController.prenomPereController.value.text,
      prenomMere: dropdownController.prenomMereController.value.text,
      nomMere: dropdownController.nomMereController.value.text,
      sexe: dropdownController.selectedSex.value,
      nationality: dropdownController.nationalityController.value.text,
      placeOfBirthday: dropdownController.prenomMereController.value.text,
      profession: dropdownController.professionController.value.text,
      position: dropdownController.posteController.value.text,
      personToContact: dropdownController.personToContactController.text,
      identityType: dropdownController.selectedType.value,
      degree: dropdownController.selectedDiplome.value,
      identityCardNumber:
          dropdownController.identityCardNumberController.value.text,
    );

    if (imageFileProfile == null && imageFileIdentity == null) {
      apiServices.updateAdherentWithoutImage(adh).then(
        (value) {
          setState(() {
            _showLoading == false;
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
            _showLoading == false;
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
            _showLoading == false;
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
            _showLoading == false;
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
        builder: (_) => AlertDialog(
              backgroundColor: loginBorderColor,
              iconColor: Colors.white,
              title: const Text(
                "Veuillez saisir votre mot de passe ou continuer avec l'empreinte digitale",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
              icon: Icon(Icons.lock_rounded,
                  color: Colors.white, size: Get.height * 0.08),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: Get.width * 0.4,
                  height: Get.height * 0.4,
                  child: Column(
                    children: [
                      SizedBox(
                        width: Get.width * 0.5,
                        child: TextFieldWidget(
                          validator: (value) {
                            if (value == null || value == '') {
                              return "Saissisez votre mot de passe";
                            }
                            return null;
                          },
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
                          fillColor: Colors.white,
                          hintColor: Colors.black,
                          textColor: Colors.black,
                          controller: passwordController,
                        ),
                      ),
                      Gap(Get.height * 0.03),
                      InkWell(
                        onTap: () async {
                          update();
                        },
                        child: Icon(Icons.fingerprint,
                            color: Colors.white, size: Get.height * 0.1),
                      ),
                      Gap(displayHeight(context) * 0.01),
                      ButtonWidget(
                        colour: Colors.white,
                        title: 'Continuer',
                        textColor: Colors.black,
                        onPressed: () {
                          // logger().d(dropdownController.selectedFederation.toJson());
                          if (passwordFieldValue != truePassword) {
                            Alert.showErrorDialog('Mot passe incorrecte');
                          } else {
                            Navigator.of(context).pop();
                            setState(() {
                              showLoading = true;
                            });
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
                            );
                          }
                        },
                        width: Get.width,
                        size: Get.width * 0.045,
                      )
                    ],
                  ),
                ),
              ),
            ));
  }

  @override
  void initState() {
    super.initState();
    apiServices.getSex();
    apiServices.getIdentityType();
    apiServices.getSex();
    apiServices.getDiplome();
    dropdownController.setInitialData(widget.adherent);
    dropdownController.init();
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
    return Theme(
      data: ThemeData(
        canvasColor: redColor,
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: primaryColor,
            ),
      ),
      child: Scaffold(
          appBar: buildAppBar(title: 'Modification des informations'),
          body: Stack(
            alignment: Alignment.topCenter,
            children: [
              const Background(),
              getBody(),
              if (_showLoading) getLoader()
            ],
          )),
    );
  }

  Widget buildHeader() {
    double titleSizeCoef = Get.width * 0.06;
    //const double iconTitleSizeCoef = 0.06;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Get.width * 0.06),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Modification",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontFamily: 'Avenir Next LTPro',
                    fontSize: Get.width * titleSizeCoef,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                    color: const Color(0xfff707070)),
              ),
            ],
          ),
          SizedBox(height: Get.height * 0.02),
        ],
      ),
    );
  }

  Widget getBody() {
    return Container(
        padding: EdgeInsets.symmetric(
            horizontal: Get.width * 0.01, vertical: Get.width * 0.01),
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              Gap(displayHeight(context) * 0.01),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: Get.height * 0.9,
                          width: Get.width * 06,
                          child: Stepper(
                            physics: const BouncingScrollPhysics(),
                            steps: getSteps(),
                            onStepContinue: () => _onContinue(),
                            onStepCancel: () => _onCancel(),
                            controlsBuilder: (BuildContext context,
                                ControlsDetails details) {
                              return Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                        ),
                                        onPressed: details.onStepCancel,
                                        child: Text(
                                          'Precedent',
                                          style: TextStyle(
                                              fontSize: Get.height * 0.020),
                                        )),
                                  ),
                                  Gap(displayWidth(context) * 0.1),
                                  Expanded(
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                        ),
                                        onPressed: details.onStepContinue,
                                        child:
                                            currentStep == getSteps().length - 1
                                                ? Text('Mettre à jour',
                                                    style: TextStyle(
                                                        fontSize:
                                                            Get.height * 0.020))
                                                : Text(
                                                    'Suivant',
                                                    style: TextStyle(
                                                        fontSize:
                                                            Get.height * 0.020),
                                                  )),
                                  ),
                                ],
                              );
                            },
                            type: StepperType.horizontal,
                            currentStep: currentStep,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  List<Step> getSteps() => [
        //----  STEP 1 -------//
        Step(
            title: const Text(''),
            state: currentStep > 0 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 0,
            content: Form(
              key: formKey[0],
              child: Column(
                children: [
                  TextFieldWidget(
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Nom obligatoire';
                      } else {
                        return null;
                      }
                    },
                    controller: dropdownController.nomController,
                    obscure: false,
                    keyboardType: TextInputType.name,
                    onChanged: (value) {},
                    hintText: 'Nom',
                  ),
                  Gap(Get.height * 0.03),
                  TextFieldWidget(
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Prénom obligatoire';
                      } else {
                        return null;
                      }
                    },
                    controller: dropdownController.prenomController,
                    obscure: false,
                    keyboardType: TextInputType.name,
                    onChanged: (value) {},
                    hintText: 'Prénom(s)',
                  ),
                  _buildSexDw(),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value == '') {
                        return 'Selectionnez la date de naissance';
                      } else if (value.length < 10) {
                        return 'Format invalide';
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.datetime,
                    inputFormatters: [
                      TestMaskFormatter(mask: 'xx-xx-xxxx', separator: '-')
                    ],
                    style: TextStyle(
                        color: Colors.white, fontSize: Get.width * 0.04),
                    controller: dropdownController.dateNaissanceController,
                    decoration: InputDecoration(
                        prefixIcon: InkWell(
                          onTap: () async {
                            var pickedDate = await showDatePicker(
                                context: context,
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now());
                            if (pickedDate != null) {
                              dropdownController.dateNaissanceController.text =
                                  DateFormat('dd-MM-yyyy').format(pickedDate);

                              setState(() {
                                dateNaissanceValue =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                              });
                            } else {
                              dropdownController.dateNaissanceController.text =
                                  dropdownController
                                      .dateNaissanceController.text;
                            }
                          },
                          child: const Icon(
                            Icons.calendar_month,
                            color: Colors.white,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 10),
                        hintText: "Date de naissance ",
                        focusedBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: primaryColor)),
                        errorStyle: const TextStyle(color: redColor),
                        hintStyle: TextStyle(
                          fontSize: Get.width * 0.04,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                        filled: true,
                        fillColor: primaryColorLight,
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 2, color: primaryColor),
                            borderRadius: BorderRadius.circular(5)),
                        border: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 0, color: primaryColor),
                            borderRadius: BorderRadius.circular(15))),
                    onFieldSubmitted: (newValue) async {
                      setState(() {
                        dateNaissanceValue = DateFormat('yyyy-mm-dd')
                            .format(parseFrDate(newValue));
                      });
                    },
                    onTap: () {
                      dropdownController.dateNaissanceController.clear();
                    },
                  ),
                  Gap(Get.height * 0.03),
                  TextFieldWidget(
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Lieu de Naissance obligatoire';
                      } else {
                        return null;
                      }
                    },
                    controller: dropdownController.placeOfBirthdayController,
                    obscure: false,
                    keyboardType: TextInputType.name,
                    onChanged: (value) {},
                    hintText: 'Lieu de Naissance',
                  ),
                  Gap(Get.height * 0.03),
                ],
              ),
            )),

        //----  STEP 2 -------//
        Step(
            title: const Text(''),
            state: currentStep > 1 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 1,
            content: Form(
              key: formKey[1],
              child: Column(
                children: [
                  NumberTextFieldWidget(
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Numero de telephone obligatoire';
                      } else {
                        return null;
                      }
                    },
                    controller: dropdownController.phoneNumberController,
                    obscure: false,
                    keyboardType: TextInputType.phone,
                    onChanged: (value) {},
                    hintText: 'Numéro de telephone',
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      TestMaskFormatter(
                        mask: 'xx xx xx xx',
                        separator: ' ',
                      ),
                    ],
                  ),
                  TextFieldWidget(
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return '';
                      } else {
                        return null;
                      }
                    },
                    controller: dropdownController.prenomPereController,
                    obscure: false,
                    keyboardType: TextInputType.name,
                    onChanged: (value) {},
                    hintText: 'Prénom(s) du père',
                  ),
                  Gap(Get.height * 0.03),
                  TextFieldWidget(
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return '';
                      } else {
                        return null;
                      }
                    },
                    controller: dropdownController.prenomMereController,
                    obscure: false,
                    keyboardType: TextInputType.name,
                    onChanged: (value) {},
                    hintText: 'Prénom(s) de la mère',
                  ),
                  Gap(Get.height * 0.03),
                  TextFieldWidget(
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return '';
                      } else {
                        return null;
                      }
                    },
                    controller: dropdownController.nomMereController,
                    obscure: false,
                    keyboardType: TextInputType.name,
                    onChanged: (value) {},
                    hintText: 'Nom de la mère',
                  ),
                  _buildTypePieceDw(),
                  TextFieldWidget(
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return '';
                      } else {
                        return null;
                      }
                    },
                    controller: dropdownController.identityCardNumberController,
                    obscure: false,
                    keyboardType: TextInputType.name,
                    onChanged: (value) {},
                    hintText: 'numero de la piece d\'identite',
                  ),
                  SizedBox(
                    height: Get.height * 0.04,
                  ),
                ],
              ),
            )),

        //----  STEP 3 -------//
        Step(
            title: const Text(''),
            state: currentStep > 2 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 2,
            content: Form(
              key: formKey[2],
              child: Column(
                children: [
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
                      } else {
                        return null;
                      }
                    },
                    controller: dropdownController.nationalityController,
                    obscure: false,
                    keyboardType: TextInputType.name,
                    onChanged: (value) {},
                    hintText: 'Nationalité',
                  ),
                  Gap(Get.height * 0.03),
                  TextFieldWidget(
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Profession obligatoire';
                      } else {
                        return null;
                      }
                    },
                    controller: dropdownController.professionController,
                    obscure: false,
                    keyboardType: TextInputType.name,
                    onChanged: (value) {},
                    hintText: 'Profession',
                  ),
                  Gap(Get.height * 0.03),
                  TextFieldWidget(
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Poste obligatoire';
                      } else {
                        return null;
                      }
                    },
                    controller: dropdownController.posteController,
                    obscure: false,
                    keyboardType: TextInputType.name,
                    onChanged: (value) {},
                    hintText: 'Poste Occupé',
                  ),
                  _buildDipDw(),
                  TextFieldWidget(
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Numero de la personne à contacter obligatoire';
                      } else {
                        return null;
                      }
                    },
                    controller: dropdownController.personToContactController,
                    obscure: false,
                    keyboardType: TextInputType.name,
                    onChanged: (value) {},
                    hintText: 'Numero de la personne à contacter',
                  ),
                  Gap(Get.height * 0.03),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Selectionnez une date';
                      }
                      return null;
                    },
                    controller: dateAdhesionController,
                    keyboardType: TextInputType.datetime,
                    inputFormatters: [
                      TestMaskFormatter(mask: 'xx-xx-xxxx', separator: '-')
                    ],
                    onTap: () {
                      dateAdhesionController.clear();
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        prefixIconColor: Colors.white,
                        prefixIcon: InkWell(
                            onTap: () async {
                              var pickedDate = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now());
                              if (pickedDate != null) {
                                setState(() {
                                  dateAdhesionController.text =
                                      DateFormat('dd-MM-yyyy')
                                          .format(pickedDate);
                                  dateAdhesion = DateFormat('yyyy-MM-dd')
                                      .format(pickedDate);
                                });

                                // print('date adhesion $dateAdhesion');
                              }
                            },
                            child: const Icon(Icons.calendar_month)),
                        hintText: "Date d'adhésion (dd-mm-yyyy) ",
                        focusedBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: primaryColor)),
                        errorStyle: const TextStyle(color: textColor),
                        hintStyle: TextStyle(
                          fontSize: Get.width * 0.04,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                        filled: true,
                        fillColor: primaryColorLight,
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 2, color: primaryColor),
                            borderRadius: BorderRadius.circular(5)),
                        border: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 0, color: primaryColor),
                            borderRadius: BorderRadius.circular(15))),
                  ),
                  Gap(Get.height * 0.03),
                ],
              ),
            )),

        //----  STEP 4 -------//
        Step(
          state: currentStep > 3 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 3,
          title: const Text(''),
          content: Form(
            key: formKey[3],
            child: Column(
              children: [
                SizedBox(
                    height: Get.height * 0.06,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.camera_alt),
                      onPressed: () {
                        pickImageIdentityFromCamera();
                      },
                      label: const Text(
                          "Prendre une photo de la piece à d'identite"),
                    )),
                Gap(displayHeight(context) * 0.04),
                Container(
                    height: Get.height * 0.3,
                    width: Get.width * 0.5,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2),
                        borderRadius: BorderRadius.circular(18),
                        color: Colors.white),
                    child: imageFileIdentity != null
                        ? Image.file(imageFileIdentity!)
                        : Image.network(
                            '${ApiServices.BASE_URL}/api/adherent/doc-image/${dropdownController.identityDocImage.value}')
                    //     const Icon(
                    //   color: Colors.grey,
                    //   Icons.person,
                    //   size: 200,
                    // ),
                    ),
                Gap(displayHeight(context) * 0.04),
              ],
            ),
          ),
        ),

        //----  STEP 5 -------//
        Step(
          state: currentStep > 4 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 4,
          title: const Text(''),
          content: Form(
            key: formKey[4],
            child: Column(
              children: [
                SizedBox(
                    height: Get.height * 0.06,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.camera_alt),
                      onPressed: () {
                        pickImageProfileFromCamera();
                      },
                      label: const Text(
                          "Prendre une photo de la personne à inscrire"),
                    )),
                Gap(displayHeight(context) * 0.04),
                Container(
                    height: Get.height * 0.3,
                    width: Get.width * 0.5,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2),
                        borderRadius: BorderRadius.circular(18),
                        color: Colors.white),
                    child: imageFileProfile != null
                        ? Image.file(imageFileProfile!)
                        : Image.network(
                            '${ApiServices.BASE_URL}/api/adherent/photo/${dropdownController.picture.value}')

                    // const Icon(
                    //   color: Colors.grey,
                    //   Icons.person,
                    //   size: 200,
                    // ),
                    ),
                Gap(displayHeight(context) * 0.04),
              ],
            ),
          ),
        )
      ];

  InputDecoration dropdownDecoration() {
    return InputDecoration(
        focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(color: primaryColor)),
        errorStyle: const TextStyle(color: textColor),
        hintStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.normal,
          color: Colors.white,
        ),
        filled: true,
        fillColor: primaryColorLight,
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 2, color: primaryColor),
            borderRadius: BorderRadius.circular(5)),
        border: OutlineInputBorder(
            borderSide: const BorderSide(width: 0, color: primaryColor),
            borderRadius: BorderRadius.circular(15)));
  }

  _buildDipDw() {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: Get.height * 0.02),
        child: GetBuilder<DropdownController>(
          builder: (dropdownController) => DropdownButtonFormField<Diplome>(
              value: dropdownController.selectedDiplome.value,
              disabledHint: const Text(
                'Dipome non disponible',
                style: TextStyle(color: Colors.white),
              ),
              hint: const Text('Selectionnez le dipome',
                  style: TextStyle(color: Colors.white)),
              decoration: dropdownDecoration(),
              dropdownColor: primaryColor,
              items: dropdownController.diplomeList.isEmpty
                  ? []
                  : dropdownController.diplomeList.map((v) {
                      return DropdownMenuItem<Diplome>(
                          value: v,
                          key: UniqueKey(),
                          child: Text(
                            v.degreeTitle ?? '',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: Get.height * 0.019),
                          ));
                    }).toList(),
              onChanged: (value) {
                dropdownController.onSelectDipolem(value!);
              }),
        ));
  }

  _buildTypePieceDw() {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: Get.height * 0.03),
        child: GetBuilder<DropdownController>(
          builder: (dropdownController) => DropdownButtonFormField<TypePiece>(
              value: dropdownController.selectedType.value,
              disabledHint: const Text(
                'Type de piece non disponible',
                style: TextStyle(color: Colors.white),
              ),
              hint: const Text('Selectionnez le type de piece',
                  style: TextStyle(color: Colors.white)),
              decoration: dropdownDecoration(),
              dropdownColor: primaryColor,
              items: dropdownController.typeList.isEmpty
                  ? []
                  : dropdownController.typeList.map((v) {
                      return DropdownMenuItem<TypePiece>(
                          value: v,
                          key: UniqueKey(),
                          child: Text(
                            v.name ?? '',
                            style: const TextStyle(color: Colors.white),
                          ));
                    }).toList(),
              onChanged: (value) {
                dropdownController.onSelectType(value!);
              }),
        ));
  }

  _buildSexDw() {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: Get.height * 0.03),
        child: GetBuilder<DropdownController>(
          builder: (dropdownController) => DropdownButtonFormField<String>(
              value: dropdownController.selectedSex.value,
              disabledHint: const Text(
                'Sexe non disponible',
                style: TextStyle(color: Colors.white),
              ),
              hint: const Text('Selectionnez le sexe',
                  style: TextStyle(color: Colors.white)),
              decoration: dropdownDecoration(),
              dropdownColor: primaryColor,
              items: dropdownController.sexList.isEmpty
                  ? []
                  : dropdownController.sexList.map((v) {
                      return DropdownMenuItem<String>(
                          value: v,
                          key: UniqueKey(),
                          child: Text(
                            v ?? '',
                            style: const TextStyle(color: Colors.white),
                          ));
                    }).toList(),
              onChanged: (value) {
                dropdownController.onSelectSex(value!);
              }),
        ));
  }
}
