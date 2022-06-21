import 'package:flutter/material.dart';
import 'package:vncitizens_administrative_document/src/model/color_map_model.dart';

class ColorMapConfig {
  static const Map<String, Color> _colorMap = {
    "NQ": Color(0xFFEB5757),
    "QĐ": Color(0xFF0042FF),
    "CT": Color(0xFFFFD964),
    "QC": Color(0xFF27AE60),
    "QĐ1": Color(0xFFF2C94C),
    "TB": Color(0xFFBB6BD9),
    "TC": Color(0xFFFF34B3),
    "HD": Color(0xFF9B51E0),
    "CTr": Color(0xFF56CCF2),
    "KH": Color(0xFF2D9CDB),
    "PA": Color(0xFF2F80ED),
    "ĐA": Color(0xFF219653),
    "DA": Color(0xFFFFB5C5),
    "BC": Color(0xFFF2994A),
    "BB": Color(0xFF97FFFF),
    "TTr": Color(0xFF79CDCD),
    "HĐ": Color(0xFF8470FF),
    "CV": Color(0xFF483D8B),
    "CĐ": Color(0xFF6FCF97),
    "BGN": Color(0xFFB0E0E6),
    "BTT": Color(0xFF87CEEB),
    "GUQ": Color(0xFF48D1CC),
    "GM": Color(0xFF54FF9F),
    "GGT": Color(0xFFDDA0DD),
    "GNP": Color(0xFF8B668B),
    "PG": Color(0xFFC71585),
    "PC": Color(0xFF880000),
    "PB": Color(0xFF9370DB),
    "TCO": Color(0xFFD8BFD8),
    "TT": Color(0xFF20117D),
    "K": Color(0xFFFF1493),
    "?": Color(0xFF999999),
  };

  static ColorMapModel getColor({required String text}) {
    final String cleanText = text.toLowerCase().trim();
    switch (cleanText) {
      case "quyết định":
        return ColorMapModel(title: "QĐ", color: _colorMap["QĐ"]!);
      case "quy định":
        return ColorMapModel(title: "QĐ", color: _colorMap["QĐ1"]!);
      case "chương trình":
        return ColorMapModel(title: "CTr", color: _colorMap["CTr"]!);
      case "tờ trình":
        return ColorMapModel(title: "TTr", color: _colorMap["CTr"]!);
      case "không xác định":
        return ColorMapModel(title: "?", color: _colorMap["?"]!);
      default:
        final List<String> split = cleanText.toUpperCase().split(" ");
        split.removeWhere((element) => element.isEmpty);
        if (split.isNotEmpty) {
          final String shorted = split.map((e) => e[0]).toList().join();
          if (_colorMap[shorted] != null) {
            return ColorMapModel(title: shorted, color: _colorMap[shorted]!);
          }
        }
        return ColorMapModel(title: "?", color: _colorMap["?"]!);
    }
  }
}