import 'package:vncitizens_place/src/model/place_content.dart';

class PlaceSelector {
  PlaceSelector({
    required this.data,
    required this.isSelected,
  });

  final PlaceContent data;
  bool isSelected;
}
