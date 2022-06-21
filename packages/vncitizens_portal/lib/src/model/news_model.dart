class NewsModel {
  int? id;
  String title;
  String description;
  String? thumbnail;
  String createDate;
  String? content;
  String? author;
  String? resource;
  String? resourceApi;

  NewsModel({
    this.id = 0,
    required this.title,
    required this.description,
    this.thumbnail = '',
    required this.createDate,
    this.content = '',
    this.author = '',
    this.resource = '',
    this.resourceApi = '',
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      title: json['TieuDe'] ?? '',
      description: json['GioiThieu'] ?? '',
      createDate: json['NgayDang'] ?? '',
      content: json['NoiDung'] as String,
      author: json['TacGia'] as String,
      resource: json['NguonTin'] as String,
    );
  }

  static List<NewsModel> fromArray(List<dynamic> jsonArr, String endpoint) {
    List<NewsModel> listNews = [];
    for (var json in jsonArr) {
      listNews.add(NewsModel(
        id: json['TinTucID'] as int,
        title: json['TieuDe'] ?? '',
        description: json['GioiThieu'] ?? '',
        thumbnail: json['AnhNhoUrl'] ?? '',
        createDate: json['NgayDang'] ?? '',
        resourceApi: endpoint,
      ));
    }
    return listNews;
  }
}
