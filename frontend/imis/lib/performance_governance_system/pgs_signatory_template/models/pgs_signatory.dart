import 'package:imis/utils/date_time_converter.dart';
import 'package:json_annotation/json_annotation.dart';
part 'pgs_signatory.g.dart';

@JsonSerializable()
class PgsSignatory {
  final int id;
  final int? pgsId;
  final int? pgsSignatoryTemplateId;
  final String? signatoryId;

  @JsonKey()
  @DateTimeConverter()
  DateTime dateSigned;

  bool isDeleted;
  String? rowVersion;

  PgsSignatory(
    this.dateSigned,
    this.isDeleted,
    this.rowVersion, {
    required this.id,
    required this.pgsId,
    required this.pgsSignatoryTemplateId,
    required this.signatoryId,
  });
  factory PgsSignatory.fromJson(Map<String, dynamic> json) =>
      _$PgsSignatoryFromJson(json);

  Map<String, dynamic> toJson() => _$PgsSignatoryToJson(this);
}
