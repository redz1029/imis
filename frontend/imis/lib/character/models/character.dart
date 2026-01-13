import 'package:json_annotation/json_annotation.dart';

part 'character.g.dart';

@JsonSerializable()
class Character {

  final int id;
  final String name;
  final String? rowVersion;
  final String remarks;
  final bool? isdelete;

  Character({
    required this.id,
    required this.name,
    required this.rowVersion,
    required this.remarks,
    required this.isdelete,
  }); 

  factory Character.fromJson(Map<String, dynamic> json) =>
      _$CharacterFromJson(json);

  Map<String, dynamic> toJson() => _$CharacterToJson(this);
}
