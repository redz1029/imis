import 'package:json_annotation/json_annotation.dart';
part 'isat_employee_info.g.dart';

@JsonSerializable()
class IsatEmployeeInfo {
  String? userId;
  String? employeeName;
  String? position;
  int? officeId;
  String? officeName;
  String? supervisorUserId;
  String? supervisorName;
  int? parentOfficeId;
  String? parentOfficeName;

  IsatEmployeeInfo({
    this.userId,
    this.employeeName,
    this.position,
    this.officeId,
    this.officeName,
    this.supervisorUserId,
    this.supervisorName,
    this.parentOfficeId,
    this.parentOfficeName,
  });
  factory IsatEmployeeInfo.fromJson(Map<String, dynamic> json) =>
      _$IsatEmployeeInfoFromJson(json);

  Map<String, dynamic> toJson() => _$IsatEmployeeInfoToJson(this);
}
