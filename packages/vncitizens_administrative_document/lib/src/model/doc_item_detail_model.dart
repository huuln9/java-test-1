class DocItemDetailModel {
  String tenCoQuan;
  String tenLinhVuc;
  String tenLoaiVanBan;
  String soVanBan;
  String nguoiKy;
  String trichYeu;
  String fileVanBan;
  String tenVanBan;
  String ngayBanHanh;
  String ngayHieuLuc;

  DocItemDetailModel({
    required this.tenCoQuan,
    required this.tenLinhVuc,
    required this.tenLoaiVanBan,
    required this.soVanBan,
    required this.nguoiKy,
    required this.trichYeu,
    required this.fileVanBan,
    required this.tenVanBan,
    required this.ngayBanHanh,
    required this.ngayHieuLuc,
  });

  @override
  String toString() {
    return 'DocItemDetailModel{' ' tenCoQuan: $tenCoQuan,' ' tenLinhVuc: $tenLinhVuc,' ' tenLoaiVanBan: $tenLoaiVanBan,' ' soVanBan: $soVanBan,' +
        ' nguoiKy: $nguoiKy,' +
        ' trichYeu: $trichYeu,' +
        ' fileVanBan: $fileVanBan,' +
        ' tenVanBan: $tenVanBan,' +
        ' ngayBanHanh: $ngayBanHanh,' +
        ' ngayHieuLuc: $ngayHieuLuc,' +
        '}';
  }

  Map<String, dynamic> toMap() {
    return {
      'agency': tenCoQuan,
      'sector': tenLinhVuc,
      'type': tenLoaiVanBan,
      'documentNo': soVanBan,
      'signer': nguoiKy,
      'summary': trichYeu,
      'attachment': fileVanBan,
      'title': tenVanBan,
      'publishedDate': ngayBanHanh,
      'effectiveDate': ngayHieuLuc,
    };
  }

  factory DocItemDetailModel.fromMap(Map<String, dynamic> map) {
    return DocItemDetailModel(
      tenCoQuan: map['agency'] ?? "",
      tenLinhVuc: map['sector'] ?? "",
      tenLoaiVanBan: map['type'] ?? "",
      soVanBan: map['documentNo'] ?? "",
      nguoiKy: map['signer'] ?? "",
      trichYeu: map['summary'] ?? "",
      fileVanBan: map['attachment'] ?? "",
      tenVanBan: map['title'] ?? "",
      ngayBanHanh: map['publishedDate'] ?? "",
      ngayHieuLuc: map['effectiveDate'] ?? "",
    );
  }

  static List<DocItemDetailModel> fromListMap(List<dynamic> maps) {
    List<DocItemDetailModel> lst = [];
    for (var element in maps) {
      lst.add(DocItemDetailModel.fromMap(element));
    }
    return lst;
  }

  static List<Map<String, dynamic>> toListMap(List<DocItemDetailModel> elements) {
    List<Map<String, dynamic>> lst = [];
    for (var element in elements) {
      lst.add(element.toMap());
    }
    return lst;
  }
}