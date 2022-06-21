import 'package:get/get.dart';

class EnTranslation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': {
          'danh ba khan cap': "Emergency contact",
          'danh ba': "Contact",
          'khong tim thay danh ba': "Found nothing",
          'tu khoa': 'Keyword',
          "tai them du lieu that bai": "Failed to load more"
        },
      };
}
