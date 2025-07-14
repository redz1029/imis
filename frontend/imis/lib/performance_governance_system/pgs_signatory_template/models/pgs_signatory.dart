import 'package:imis/utils/date_time_converter.dart';
import 'package:json_annotation/json_annotation.dart';
part 'pgs_signatory.g.dart';

@JsonSerializable()
class PgsSignatory {
  int? id;
  int? pgsId;
  int? pgsSignatoryTemplateId;
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

  PgsSignatory(
    this.id,
    this.pgsId,
    this.pgsSignatoryTemplateId,
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
  factory PgsSignatory.fromJson(Map<String, dynamic> json) =>
      _$PgsSignatoryFromJson(json);

  Map<String, dynamic> toJson() => _$PgsSignatoryToJson(this);
}
