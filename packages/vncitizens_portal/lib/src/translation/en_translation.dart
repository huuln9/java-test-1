import 'package:get/get.dart';

class EnTranslation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': {
          'tin tuc': 'News',
          'tim kiem': 'Search',
          'nguon tin': 'Source',
          'chuyen muc': 'Category',
          'bo chon tat ca': 'Deselect all',
          'xem ket qua': 'See result',
          'xoa bo loc': 'Clear filter',
        },
      };
}
