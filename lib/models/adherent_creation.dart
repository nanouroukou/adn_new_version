import 'package:cherifla/models/comity_model.dart';
import 'package:cherifla/models/dipole.dart';
import 'package:cherifla/models/federation_model.dart';
import 'package:cherifla/models/level_model.dart';
import 'package:cherifla/models/piece_model.dart';
import 'package:cherifla/models/section_model.dart';
import 'package:cherifla/models/sub_section_model.dart';

class AdherentCreation {
  String? nom;
  String? prenom;
  String? phone;
  String? dateNaissance;
  String? adhesionDate;
  String? sexe;
  String? identityCardNumber;
  Object? identityType;
  Object? degree;
  String? prenomPere;
  String? picture;
  String? position;
  String? prenomMere;
  String? nomMere;
  String? codeAdherent;
  String? nationality;
  String? placeOfBirthday;
  String? profession;
  String? personToContact;
  Level? level;

  AdherentCreation(
      {this.nom,
      this.prenom,
      this.phone,
      this.dateNaissance,
      this.adhesionDate,
      this.prenomPere,
      this.prenomMere,
      this.position,
      this.nomMere,
      this.personToContact,
      this.placeOfBirthday,
      this.profession,
      this.nationality,
      this.level,
      this.picture,
      this.identityCardNumber,
      this.identityType,
      required this.sexe,
      this.degree,
      this.codeAdherent});

  factory AdherentCreation.fromJson(Map<String, dynamic> json) {
    return AdherentCreation(
      nom: json['nom'],
      prenom: json['prenom'],
      phone: json['phone'],
      dateNaissance: json['dateNaissance'],
      adhesionDate: json['adhesionDate'],
      prenomPere: json['prenomPere'],
      prenomMere: json['prenomMere'],
      nomMere: json['nomMere'],
      nationality: json['nationality'],
      profession: json['profession'],
      position: json['position'],
      placeOfBirthday: json['placeOfBirthday'],
      personToContact: json['personToContact'],
      level: Level.fromJson(json['level6']),
      codeAdherent: json['codeAdherent'],
      identityType: TypePiece.fromJson(json['identityType']),
      degree: Diplome.fromJson(json['degree']),
      sexe: json['sexe'],
      picture: json['picture'],
      identityCardNumber: json['identityCardNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'prenom': prenom,
      'phone': phone,
      'placeOfBirthday': placeOfBirthday,
      'nationality': nationality,
      'personToContact': personToContact,
      'profession': profession,
      'dateNaissance': dateNaissance,
      'adhesionDate': adhesionDate,
      'prenomPere': prenomPere,
      'prenomMere': prenomMere,
      'nomMere': nomMere,
      'picture': picture,
      'position': position,
      'codeAdherent': codeAdherent,
      'level6': level,
      'identityType': identityType,
      'degree': degree,
      'identityCardNumber': identityCardNumber,
      'sexe': sexe,
    };
  }
}
