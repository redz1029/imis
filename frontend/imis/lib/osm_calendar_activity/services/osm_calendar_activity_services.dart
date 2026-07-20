import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:imis/osm_calendar_activity/models/osm_calendar_activity.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';

class OsmCalendarActivityServices {
  final Dio dio;

  OsmCalendarActivityServices(this.dio);

  Future<void> saveOsmActivity(FormData formData, {int? id}) async {
    final url = ApiEndpoint().calendarActivity + (id != null ? '/$id' : '');

    final response =
        id != null
            ? await AuthenticatedRequest.put(dio, url, data: formData)
            : await AuthenticatedRequest.post(dio, url, data: formData);

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create/update osm calendar activity');
    }
  }

  Future<List<OsmCalendarActivity>> getOsmActivities() async {
    final url = ApiEndpoint().calendarActivity;
    final response = await AuthenticatedRequest.get(dio, url);
    return (response.data as List)
        .map((e) => OsmCalendarActivity.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<OsmCalendarActivity> getOsmActivityById(int id) async {
    final url = '${ApiEndpoint().calendarActivity}/$id';
    final response = await AuthenticatedRequest.get(dio, url);
    return OsmCalendarActivity.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<int>> getActivityAttachmentPreview(int id) async {
    final url = '${ApiEndpoint().calendarActivity}/calendar/$id/preview';
    final response = await AuthenticatedRequest.get(
      dio,
      url,
      options: Options(responseType: ResponseType.bytes),
    );
    return response.data as List<int>;
  }

  Future<void> deleteCalendar(String calendar) async {
    final url = '${ApiEndpoint().calendarActivity}/$calendar';
    await AuthenticatedRequest.delete(dio, url);
  }
}

Future<FormData> buildCalendarActivityFormData({
  required OsmCalendarActivity activity,
  PlatformFile? pickedFile,
  bool removeAttachment = false,
}) async {
  final map = <String, dynamic>{
    'id': activity.id,
    'title': activity.title,
    'description': activity.description ?? '',
    'startDate': activity.startDate.toIso8601String(),
    'isAllDay': activity.isAllDay ?? false,
    'color': activity.color ?? '',
    'category': activity.category ?? '',
    'location': activity.location ?? '',
    'status': activity.status ?? 0,
    'userId': activity.userId ?? '',
    'userFullName': activity.userFullName ?? '',
    'officeId': activity.officeId ?? 0,
    'reminderMinutes': activity.reminderMinutes ?? 0,
    'meetingLink': activity.meetingLink ?? '',
    'removeAttachment': removeAttachment,
  };

  if (activity.startTime != null && activity.startTime!.isNotEmpty) {
    map['startTime'] = activity.startTime;
  }
  if (activity.endTime != null && activity.endTime!.isNotEmpty) {
    map['endTime'] = activity.endTime;
  }

  if (pickedFile != null) {
    if (pickedFile.bytes != null) {
      map['attachment'] = MultipartFile.fromBytes(
        pickedFile.bytes!,
        filename: pickedFile.name,
      );
    } else if (pickedFile.path != null) {
      map['attachment'] = await MultipartFile.fromFile(
        pickedFile.path!,
        filename: pickedFile.name,
      );
    }
  }

  return FormData.fromMap(map);
}
