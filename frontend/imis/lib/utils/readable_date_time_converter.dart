import 'package:json_annotation/json_annotation.dart';
import 'package:intl/intl.dart';

class ReadableDateTimeConverter implements JsonConverter<DateTime, String> {
  const ReadableDateTimeConverter();

  static final DateFormat _formatter = DateFormat('MMM, dd, yyyy hh:mm a');

  @override
  DateTime fromJson(String json) => _formatter.parse(json);

  @override
  String toJson(DateTime object) => _formatter.format(object);
}
