import 'package:equatable/equatable.dart';

import 'comity_model.dart';

class SubSection extends Equatable {
  int? id;
  String? createdAt;
  String? updatedAt;
  String? nom;
  List<Comity>? comities;

  SubSection({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.nom,
    this.comities,
  });

  factory SubSection.fromJson(Map<String, dynamic> json) {
    var comitiesFromJson = json['comities'] as List?;
    List<Comity>? comitiesList = comitiesFromJson
        ?.map((comityJson) => Comity.fromJson(comityJson))
        .toList();

    return SubSection(
      id: json['id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      nom: json['nom'],
      comities: comitiesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'nom': nom,
      'comities': comities?.map((comity) => comity.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [nom];
}
