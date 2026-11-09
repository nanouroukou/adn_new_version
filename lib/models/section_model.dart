import 'package:equatable/equatable.dart';

import 'sub_section_model.dart';

class Section extends Equatable {
  int? id;
  String? createdAt;
  String? updatedAt;
  String? nom;
  List<SubSection>? subSections;

  Section({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.nom,
    this.subSections,
  });

  factory Section.fromJson(Map<String, dynamic> json) {
    var subSectionsFromJson = json['subSections'] as List?;
    List<SubSection>? subSectionsList = subSectionsFromJson
        ?.map((subSectionJson) => SubSection.fromJson(subSectionJson))
        .toList();

    return Section(
      id: json['id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      nom: json['nom'],
      subSections: subSectionsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'nom': nom,
      'subSections':
          subSections?.map((subSection) => subSection.toJson()).toList(),
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props => [id, nom];
}
