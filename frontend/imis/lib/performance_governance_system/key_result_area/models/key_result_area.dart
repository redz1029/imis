import 'package:json_annotation/json_annotation.dart';

part 'key_result_area.g.dart';

@JsonSerializable()
class KeyResultArea {
  int id;
  String name;
  String remarks;
  bool isDeleted;
  String? rowVersion;

  KeyResultArea(
    this.id,
    this.name,
    this.remarks,
    this.isDeleted, {
    this.rowVersion,
  });

  factory KeyResultArea.fromJson(Map<String, dynamic> json) =>
      _$KeyResultAreaFromJson(json);

  Map<String, dynamic> toJson() => _$KeyResultAreaToJson(this);
}
