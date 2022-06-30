import 'package:timezone/standalone.dart' as tz;

class TimeZoneHelper {
  static final locationName = tz.getLocation('Asia/Ho_Chi_Minh');

  static DateTime convert(DateTime dateTime) {
    DateTime local = tz.TZDateTime.local(
        dateTime.year,
        dateTime.month,
        dateTime.day,
        dateTime.hour + 7,
        dateTime.minute,
        dateTime.second,
        dateTime.millisecond);
    return tz.TZDateTime.from(local, locationName);
  }
}
