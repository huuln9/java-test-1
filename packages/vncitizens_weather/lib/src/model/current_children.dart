class CurrentChildrenModel {
  String? timeChildren;
  String? iconChildren;
  String? temperatureChildren;

  CurrentChildrenModel({
    this.timeChildren,
    this.iconChildren,
    this.temperatureChildren,
  });
  factory CurrentChildrenModel.fromMap(Map<String, dynamic> map) {
    return CurrentChildrenModel(
        timeChildren: map['date'].toString(),
        iconChildren: map['weathers'][0]["icon"].toString(),
        temperatureChildren: map['main']["temperature"]["value"].toString()
    );
  }
}