import 'package:equatable/equatable.dart';

import 'section_model.dart';

class Diplome extends Equatable {
  int? id;
  String? degreeLevel;
  String? degreeTitle;

  Diplome({
    this.id,
    this.degreeLevel,
    this.degreeTitle,
  });

  factory Diplome.fromJson(Map<String, dynamic> json) {
    // var sectionsFromJson = json['sections'] as List?;
    // List<Section>? sectionsList = sectionsFromJson?.map((sectionJson) => Section.fromJson(sectionJson)).toList();

    return Diplome(
      id: json['id'],
      degreeLevel: json['degreeLevel'],
      degreeTitle: json['degreeTitle'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'degreeLevel': degreeLevel,
      'degreeTitle': degreeTitle,
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props =>
      [id, degreeTitle]; // Utilise le même attribut pour le hash
}
