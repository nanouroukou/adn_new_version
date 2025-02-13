import 'dart:io';
import 'dart:math';

import 'package:cherifla/controller/dropdown_controller.dart';
import 'package:cherifla/controller/user.controller.dart';
import 'package:cherifla/models/adherent_creation.dart';
import 'package:cherifla/models/adherent_model.dart';
import 'package:cherifla/models/comity_model.dart';
import 'package:cherifla/models/dipole.dart';
import 'package:cherifla/models/federation_model.dart';
import 'package:cherifla/models/piece_model.dart';
import 'package:cherifla/models/section_model.dart';
import 'package:cherifla/models/sub_section_model.dart';
import 'package:cherifla/services/api/api.services.dart';
import 'package:cherifla/utils/color/color.dart';
import 'package:cherifla/utils/format/date.dart';

import 'package:cherifla/utils/format/textFormater.dart';
import 'package:cherifla/utils/loading/loading_utils.dart';
import 'package:cherifla/utils/mediaQuery/size.dart';
import 'package:cherifla/widgets/background/background.dart';
import 'package:cherifla/widgets/textField/country_sellect.dart';
import 'package:cherifla/widgets/textField/numberPhone.dart';
import 'package:cherifla/widgets/textField/textFieldWidget.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

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

  File? imageFileProfile;
  File? imageFileIdentity;
  final double imageHeight = Get.height * 2.30;
  final double imageWidth = Get.height * 2.10;
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
        currentStep == (getSteps().length - 1) &&
        imageFileProfile != null) {
      //ENVOI DU FORMULAIRE
      logger().i('last step valid');
      _onSave();
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
      _scrollController.jumpTo(0);
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
      sexe: dropdownController.selectedSex.value,
      nationality: nationalityPereController.value.text,
      placeOfBirthday: prenomMereController.value.text,
      profession: nomMereController.value.text,
      position: posteController.value.text,
      personToContact: personToContactController.text,
      identityType: {'id': dropdownController.selectedType.value?.id},
      degree: {'id': dropdownController.selectedDiplome.value?.id},
      identityCardNumber: identityCardNumberController.value.text,
    );

    apiServices
        .inscrireAdherentWithImage(imageFileProfile!, imageFileIdentity!, adh)
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

  @override
  void initState() {
    api.getSex();
    api.getIdentityType();
    api.getDiplome();
    // TODO: implement initState
    super.initState();
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
    return Theme(
      data: ThemeData(
        canvasColor: redColor,
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: primaryColor,
            ),
      ),
      child: Scaffold(
          appBar: buildAppBar(title: 'Inscription'),
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

  Widget getBody() {
    return Container(
        padding: EdgeInsets.symmetric(
            horizontal: Get.width * 0.01, vertical: Get.width * 0.01),
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              Gap(Get.height * 0.01),
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
                                  Gap(Get.width * 0.1),
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
                                                ? Text(
                                                    'Enregistrer',
                                                    style: TextStyle(
                                                        fontSize:
                                                            Get.height * 0.020),
                                                  )
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
            title: Text(''),
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
                    controller: nomController,
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
                    controller: prenomController,
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
                    controller: dateNaissanceController,
                    decoration: InputDecoration(
                        prefixIcon: InkWell(
                          onTap: () async {
                            var pickedDate = await showDatePicker(
                                context: context,
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now());
                            if (pickedDate != null) {
                              dateNaissanceController.text =
                                  DateFormat('dd-MM-yyyy').format(pickedDate);
                              setState(() {
                                dateNaissanceValue =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                              });
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
                      dateNaissanceController.clear();
                    },
                  ),
                  Gap(Get.height * 0.03),
                  TextFieldWidget(
                    controller: placeOfBirthdayController,
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
                    controller: phoneNumberController,
                    obscure: false,
                    keyboardType: TextInputType.phone,
                    onChanged: (value) {},
                    onChangeCountry: (value) {
                      indicePaysController.text = value;
                      print(value);
                    },
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
                    controller: prenomPereController,
                    obscure: false,
                    keyboardType: TextInputType.name,
                    onChanged: (value) {},
                    hintText: 'Prénom(s) du père',
                  ),
                  Gap(Get.height * 0.03),
                  TextFieldWidget(
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'prénom(s) du père obligatoire';
                      } else {
                        return null;
                      }
                    },
                    controller: prenomMereController,
                    obscure: false,
                    keyboardType: TextInputType.name,
                    onChanged: (value) {},
                    hintText: 'Prénom(s) de la mère',
                  ),
                  Gap(Get.height * 0.03),
                  TextFieldWidget(
                    controller: nomMereController,
                    obscure: false,
                    keyboardType: TextInputType.name,
                    onChanged: (value) {},
                    hintText: 'Nom de la mère',
                  ),
                  _buildTypePieceDw(),
                  TextFieldWidget(
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'numero de la piece d\'identite obligatoire';
                      } else {
                        return null;
                      }
                    },
                    controller: identityCardNumberController,
                    obscure: false,
                    keyboardType: TextInputType.name,
                    onChanged: (value) {},
                    hintText: 'numero de la piece d\'identite',
                  ),
                  SizedBox(
                    height: Get.height * 0.03,
                  ),
                  SizedBox(
                    height: Get.height * 0.03,
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
                              nationalityPereController.text = country.name;
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
                    controller: nationalityPereController,
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
                    controller: professionController,
                    obscure: false,
                    keyboardType: TextInputType.name,
                    onChanged: (value) {},
                    hintText: 'Profession',
                  ),
                  Gap(Get.height * 0.03),
                  TextFieldWidget(
                    controller: posteController,
                    obscure: false,
                    keyboardType: TextInputType.name,
                    onChanged: (value) {},
                    hintText: 'Poste Occupé',
                  ),
                  _buildDipDw(),
                  TextFieldWidget(
                    controller: personToContactController,
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
                          fontSize: Get.width * 0.03,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                        filled: true,
                        fillColor: primaryColorLight,
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: Get.width * 0.005, color: primaryColor),
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
            // child: Column(
            //   children: [
            //     _buildFederationDw(),
            //     _buildSectionDw(),
            //     _buildSubSectionDw(),
            //     _buildComityDw(),
            //     Gap(Get.height * 0.04),
            //     TextFormField(
            //       validator: (value) {
            //         if (value == null || value.isEmpty) {
            //           return 'Selectionnez une date';
            //         }
            //         return null;
            //       },
            //       controller: dateAdhesionController,
            //       keyboardType: TextInputType.datetime,
            //       inputFormatters: [
            //         TestMaskFormatter(mask: 'xx-xx-xxxx', separator: '-')
            //       ],
            //       onTap: () {
            //         dateAdhesionController.clear();
            //       },
            //       style: const TextStyle(color: Colors.white),
            //       decoration: InputDecoration(
            //           prefixIconColor: Colors.white,
            //           prefixIcon: InkWell(
            //               onTap: () async {
            //                 var pickedDate = await showDatePicker(
            //                     context: context,
            //                     firstDate: DateTime(2010),
            //                     lastDate: DateTime.now());
            //                 if (pickedDate != null) {
            //
            //                   setState(() {
            //                     dateAdhesionController.text =
            //                       DateFormat('dd-MM-yyyy')
            //                           .format(pickedDate);
            //                     dateAdhesion =
            //                         DateFormat('yyyy-MM-dd').format(pickedDate);
            //
            //                   });
            //
            //                   // print('date adhesion $dateAdhesion');
            //                 }
            //               },
            //               child: const Icon(Icons.calendar_month)),
            //           hintText: "Date d'adhésion (dd-mm-yyyy) ",
            //           focusedBorder: const OutlineInputBorder(
            //               borderRadius: BorderRadius.all(Radius.circular(5.0)),
            //               borderSide: BorderSide(color: primaryColor)),
            //           errorStyle: const TextStyle(color: textColor),
            //           hintStyle: const TextStyle(
            //             fontSize: 18,
            //             fontWeight: FontWeight.normal,
            //             color: Colors.white,
            //           ),
            //           filled: true,
            //           fillColor: primaryColorLight,
            //           enabledBorder: OutlineInputBorder(
            //               borderSide:
            //                   const BorderSide(width: 2, color: primaryColor),
            //               borderRadius: BorderRadius.circular(5)),
            //           border: OutlineInputBorder(
            //               borderSide:
            //                   const BorderSide(width: 0, color: primaryColor),
            //               borderRadius: BorderRadius.circular(15))),
            //     ),
            //     Gap(Get.height * 0.04),
            //     Gap(Get.height * 0.04),
            //   ],
            // ),
            child: Column(
              children: [
                SizedBox(
                    height: Get.height * 0.06,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.camera_alt),
                      onPressed: () {
                        pickImageIdentityFromCamera();
                      },
                      label: Text("Prendre une photo de la piece à d'identite",
                          style: TextStyle(fontSize: Get.height * 0.020)),
                    )),
                Gap(Get.height * 0.04),
                Container(
                  height: Get.height * 0.3,
                  width: Get.width * 0.5,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(18),
                      color: Colors.white),
                  child: imageFileIdentity != null
                      ? Image.file(imageFileIdentity!)
                      : Icon(
                          color: Colors.grey,
                          Icons.person,
                          size: Get.height * 0.25,
                        ),
                ),
                Gap(Get.height * 0.04),
                Gap(Get.height * 0.04),
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
                      label: Text("Prendre une photo de la personne à inscrire",
                          style: TextStyle(fontSize: Get.height * 0.020)),
                    )),
                Gap(Get.height * 0.04),
                Container(
                  height: Get.height * 0.3,
                  width: Get.width * 0.5,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(18),
                      color: Colors.white),
                  child: imageFileProfile != null
                      ? Image.file(imageFileProfile!)
                      : Icon(
                          color: Colors.grey,
                          Icons.person,
                          size: Get.height * 0.25,
                        ),
                ),
                Gap(Get.height * 0.04),
              ],
            ),
          ),
        )
      ];

  Widget _buildHeader() {
    const double titleSizeCoef = 0.08;
    const double iconTitleSizeCoef = 0.06;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Get.width * 0.06),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'images/inscription.svg',
                height: Get.height * iconTitleSizeCoef,
                color: Colors.black,
              ),
              SizedBox(
                width: Get.width * 0.05,
              ),
              Text(
                "Inscription",
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

  _buildTypePieceDw() {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: Get.height * 0.02),
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
              isExpanded: true,
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

  _buildFederationDw() {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: Get.height * 0.03),
        child: GetBuilder<DropdownController>(
          builder: (dropdownController) =>
              DropdownButtonFormField<RegionalFederation>(
                  value: dropdownController.selectedFederation.value,
                  disabledHint: const Text(
                    'Federation non disponible',
                    style: TextStyle(color: Colors.white),
                  ),
                  hint: const Text('Selectionnez la Federation',
                      style: TextStyle(color: Colors.white)),
                  decoration: dropdownDecoration(),
                  dropdownColor: primaryColor,
                  items: dropdownController.federationList.isEmpty
                      ? []
                      : dropdownController.federationList.map((v) {
                          return DropdownMenuItem<RegionalFederation>(
                              value: v,
                              key: UniqueKey(),
                              child: Text(
                                v.nom ?? '',
                                style: const TextStyle(color: Colors.white),
                              ));
                        }).toList(),
                  onChanged: (value) {
                    dropdownController.onSelectFederation(value!);
                  }),
        ));
  }

  _buildSectionDw() {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: Get.height * 0.02),
        child: GetBuilder<DropdownController>(
          builder: (dropdownController) => DropdownButtonFormField<Section>(
              value: dropdownController.selectedSection.value,
              disabledHint: const Text(
                ' Section non disponible',
                style: TextStyle(color: Colors.black),
              ),
              hint: const Text('Selectionnez la Section',
                  style: TextStyle(color: Colors.white)),
              decoration: dropdownDecoration(),
              dropdownColor: primaryColor,
              items: dropdownController
                          .selectedFederation.value?.sections?.isEmpty ??
                      true
                  ? []
                  : dropdownController.selectedFederation.value?.sections
                      ?.toSet()
                      .map((v) {
                      return DropdownMenuItem<Section>(
                          value: v,
                          key: UniqueKey(),
                          child: Text(
                            v.nom ?? '',
                            style: const TextStyle(color: Colors.white),
                          ));
                    }).toList(),
              onChanged: dropdownController
                          .selectedFederation.value?.sections?.isEmpty ??
                      true
                  ? null
                  : (value) {
                      dropdownController.onSelectSection(value!);
                    }),
        ));
  }

  _buildSubSectionDw() {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: Get.height * 0.03),
        child: GetBuilder<DropdownController>(
          builder: (dropdownController) => DropdownButtonFormField<SubSection>(
              value: dropdownController.selectedSubSection.value,
              disabledHint: const Text(
                'Sous Section non disponible',
                style: TextStyle(color: Colors.black),
              ),
              hint: const Text('Selectionnez la Sous Section',
                  style: TextStyle(color: Colors.white)),
              decoration: dropdownDecoration(),
              dropdownColor: primaryColor,
              items: dropdownController
                          .selectedSection.value?.subSections?.isEmpty ??
                      true
                  ? []
                  : dropdownController.selectedSection.value?.subSections
                      ?.toSet()
                      .map((v) {
                      return DropdownMenuItem<SubSection>(
                          value: v,
                          key: UniqueKey(),
                          child: Text(
                            v.nom ?? '',
                            style: const TextStyle(color: Colors.white),
                          ));
                    }).toList(),
              onChanged: dropdownController
                          .selectedSection.value?.subSections?.isEmpty ??
                      true
                  ? null
                  : (value) {
                      dropdownController.onSelectSubSection(value!);
                    }),
        ));
  }

  Widget _buildComityDw() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Get.height * 0.02),
      child: GetBuilder<DropdownController>(
        builder: (dropdownController) {
          return DropdownButtonFormField<Comity>(
            value: dropdownController.selectedComity.value,
            disabledHint: const Text(
              'Comité non disponible',
              style: TextStyle(color: Colors.black),
            ),
            hint: const Text('Selectionnez le Comité',
                style: TextStyle(color: Colors.white)),
            decoration: dropdownDecoration(),
            isExpanded: true,
            dropdownColor: primaryColor,
            items: dropdownController
                        .selectedSubSection.value?.comities?.isEmpty ??
                    true
                ? []
                : dropdownController.selectedSubSection.value?.comities
                    ?.map((v) {
                    return DropdownMenuItem<Comity>(
                      key: UniqueKey(),
                      value: v,
                      child: Text(
                        v.nom ?? '',
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
            onChanged: dropdownController
                        .selectedSubSection.value?.comities?.isEmpty ??
                    true
                ? null
                : (value) {
                    dropdownController.onSelectComity(value!);
                  },
          );
        },
      ),
    );
  }
}

// Widget _buildDropdownT<T>({
//     required String hintText,
//     required List<T> items,
//     T? selectedItem,
//     required String Function(T) getItemLabel,
//     required ValueChanged<T?> onChanged,
//   }) {
//     final uniqueItems = items.toSet().toList();
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: Get.height * 0.02),
//       child: DropdownButtonFormField<T>(
//         dropdownColor: primaryColor,
//         validator: (value) {
//           if (items.isNotEmpty && value == null) {
//             return 'Selectionnez un element';
//           } else {
//             return null;
//           }
//         },
//         decoration: dropdownDecoration(),
//         isExpanded: true,
//         hint: Text(hintText, style: const TextStyle(color: Colors.white)),
//         items: uniqueItems.isEmpty
//             ? []
//             : uniqueItems.map<DropdownMenuItem<T>>((T item) {
//                 return DropdownMenuItem<T>(
//                   key: UniqueKey(),
//                   value: item,
//                   child: Text(
//                     getItemLabel(item),
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                 );
//               }).toList(),
//         onChanged: onChanged,
//       ),
//     );
//   }
