class LabelIsochroneInput {
  String? polygon1;
  String? polygon2;
  String? type;

  LabelIsochroneInput({
    this.polygon1,
    this.polygon2,
    this.type,
  });

  LabelIsochroneInput.fromJson(Map<String, dynamic> json) {
    polygon1 = json['polygon1'];
    polygon2 = json['polygon2'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['polygon1'] = this.polygon1;
    data['polygon2'] = this.polygon2;
    data['type'] = this.type;
    return data;
  }
}
