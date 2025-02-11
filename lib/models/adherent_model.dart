import 'dart:ffi';

import 'package:cherifla/models/comity_model.dart';
import 'package:cherifla/models/dipole.dart';
import 'package:cherifla/models/level_model.dart';
import 'package:cherifla/models/piece_model.dart';

import 'federation_model.dart';
import 'section_model.dart';
import 'sub_section_model.dart';

class Adherent {
  String? nom;
  String? indicePays;
  String? prenom;
  String? phone;
  String? dateNaissance;
  String? adhesionDate;
  String? sexe;
  String? identityCardNumber;
  TypePiece? identityType;
  Diplome? degree;
  String? prenomPere;
  String? picture;
  String? prenomMere;
  String? nomMere;
  String? codeAdherent;
  String? identityDocImage;
  Level? level;
  String? nationality;
  String? placeOfBirthday;
  String? profession;
  String? position;
  String? personToContact;
  bool? deactivate;
  bool? suspend;
  String? suspendReason;
  String? deactivateReason;

  // Map<String,dynamic>? registerAgent;
  // RegionalFederation regionalFederation;
  // Section section;
  // SubSection subSection;
  // Comity comity;

  Adherent(
      {this.nom,
      this.prenom,
      this.indicePays,
      this.phone,
      this.dateNaissance,
      this.adhesionDate,
      this.prenomPere,
      this.prenomMere,
      this.nomMere,
      this.level,
      this.position,
      this.personToContact,
      this.placeOfBirthday,
      this.profession,
      this.nationality,
      this.identityDocImage,
      this.picture,
      this.identityCardNumber,
      required this.identityType,
      required this.sexe,
      this.codeAdherent,
      this.deactivate,
      this.suspendReason,
      this.suspend,
      this.degree,
      this.deactivateReason});

  // Méthode pour convertir un JSON en objet Adherent
  factory Adherent.fromJson(Map<String, dynamic> json) {
    return Adherent(
      nom: json['nom'],
      indicePays: json['indicePays'],
      prenom: json['prenom'],
      phone: json['phone'],
      dateNaissance: json['dateNaissance'],
      adhesionDate: json['adhesionDate'],
      prenomPere: json['prenomPere'],
      prenomMere: json['prenomMere'],
      nomMere: json['nomMere'],
      personToContact: json['personToContact'],
      profession: json['profession'],
      position: json['position'],
      nationality: json['nationality'],
      placeOfBirthday: json['placeOfBirthday'],
      level: json['level6'] == null ? null : Level.fromJson(json['level6']),
      codeAdherent: json['codeAdherent'],
      identityType: TypePiece.fromJson(json['identityType']),
      degree: Diplome.fromJson(json['degree']),
      sexe: json['sexe'],
      picture: json['picture'],
      deactivate: json['deactivate'],
      identityDocImage: json['identityDocImage'],
      identityCardNumber: json['identityCardNumber'],
      suspendReason: json['suspendReason'],
      deactivateReason: json['deactivateReason'],
      suspend: json['suspend'],
      // registerAgent: json['registerAgent'],
      // regionalFederation: RegionalFederation.fromJson(json['regionalFederation']),
      // section: Section.fromJson(json['section']),
      // subSection: SubSection.fromJson(json['subSection']),
      // comity: Comity.fromJson(json['comity'])
    );
  }

  // Méthode pour convertir un objet Adherent en JSON
  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'prenom': prenom,
      'phone': phone,
      'dateNaissance': dateNaissance,
      'adhesionDate': adhesionDate,
      'prenomPere': prenomPere,
      'prenomMere': prenomMere,
      'nomMere': nomMere,
      'picture': picture,
      'indicePays': indicePays,
      'codeAdherent': codeAdherent,
      'level6': level,
      'identityType': identityType,
      'degree': degree,
      'identityCardNumber': identityCardNumber,
      'identityDocImage': identityDocImage,
      'placeOfBirthday': placeOfBirthday,
      'nationality': nationality,
      'personToContact': personToContact,
      'profession': profession,
      'deactivate': deactivate,
      'position': position,
      'sexe': sexe,
      'suspendReason': suspendReason,
      'deactivateReason': deactivateReason,
      'suspend': suspend,
    };
  }
}
