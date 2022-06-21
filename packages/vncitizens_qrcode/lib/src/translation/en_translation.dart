import 'package:get/get.dart';

class EnTranslation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': {
          'quet ma qr': 'Scan QR code',
          'di chuyen camera den vung chua ma qr de quet':
              'Move the Camera to the area containing the QR code to scan',
          'quet anh co san': 'Scan photos available',
          'van ban': 'Document',
          'dong': 'Close',
          'mo': 'Open',
          'dong y': 'Agree',
          'sao chep': 'Copy',
          'trang web': 'Website',
          'tin nhan': 'Message',
          'so dien thoai': 'Phone number',
          'thong bao': 'Notify',
          'nhan tin cho': 'Send message to @recipent',
          'goi den so': 'Call the number @phone',
          'gui mail toi': 'Send email to @email',
          'ket noi toi wifi': 'Connect to wifi @wifi',
          'khong tim thay ma qr': 'QR code not found',
        },
      };
}
