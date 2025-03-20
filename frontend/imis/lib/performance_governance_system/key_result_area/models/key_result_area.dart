import 'package:json_annotation/json_annotation.dart';

part 'key_result_area.g.dart';

@JsonSerializable()
class KeyResultArea {
  int id;
  String name;

  @JsonKey(defaultValue: '')
  String remarks;

  KeyResultArea(this.id, this.name, this.remarks);

  factory KeyResultArea.fromJson(Map<String, dynamic> json) =>
      _$KeyResultAreaFromJson(json);

  Map<String, dynamic> toJson() => _$KeyResultAreaToJson(this);
}
