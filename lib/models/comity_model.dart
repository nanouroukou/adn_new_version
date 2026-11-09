import 'package:equatable/equatable.dart';

class Comity extends Equatable {
  int? id;
  String? createdAt;
  String? updatedAt;
  String? nom;
  Object? pays;
  Object? region;
  Object? quarter;
  Object? commune;
  Object? cercle;

  Comity(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.nom,
      this.pays,
      this.region,
      this.quarter,
      this.commune,
      this.cercle});

  factory Comity.fromJson(Map<String, dynamic> json) {
    return Comity(
        id: json['id'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
        nom: json['nom'],
        pays: json['pays'],
        region: json['region'],
        quarter: json['quarter'],
        commune: json['commune'],
        cercle: json['cercle']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'nom': nom,
      'pays': pays,
      'region': region,
      'quarter': quarter,
      'commune': commune,
      'cercle': cercle
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props => [nom];
}
