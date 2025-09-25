import 'package:imis/utils/date_time_converter.dart';
import 'package:json_annotation/json_annotation.dart';
part 'pgs_deliverable_accomplishment.g.dart';

@JsonSerializable()
class PgsDeliverableAccomplishment {
  int id;
  int? pgsDeliverableId;

  @JsonKey()
  @DateTimeConverter()
  DateTime postingDate;
  String? userId;
  int? percentAccomplished;
  String? remarks;
  String? attachmentPath;

  final bool? isDeleted;
  final String? rowVersion;

  PgsDeliverableAccomplishment(
    this.id,
    this.pgsDeliverableId,
    this.postingDate,
    this.userId,
    this.percentAccomplished,
    this.remarks,
    this.attachmentPath, {
    this.isDeleted,
    this.rowVersion,
  });

  factory PgsDeliverableAccomplishment.fromJson(Map<String, dynamic> json) =>
      _$PgsDeliverableAccomplishmentFromJson(json);

  Map<String, dynamic> toJson() => _$PgsDeliverableAccomplishmentToJson(this);
}
