import 'package:dio/dio.dart';
import 'package:imis/swot/models/swot.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';

class SwotService {
  final Dio dio;

  SwotService(this.dio);
  // Future<PageList<Swot>> getSwot({
  //   int page = 1,
  //   int pageSize = 15,
  //   String? searchQuery,
  //   required String userId, // Make userId required
  // }) async {
  //   UserRegistration? user = await AuthUtil.fetchLoggedUser();
  //   if (user == null) {
  //     return;
  //   }

  //   final paginationUtil = PaginationUtil(dio);
  //   return await paginationUtil.fetchPaginatedData<Swot>(
  //     endpoint:
  //         "${ApiEndpoint().swotAnalysis}/userId/$userId", // userId only in path
  //     page: page,
  //     pageSize: pageSize,
  //     searchQuery: searchQuery,
  //     // Remove additionalParams completely - no query parameters for userId
  //     fromJson: (json) => Swot.fromJson(json),
  //   );
  // }

  Future<void> createSwot(Swot swot) async {
    final url = ApiEndpoint().swotAnalysis;
    final Map<String, dynamic> requestData = swot.toJson();
    final response = await AuthenticatedRequest.post(
      dio,
      url,
      data: requestData,
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create swot');
    }
  }

  Future<void> deleteSwot(String swotId) async {
    final url = '${ApiEndpoint().swotAnalysis}/$swotId';
    await AuthenticatedRequest.delete(dio, url);
  }

  Future<Swot> getSwotById(String swotId) async {
    final url = '${ApiEndpoint().swotAnalysis}/$swotId';

    final response = await AuthenticatedRequest.get(dio, url);

    if (response.statusCode == 200 && response.data != null) {
      return Swot.fromJson(response.data);
    } else {
      throw Exception('Failed to fetch SWOT by ID');
    }
  }
}
