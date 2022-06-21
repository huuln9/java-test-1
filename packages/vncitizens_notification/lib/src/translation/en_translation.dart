import 'package:get/get.dart';

class EnTranslation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': {
          'thong bao': 'Notification',
          'xac nhan': 'Confirmation',
          'dong': 'Close',
          'dong y': 'Agree',
          'xoa tat ca thong bao': 'Delete all notifications',
          'xoa thong bao': 'Delete notification',
          'danh dau da doc tat ca thong bao': 'Mark all notifications as read',
          'chon tat ca': 'Select all',
          'xoa tat ca thong bao da chon': 'Delete all selected notifications',
          'danh dau da doc tat ca thong bao da chon':
              'Mark all selected notifications as read',
          'khong tim thay thong bao': 'Notification not found',
          'chon nhieu': 'Select multiple item',
          'danh dau da doc': 'Mark as read',
          'xoa tat ca': 'Delete all',
          'xoa': 'Delete',
          'chi tiet thong bao': 'Notification detail',
          'noi dung': 'Content',
          'hinh anh': 'Image',
          'loai thong bao': 'Notification type',
          'hom qua': 'Yesterday',
          'xoa thong bao thanh cong': 'Delete notification successfully',
          'xoa thong bao that bai': 'Delete notification failed',
          'dang tai chi tiet thong bao': 'Notification detail loading...',
          'dang tai danh sach thong bao': 'Notification list loading...',
          'dang thuc hien xoa thong bao': 'Notification deleting...',
          'dang thuc hien danh dau da doc thong bao': 'Notification is marking as read...'
        }
      };
}
