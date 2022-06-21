import 'package:flutter/material.dart';

class ColorMapModel {
  String title;
  Color color;

  ColorMapModel({
    required this.title,
    required this.color,
  });

  @override
  String toString() {
    return 'ColorMapModel{' ' title: $title,' ' color: $color,' '}';
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'color': color,
    };
  }

  factory ColorMapModel.fromMap(Map<String, dynamic> map) {
    return ColorMapModel(
      title: map['title'] as String,
      color: map['color'] as Color,
    );
  }
}