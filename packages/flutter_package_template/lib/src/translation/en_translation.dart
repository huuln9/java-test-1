import 'package:get/get.dart';

class EnTranslation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': {
          'tieu de': 'Hello World %s',
          'xin chao': 'Hi',
          'toi la snackbar': "I'm modern snackbar"
        }
      };
}
