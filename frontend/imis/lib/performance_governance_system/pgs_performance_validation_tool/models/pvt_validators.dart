import 'package:json_annotation/json_annotation.dart';

part 'pvt_validators.g.dart';

@JsonSerializable()
class PvtValidators {
  int id;
  bool? rowVersion;
  bool? isDeleted;
  int performanceValidationToolId;
  int auditorId;
  String? auditorName;
  DateTime postingDate;

  PvtValidators(
    this.id,
    this.isDeleted,
    this.performanceValidationToolId,
    this.auditorId,
    this.postingDate, {
    this.auditorName,
    this.rowVersion,
  });

  factory PvtValidators.fromJson(Map<String, dynamic> json) =>
      _$PvtValidatorsFromJson(json);
  Map<String, dynamic> toJson() => _$PvtValidatorsToJson(this);
}
