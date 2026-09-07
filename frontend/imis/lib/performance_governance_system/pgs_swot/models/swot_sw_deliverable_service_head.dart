import 'package:json_annotation/json_annotation.dart';

part 'swot_sw_deliverable_service_head.g.dart';

@JsonSerializable()
class SwotSwDeliverableServiceHead {
  int? id;

  bool? isDeleted;

  String? rowVersion;

  int? swotAnalysisId;

  int? internalContextId;

  String? internalContext;

  String? strength;

  String? weaknesses;

  SwotSwDeliverableServiceHead({
    this.id,
    this.isDeleted,
    this.rowVersion,
    this.swotAnalysisId,
    this.internalContextId,
    this.internalContext,
    this.strength,
    this.weaknesses,
  });

  factory SwotSwDeliverableServiceHead.fromJson(Map<String, dynamic> json) =>
      _$SwotSwDeliverableServiceHeadFromJson(json);

  Map<String, dynamic> toJson() => _$SwotSwDeliverableServiceHeadToJson(this);
}
