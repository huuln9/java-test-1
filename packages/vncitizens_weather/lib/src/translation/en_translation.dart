import 'package:get/get.dart';

class EnTranslation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': {
          'du bao thoi tiet': 'Weather forecast',
          'dang tai thoi tiet': 'Loading weather',
        }
      };
}
