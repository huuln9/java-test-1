class AppInfoModel {
  String version;
  bool updateRequired;

  AppInfoModel({
    required this.version,
    required this.updateRequired,
  });

  @override
  String toString() {
    return 'AppInfoModel{version: $version, updateRequired: $updateRequired}';
  }

  Map<String, dynamic> toMap() {
    return {
      'version': version,
      'updateRequired': updateRequired,
    };
  }

  factory AppInfoModel.fromMap(Map<String, dynamic> map) {
    return AppInfoModel(
      version: map['version'] as String,
      updateRequired: map['updateRequired'] as bool,
    );
  }
}