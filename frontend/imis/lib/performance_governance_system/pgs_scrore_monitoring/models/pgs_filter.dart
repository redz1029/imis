import 'package:json_annotation/json_annotation.dart';

part 'pgs_filter.g.dart';

@JsonSerializable()
class PgsFilter {
  int? pgsPeriodId;
  int? officeId;
  int? kraId;
  bool? isDirect;
  int? scoreRangeFrom;
  int? scoreRangeTo;
  int? page;
  int? pageSize;

  PgsFilter(
    this.pgsPeriodId,
    this.officeId,
    this.kraId,
    this.isDirect,
    this.scoreRangeFrom,
    this.scoreRangeTo,
    this.page,
    this.pageSize,
  );

  factory PgsFilter.fromJson(Map<String, dynamic> json) =>
      _$PgsFilterFromJson(json);

  Map<String, dynamic> toJson() => _$PgsFilterToJson(this);
}
