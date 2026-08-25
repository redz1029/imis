import 'package:json_annotation/json_annotation.dart';

part 'swot_analysis_strength_weakness.g.dart';

@JsonSerializable()
class SwotAnalysisStrengthWeakness {
  int? id;
  bool? isDeleted;
  String? rowVersion;
  String? internalContext;

  SwotAnalysisStrengthWeakness(
    this.id,
    this.internalContext, {
    this.rowVersion,
    this.isDeleted,
  });

  factory SwotAnalysisStrengthWeakness.fromJson(Map<String, dynamic> json) =>
      _$SwotAnalysisStrengthWeaknessFromJson(json);

  Map<String, dynamic> toJson() => _$SwotAnalysisStrengthWeaknessToJson(this);
}
