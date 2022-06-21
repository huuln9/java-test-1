class DocItemModel {
  String vanBanID;
  String soVanBan;
  String trichYeu;
  String ngayBanHanh;
  String tenLoaiVanBan;

  DocItemModel({
    required this.vanBanID,
    required this.soVanBan,
    required this.trichYeu,
    required this.ngayBanHanh,
    required this.tenLoaiVanBan,
  });

  @override
  String toString() {
    return 'DocItemModel{' ' vanBanID: $vanBanID,' ' soVanBan: $soVanBan,' ' trichYeu: $trichYeu,' ' ngayBanHanh: $ngayBanHanh,' +
        ' tenLoaiVanBan: $tenLoaiVanBan,' +
        '}';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': vanBanID,
      'documentNo': soVanBan,
      'summary': trichYeu,
      'publishedDate': ngayBanHanh,
      'type': tenLoaiVanBan,
    };
  }

  factory DocItemModel.fromMap(Map<String, dynamic> map) {
    return DocItemModel(
      vanBanID: map['id'] ?? "",
      soVanBan: map['documentNo'] ?? "",
      trichYeu: map['summary'] ?? "",
      ngayBanHanh: map['publishedDate'] ?? "",
      tenLoaiVanBan: map['type'] ?? "",
    );
  }

  static List<DocItemModel> fromListMap(List<dynamic> maps) {
    List<DocItemModel> lst = [];
    for (var element in maps) {
      lst.add(DocItemModel.fromMap(element));
    }
    return lst;
  }

  static List<Map<String, dynamic>> toListMap(List<DocItemModel> elements) {
    List<Map<String, dynamic>> lst = [];
    for (var element in elements) {
      lst.add(element.toMap());
    }
    return lst;
  }
}