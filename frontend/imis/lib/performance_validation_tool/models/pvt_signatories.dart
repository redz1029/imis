import 'package:imis/utils/date_time_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pvt_signatories.g.dart';

@JsonSerializable()
class PvtSignatories {
  int? id;
  int? performanceValidationToolId;
  int? performanceValidationToolSignatoryTemplateId;
  String? signatoryName;
  String? signatoryId;
  String? label;
  String? status;
  bool? isNextStatus;
  int? orderLevel;

  @JsonKey()
  @DateTimeConverter()
  DateTime dateSigned;

  bool isDeleted;
  String? rowVersion;

  PvtSignatories(
    this.id,
    this.performanceValidationToolId,
    this.performanceValidationToolSignatoryTemplateId,
    this.signatoryName,
    this.signatoryId,
    this.label,
    this.status,
    this.isNextStatus,
    this.orderLevel,
    this.dateSigned,
    this.isDeleted,
    this.rowVersion,
  );
  factory PvtSignatories.fromJson(Map<String, dynamic> json) =>
      _$PvtSignatoriesFromJson(json);

  Map<String, dynamic> toJson() => _$PvtSignatoriesToJson(this);
}
