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

  factory PageList.fromJSON(Map<String, dynamic> json, Function fromJSONModel) {
    List<dynamic> items = json['items'].cast<Map<String, dynamic>>();
    return PageList(
      List<T>.from(items.map((e) => fromJSONModel(e))),
      json['page'],
      json['pageSize'],
      json['totalCount'],
      json['hasNextPage'],
      json['hasPreviousPage'],
    );
  }
}
