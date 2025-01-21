import 'package:equatable/equatable.dart';

import 'sub_section_model.dart';

class Level extends Equatable{
  int? id;
  String? createdAt;
  String? updatedAt;
  String? name;

  Level({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.name,

  });

  factory Level.fromJson(Map<String, dynamic> json) {
    // var subSectionsFromJson = json['subSections'] as List?;
    // List<SubSection>? subSectionsList = subSectionsFromJson?.map((subSectionJson) => SubSection.fromJson(subSectionJson)).toList();

    return Level(
      id: json['id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      name: json['name'],

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'name': name,
    };
  }

  
  @override
  // TODO: implement props
  List<Object?> get props => [id,name];
}
