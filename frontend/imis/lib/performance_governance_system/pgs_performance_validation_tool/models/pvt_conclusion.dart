import 'package:imis/utils/date_time_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pvt_conclusion.g.dart';

@JsonSerializable()
class PvtConclusion {
  int id;
  bool isDeleted;
  String? rowVersion;
  int performanceValidationToolId;
  bool? isCompliant;
  bool? isImprovement;
  bool? isPartial;
  bool? isCritical;

  @DateTimeConverter()
  DateTime postingDate;

  PvtConclusion(
    this.id,
    this.performanceValidationToolId,
    this.postingDate,
    this.isDeleted, {
    this.isCompliant,
    this.isImprovement,
    this.isPartial,
    this.isCritical,
    this.rowVersion,
  });

  factory PvtConclusion.fromJson(Map<String, dynamic> json) =>
      _$PvtConclusionFromJson(json);

  Map<String, dynamic> toJson() => _$PvtConclusionToJson(this);
}
