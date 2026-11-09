import 'package:equatable/equatable.dart';

import 'section_model.dart';

class RegionalFederation extends Equatable {
  int? id;
  String? createdAt;
  String? updatedAt;
  String? nom;
  List<Section>? sections;

  RegionalFederation({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.nom,
    this.sections,
  });

  factory RegionalFederation.fromJson(Map<String, dynamic> json) {
    var sectionsFromJson = json['sections'] as List?;
    List<Section>? sectionsList = sectionsFromJson
        ?.map((sectionJson) => Section.fromJson(sectionJson))
        .toList();

    return RegionalFederation(
      id: json['id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      nom: json['nom'],
      sections: sectionsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'nom': nom,
      'sections': sections?.map((section) => section.toJson()).toList(),
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props => [id, nom]; // Utilise le même attribut pour le hash
}
