class PageList<T> {
  List<T> items;
  int page;
  int pageSize;
  int totalCount;
  bool hasNextPage;
  bool hasPreviousPage;

  PageList(
    this.items,
    this.page,
    this.pageSize,
    this.totalCount,
    this.hasNextPage,
    this.hasPreviousPage,
  );

  factory PageList.fromJSON(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJSONModel,
  ) {
    final items =
        (json['items'] as List)
            .map((e) => fromJSONModel(e as Map<String, dynamic>))
            .toList();
    return PageList<T>(
      items,
      json['page'] as int,
      json['pageSize'] as int,
      json['totalCount'] as int,
      json['hasNextPage'] as bool,
      json['hasPreviousPage'] as bool,
    );
  }
}
