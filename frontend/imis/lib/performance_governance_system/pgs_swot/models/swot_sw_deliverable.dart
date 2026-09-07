import 'package:json_annotation/json_annotation.dart';

part 'swot_sw_deliverable.g.dart';

@JsonSerializable()
class SwotSwDeliverable {
  int? id;

  bool? isDeleted;

  String? rowVersion;

  int? swotAnalysisId;

  int? internalContextId;

  String? internalContext;

  String? strength;

  String? weaknesses;

  SwotSwDeliverable({
    this.id,
    this.isDeleted,
    this.rowVersion,
    this.swotAnalysisId,
    this.internalContextId,
    this.internalContext,
    this.strength,
    this.weaknesses,
  });

  factory SwotSwDeliverable.fromJson(Map<String, dynamic> json) =>
      _$SwotSwDeliverableFromJson(json);

  Map<String, dynamic> toJson() => _$SwotSwDeliverableToJson(this);
}
