import 'package:json_annotation/json_annotation.dart';
part 'isat_roadmap.g.dart';

@JsonSerializable()
class IsatRoadmap {
  int id;
  String kraName;
  String strategicObjective;

  IsatRoadmap(this.id, this.kraName, this.strategicObjective);

  factory IsatRoadmap.fromJson(Map<String, dynamic> json) =>
      _$IsatRoadmapFromJson(json);

  Map<String, dynamic> toJson() => _$IsatRoadmapToJson(this);
}
