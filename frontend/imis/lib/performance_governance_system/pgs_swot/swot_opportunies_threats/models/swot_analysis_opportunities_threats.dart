import 'package:json_annotation/json_annotation.dart';

part 'swot_analysis_opportunities_threats.g.dart';

@JsonSerializable()
class SwotAnalysisOpportunitiesThreats {
  int? id;
  bool? isDeleted;
  String? rowVersion;
  String? externalContext;

  SwotAnalysisOpportunitiesThreats(
    this.id,
    this.externalContext, {
    this.rowVersion,
    this.isDeleted,
  });

  factory SwotAnalysisOpportunitiesThreats.fromJson(
    Map<String, dynamic> json,
  ) => _$SwotAnalysisOpportunitiesThreatsFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SwotAnalysisOpportunitiesThreatsToJson(this);
}
