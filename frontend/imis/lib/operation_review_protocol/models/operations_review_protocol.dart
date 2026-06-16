import 'package:imis/utils/date_time_converter.dart';
import 'package:json_annotation/json_annotation.dart';
part 'operations_review_protocol.g.dart';

@JsonSerializable()
class OperationsReviewProtocol {
  int id;
  int? departmentId;
  int? divisionId;
  String? userId;
  String? deputy;
  String? documenter;
  int? performanceGovernanceSystemId;
  String? venue;
  String? scoreboardLocation;
  String? scoreboardOIC;
  String? actionPlan;
  String? form1;
  String? form2;
  String? form3;
  String? frequencySchedule;
  String? frequencyUpdate;
  String? frequency;
  String? minutesAttachmentPath;
  String? departmentName;
  String? divisionName;
  String? fullName;

  @JsonKey()
  @DateTimeConverter()
  DateTime? postingDate;

  bool? removeAttachment;
  final bool? isDeleted;
  final String? rowVersion;

  OperationsReviewProtocol(
    this.id,
    this.departmentId,
    this.userId,
    this.deputy,
    this.documenter,
    this.performanceGovernanceSystemId,
    this.venue,
    this.scoreboardLocation,
    this.scoreboardOIC,
    this.actionPlan,
    this.form1,
    this.form2,
    this.form3,
    this.frequencySchedule,
    this.frequencyUpdate,
    this.frequency,
    this.minutesAttachmentPath,
    this.postingDate,
    this.removeAttachment, {
    this.isDeleted,
    this.rowVersion,
    this.divisionId,
    this.departmentName,
    this.divisionName,
    this.fullName,
  });

  factory OperationsReviewProtocol.fromJson(Map<String, dynamic> json) =>
      _$OperationsReviewProtocolFromJson(json);

  Map<String, dynamic> toJson() => _$OperationsReviewProtocolToJson(this);
}
