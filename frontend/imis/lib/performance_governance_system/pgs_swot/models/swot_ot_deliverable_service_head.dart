import 'package:json_annotation/json_annotation.dart';

part 'swot_ot_deliverable_service_head.g.dart';

@JsonSerializable()
class SwotOtDeliverableServiceHead {
  int? id;

  bool? isDeleted;

  String? rowVersion;

  int? swotAnalysisId;

  int? externalContextId;

  String? externalContext;

  String? opportunities;

  String? threats;

  SwotOtDeliverableServiceHead({
    this.id,
    this.isDeleted,
    this.rowVersion,
    this.swotAnalysisId,
    this.externalContextId,
    this.externalContext,
    this.opportunities,
    this.threats,
  });

  factory SwotOtDeliverableServiceHead.fromJson(Map<String, dynamic> json) =>
      _$SwotOtDeliverableServiceHeadFromJson(json);

  Map<String, dynamic> toJson() => _$SwotOtDeliverableServiceHeadToJson(this);
}
