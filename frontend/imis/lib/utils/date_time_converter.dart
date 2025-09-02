import 'package:json_annotation/json_annotation.dart';
import 'package:intl/intl.dart';

class DateTimeConverter implements JsonConverter<DateTime, String> {
  const DateTimeConverter();

  static final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  @override
  DateTime fromJson(String json) => dateFormat.parse(json);

  @override
  String toJson(DateTime object) => dateFormat.format(object);
}

class ReadableDateTimeConverter implements JsonConverter<DateTime, String> {
  const ReadableDateTimeConverter();

  static final DateFormat _formatter = DateFormat('MMM, dd, yyyy hh:mm a');

  @override
  DateTime fromJson(String json) => _formatter.parse(json);

  @override
  String toJson(DateTime object) => _formatter.format(object);
}

class LongDateOnlyConverter implements JsonConverter<DateTime, String> {
  const LongDateOnlyConverter();

  static final DateFormat _formatter = DateFormat('MMMM dd, yyyy');

  @override
  DateTime fromJson(String json) {
    return DateTime.parse(json);
  }

  @override
  String toJson(DateTime object) {
    return _formatter.format(object);
  }
}
