import 'package:imis/utils/pagination_util.dart';

class FilterSearchResultUtil<T> {
  final PaginationUtil paginationUtils;
  final String endpoint;
  final int pageSize;
  final T Function(Map<String, dynamic>) fromJson;

  List<T> _allItems = [];
  bool _hasFetchedAll = false;

  FilterSearchResultUtil({
    required this.paginationUtils,
    required this.endpoint,
    required this.pageSize,
    required this.fromJson,
  });

  Future<List<T>> fetchAllItems() async {
    if (_hasFetchedAll) return _allItems;

    List<T> items = [];
    int currentPage = 1;
    bool hasMore = true;

    while (hasMore) {
      final pageList = await paginationUtils.fetchPaginatedData<T>(
        endpoint: endpoint,
        page: currentPage,
        pageSize: pageSize,
        fromJson: fromJson,
      );

      items.addAll(pageList.items);
      currentPage++;
      hasMore = items.length < pageList.totalCount;
    }

    _allItems = items;
    _hasFetchedAll = true;
    return _allItems;
  }

  void clearCache() {
    _allItems.clear();
    _hasFetchedAll = false;
  }

  Future<List<T>> filter(String query, bool Function(T, String) matchFn) async {
    final allItems = await fetchAllItems();

    if (query.isEmpty) return List.from(allItems);

    return allItems.where((item) => matchFn(item, query)).toList();
  }
}
