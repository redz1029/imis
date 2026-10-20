import 'package:json_annotation/json_annotation.dart';

part 'strategy_review_office.g.dart';

@JsonSerializable(explicitToJson: true)
class StrategyReviewOfficeResponse {
  @JsonKey(defaultValue: '')
  String roadmapName;

  @JsonKey(defaultValue: [])
  List<StrategyReviewOffice> deliverables;

  StrategyReviewOfficeResponse(this.roadmapName, this.deliverables);

  factory StrategyReviewOfficeResponse.fromJson(Map<String, dynamic> json) =>
      _$StrategyReviewOfficeResponseFromJson(json);
  Map<String, dynamic> toJson() => _$StrategyReviewOfficeResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class StrategyReviewOffice {
  @JsonKey(defaultValue: '')
  String officeName;

  @JsonKey(defaultValue: [])
  List<StrategyReviewOfficeDeliverable> deliverables;

  StrategyReviewOffice(this.officeName, this.deliverables);

  factory StrategyReviewOffice.fromJson(Map<String, dynamic> json) =>
      _$StrategyReviewOfficeFromJson(json);
  Map<String, dynamic> toJson() => _$StrategyReviewOfficeToJson(this);
}

@JsonSerializable(explicitToJson: true)
class StrategyReviewOfficeDeliverable {
  @JsonKey(defaultValue: 0)
  int pgsDeliverableId;

  @JsonKey(defaultValue: '')
  String deliverableName;

  StrategyReviewOfficeAccomplishment? accomplishment;

  StrategyReviewOfficeDeliverable(
    this.pgsDeliverableId,
    this.deliverableName, {
    this.accomplishment,
  });

  factory StrategyReviewOfficeDeliverable.fromJson(Map<String, dynamic> json) =>
      _$StrategyReviewOfficeDeliverableFromJson(json);
  Map<String, dynamic> toJson() =>
      _$StrategyReviewOfficeDeliverableToJson(this);
}

@JsonSerializable()
class StrategyReviewOfficeAccomplishment {
  DateTime? postingDate;
  String? postingMonth;
  num? percentAccomplished;
  String? remarks;
  String? auditorRemarks;
  int? status;

  StrategyReviewOfficeAccomplishment({
    this.postingDate,
    this.postingMonth,
    this.percentAccomplished,
    this.remarks,
    this.auditorRemarks,
    this.status,
  });

  factory StrategyReviewOfficeAccomplishment.fromJson(
    Map<String, dynamic> json,
  ) => _$StrategyReviewOfficeAccomplishmentFromJson(json);
  Map<String, dynamic> toJson() =>
      _$StrategyReviewOfficeAccomplishmentToJson(this);
}
