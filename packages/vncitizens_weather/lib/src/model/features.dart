class FeaturesModel {
  String? feaTime;
  String? feaIcon;
  String? feaTemperature;
  String? feaMinTemperature;
  String? feaMaxTemperature;
  String? feaHumidity;
  String? feaWinSpeed;

  FeaturesModel({
    this.feaTime,
    this.feaIcon,
    this.feaTemperature,
    this.feaMinTemperature,
    this.feaMaxTemperature,
    this.feaHumidity,
    this.feaWinSpeed,
  });
  factory FeaturesModel.fromMap(Map<String, dynamic> map) {
    return FeaturesModel(
        feaTime: map['date'].toString(),
        feaIcon: map['weathers'][0]["icon"].toString(),
        feaTemperature: map['main']["temperature"]["value"].toString(),
        feaMinTemperature: map['main']["minTemperature"]["value"].toString(),
        feaMaxTemperature: map['main']["maxTemperature"]["value"].toString(),
        feaHumidity: map['main']["humidity"]["value"].toString(),
        feaWinSpeed: map['wind']["speed"]["value"].toString(),
    );
  }
}