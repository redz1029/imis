import 'package:json_annotation/json_annotation.dart';

part 'swot_ot_deliverable.g.dart';

@JsonSerializable()
class SwotOtDeliverable {
  int? id;

  bool? isDeleted;

  String? rowVersion;

  int? swotAnalysisId;

  int? externalContextId;

  String? externalContext;

  String? opportunities;

  String? threats;

  SwotOtDeliverable({
    this.id,
    this.isDeleted,
    this.rowVersion,
    this.swotAnalysisId,
    this.externalContextId,
    this.externalContext,
    this.opportunities,
    this.threats,
  });

  factory SwotOtDeliverable.fromJson(Map<String, dynamic> json) =>
      _$SwotOtDeliverableFromJson(json);

  Map<String, dynamic> toJson() => _$SwotOtDeliverableToJson(this);
}
