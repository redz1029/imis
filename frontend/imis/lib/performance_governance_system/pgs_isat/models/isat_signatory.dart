import 'package:json_annotation/json_annotation.dart';
part 'isat_signatory.g.dart';

@JsonSerializable()
class IsatSignatory {
  int? id;
  int? isatId;
  int? isatSignatoryTemplateId;
  String? signatoryId;
  String? signatoryName;
  DateTime? dateSigned;
  String? label;
  String? status;
  int orderLevel;
  bool isNextStatus;
  bool isDeleted;
  String? rowVersion;

  IsatSignatory({
    this.id,
    this.isatId,
    this.isatSignatoryTemplateId,
    this.signatoryId,
    this.signatoryName,
    this.dateSigned,
    this.label,
    this.status,
    this.orderLevel = 0,
    this.isNextStatus = false,
    this.isDeleted = false,
    this.rowVersion,
  });

  factory IsatSignatory.fromJson(Map<String, dynamic> json) =>
      _$IsatSignatoryFromJson(json);

  Map<String, dynamic> toJson() => _$IsatSignatoryToJson(this);
}
