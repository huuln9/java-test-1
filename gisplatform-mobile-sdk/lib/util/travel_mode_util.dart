import 'package:flutter_vnpt_map/model/request_enums.dart';
import 'package:flutter_vnpt_map/util/enum/enum_to_string.dart';

class TravelModeUtil {
  static List<String> getTravelModeStringList() {
    return EnumToString.toList(TravelMode.values);
  }

  static String getTravelModeStringItem(TravelMode mode,
      {bool isLowerCase = true}) {
    String s = EnumToString.convertToString(mode);
    if (isLowerCase) return s.toLowerCase();
    return s;
  }

  static TravelMode? getTravelModeFromString(String item) {
    return EnumToString.fromString(
      TravelMode.values,
      item,
    );
  }
}
