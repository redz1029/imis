class PageList<T> {
  List<T> items;
  int page;
  int pageSize;
  int totalCount;
  int totalPages;

  PageList(
    this.items,
    this.page,
    this.pageSize,
    this.totalCount,
    this.totalPages,
  );

  factory PageList.fromJSON(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJSONModel,
  ) {
    dynamic rawData;

    if (json['data'] is List) {
      rawData = json['data'];
    } else if (json['items'] is List) {
      rawData = json['items'];
    } else if (json['result'] is List) {
      rawData = json['result'];
    } else {
      rawData = <dynamic>[];
    }

    final items =
        (rawData as List)
            .map((e) => fromJSONModel(e as Map<String, dynamic>))
            .toList();

    return PageList<T>(
      items,
      json['page'] ?? 1,
      json['pageSize'] ?? 15,
      json['totalCount'] ?? 0,
      json['totalPages'] ?? 0,
    );
  }
}
