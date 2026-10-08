import 'package:json_annotation/json_annotation.dart';
part 'isat_employee_office.g.dart';

@JsonSerializable()
class IsatEmployeeOffice {
  int id;
  String name;
  int parentOfficeId;
  String parentOfficeName;

  IsatEmployeeOffice(
    this.id,
    this.name,
    this.parentOfficeId,
    this.parentOfficeName,
  );

  factory IsatEmployeeOffice.fromJson(Map<String, dynamic> json) =>
      _$IsatEmployeeOfficeFromJson(json);

  Map<String, dynamic> toJson() => _$IsatEmployeeOfficeToJson(this);
}
