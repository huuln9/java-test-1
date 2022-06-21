class PetitionCreateRemoteConfigModel {
  final bool? titleActive;
  final bool? categoryActive;
  final int? descriptionMaxLength;
  final TakePlaceAtConfig? takePlaceAt;
  final FileConfig? file;
  final PublicConfig? anonymous;
  final PublicConfig? public;
  final String? thumbnailIdDefault;
  final String? provincesTypeId;
  final String? districtsTypeId;
  final String? wardsTypeId;

  PetitionCreateRemoteConfigModel(
      {this.titleActive,
      this.categoryActive,
      this.descriptionMaxLength,
      this.takePlaceAt,
      this.file,
      this.anonymous,
      this.public,
      this.thumbnailIdDefault,
      this.provincesTypeId,
      this.districtsTypeId,
      this.wardsTypeId});
  factory PetitionCreateRemoteConfigModel.fromJson(Map<String, dynamic> json) {
    return PetitionCreateRemoteConfigModel(
        titleActive: json['titleActive'],
        categoryActive: json['categoryActive'],
        descriptionMaxLength: json['descriptionMaxLength'],
        takePlaceAt: json['takePlaceAt'] != null
            ? TakePlaceAtConfig.fromJson(json['takePlaceAt'])
            : null,
        file: json['file'] != null ? FileConfig.fromJson(json['file']) : null,
        anonymous: json['anonymous'] != null
            ? PublicConfig.fromJson(json['anonymous'])
            : null,
        public: json['public'] != null
            ? PublicConfig.fromJson(json['public'])
            : null,
        thumbnailIdDefault: json['thumbnailIdDefault'],
        provincesTypeId: json['provincesTypeId'],
        districtsTypeId: json['districtsTypeId'],
        wardsTypeId: json['wardsTypeId']);
  }
}

class TakePlaceAtConfig {
  final bool? districtActive;
  final String? provincesIdDefault;
  final String? provincesNameDefault;
  final bool? wardsActive;
  final double? latitude;
  final double? longtude;

  TakePlaceAtConfig(
      {this.districtActive,
      this.provincesIdDefault,
      this.provincesNameDefault,
      this.wardsActive,
      this.latitude,
      this.longtude});
  factory TakePlaceAtConfig.fromJson(Map<String, dynamic> json) {
    return TakePlaceAtConfig(
        districtActive: json['districtActive'],
        provincesIdDefault: json['provincesIdDefault'],
        provincesNameDefault: json['provincesNameDefault'],
        wardsActive: json['wardsActive'],
        latitude: json['latitude'],
        longtude: json['longtude']);
  }
}

class FileConfig {
  final bool? required;
  final int? maxLength;
  final int? maxSize;
  final List<String>? extensions;

  FileConfig({this.required, this.maxLength, this.maxSize, this.extensions});
  factory FileConfig.fromJson(Map<String, dynamic> json) {
    return FileConfig(
        required: json['required'],
        maxLength: json['maxLength'],
        maxSize: json['maxSize'],
        extensions: (json['extensions'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList());
  }
}

class PublicConfig {
  final bool? active;
  final bool? value;

  PublicConfig({this.active, this.value});
  factory PublicConfig.fromJson(Map<String, dynamic> json) {
    return PublicConfig(active: json['active'], value: json['value']);
  }
}
