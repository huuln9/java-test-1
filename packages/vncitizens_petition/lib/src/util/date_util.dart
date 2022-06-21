import 'package:vncitizens_common/vncitizens_common.dart';

class DateTimeConst {
  static DateTime get nullDate => DateTime(1900);
  // ignore: constant_identifier_names
  static const String DATE_TIME_FORMAT = 'yyyy-MM-ddTHH:mm:ss';
  // ignore: constant_identifier_names
  static const String DATE_FORMAT = 'dd/MM/yyyy';
  // ignore: constant_identifier_names
  static const String DATE_2_FORMAT = 'yyyy-MM-dd';
  // ignore: constant_identifier_names
  static const String U_MINUTE_FORMAT = 'dd/MM/yyyy HH:mm';
  // ignore: constant_identifier_names
  static const String U_MINUTE2_FORMAT = 'HH:mm dd/MM/yyyy ';
  // ignore: constant_identifier_names
  static const String U_MINUTE3_FORMAT = 'HH:mm EEEE, dd/MM/yyyy ';

  // ignore: constant_identifier_names
  static const String U_SECOND_FORMAT = 'dd/MM/yyyy HH:mm:ss';
  // ignore: constant_identifier_names
  static const String TIME_FORMAT = 'HH:mm';
  // ignore: constant_identifier_names
  static const String DATE_TIME_REQUEST_FORMAT = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
}

class DateTimeUtils {
  static var nullDate = DateTimeConst.nullDate;

  static String formatDate(Object? dateTime) {
    if (dateTime == null) {
      return '';
    }
    String time;
    if (dateTime is String) {
      if (dateTime.toString().trim() == '') {
        time = '';
      } else {
        time = dateTime.toString();
        final date = DateFormat(DateTimeConst.DATE_TIME_FORMAT).parse(time);
        time = DateFormat(DateTimeConst.DATE_FORMAT).format(date);
      }
    } else {
      time = DateFormat(DateTimeConst.DATE_FORMAT).format(dateTime as DateTime);
    }
    return time;
  }

  static String formatDateTime(Object? dateTime) {
    if (dateTime == null) {
      return '';
    }
    String time;
    if (dateTime is String) {
      if (dateTime.toString().trim() == '') {
        time = '';
      } else {
        time = dateTime.toString();
        final date = DateFormat(DateTimeConst.DATE_TIME_FORMAT).parse(time);
        time = DateFormat(DateTimeConst.U_MINUTE_FORMAT).format(date);
      }
    } else {
      time = DateFormat(DateTimeConst.U_MINUTE_FORMAT)
          .format(dateTime as DateTime);
    }
    return time;
  }

  static String formatDateTimeV2(Object? dateTime) {
    if (dateTime == null) {
      return '';
    }
    String time;
    if (dateTime is String) {
      if (dateTime.toString().trim() == '') {
        time = '';
      } else {
        time = dateTime.toString();
        final date = DateFormat(DateTimeConst.DATE_TIME_FORMAT).parse(time);
        time = DateFormat(DateTimeConst.U_MINUTE2_FORMAT).format(date);
      }
    } else {
      time = DateFormat(DateTimeConst.U_MINUTE2_FORMAT)
          .format(dateTime as DateTime);
    }
    return time;
  }

  static String formatDateTimeV4(Object? dateTime) {
    if (dateTime == null) {
      return '';
    }
    String time;
    if (dateTime is String) {
      if (dateTime.toString().trim() == '') {
        time = '';
      } else {
        time = dateTime.toString();
        final date = DateFormat(DateTimeConst.DATE_TIME_FORMAT).parse(time);
        time = DateFormat(DateTimeConst.U_MINUTE3_FORMAT).format(date);
      }
    } else {
      time = DateFormat(DateTimeConst.U_MINUTE3_FORMAT)
          .format(dateTime as DateTime);
    }
    return time;
  }

  static String formatTime(Object? dateTime) {
    if (dateTime == null) {
      return '';
    }
    String time;
    if (dateTime is String) {
      if (dateTime.toString().trim() == '') {
        time = '';
      } else {
        time = dateTime.toString();
        final date = DateFormat(DateTimeConst.DATE_TIME_FORMAT).parse(time);
        time = DateFormat(DateTimeConst.TIME_FORMAT).format(date);
      }
    } else {
      time = DateFormat(DateTimeConst.TIME_FORMAT).format(dateTime as DateTime);
    }
    return time;
  }

  static String formatDateV2(Object? dateTime) {
    if (dateTime == null) {
      return '';
    }
    String time;
    if (dateTime is String) {
      if (dateTime.toString().trim() == '') {
        time = '';
      } else {
        time = dateTime.toString();
        final date = DateFormat(DateTimeConst.DATE_TIME_FORMAT).parse(time);
        time = DateFormat(DateTimeConst.DATE_2_FORMAT).format(date);
      }
    } else {
      time =
          DateFormat(DateTimeConst.DATE_2_FORMAT).format(dateTime as DateTime);
    }
    return time;
  }

  static String formatDateRequestApi(Object? dateTime) {
    if (dateTime == null) {
      return '';
    }
    String time;
    if (dateTime is String) {
      if (dateTime.toString().trim() == '') {
        time = '';
      } else {
        time = dateTime.toString();
        final date = DateFormat(DateTimeConst.DATE_TIME_FORMAT).parse(time);
        time = DateFormat(DateTimeConst.DATE_TIME_REQUEST_FORMAT).format(date);
      }
    } else {
      time = DateFormat(DateTimeConst.DATE_TIME_REQUEST_FORMAT)
          .format(dateTime as DateTime);
    }
    return time;
  }
}
