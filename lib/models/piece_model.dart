import 'package:equatable/equatable.dart';

import 'section_model.dart';

class TypePiece extends Equatable{
  int? id;
  String? name;

  TypePiece({
    this.id,
    this.name,

  });

  factory TypePiece.fromJson(Map<String, dynamic> json) {
    // var sectionsFromJson = json['sections'] as List?;
    // List<Section>? sectionsList = sectionsFromJson?.map((sectionJson) => Section.fromJson(sectionJson)).toList();

    return TypePiece(
      id: json['id'],
      name: json['name'],

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,

    };
  }
  
  
  @override
  // TODO: implement props
  List<Object?> get props => [id,name]; // Utilise le même attribut pour le hash
}

