import 'package:json_annotation/json_annotation.dart';

part 'kpi_filter.g.dart';

@JsonSerializable()
class KpiFilter {
  int? kraid;

  KpiFilter(this.kraid);

  factory KpiFilter.fromJson(Map<String, dynamic> json) =>
      _$KpiFilterFromJson(json);

  Map<String, dynamic> toJson() => _$KpiFilterToJson(this);
}
