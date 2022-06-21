import 'dart:math';

class LunarCalendarConverter {
  static int _floor(double value) {
    return value.floor();
  }

  static int _jdFromDate(int dd, int mm, int yy) {
    dynamic a, y, m;
    int jd;
    a = _floor((14 - mm) / 12);
    y = yy + 4800 - a;
    m = mm + 12 * a - 3;
    jd = (dd + _floor((153 * m + 2) / 5) + 365 * y + _floor(y / 4) - _floor(y / 100) + _floor(y / 400) - 32045) as int;
    if (jd < 2299161) {
      jd = (dd + _floor((153 * m + 2) / 5) + 365 * y + _floor(y / 4) - 32083) as int;
    }
    return jd;
  }

  static int _getNewMoonDay(int k, int timeZone) {
    dynamic T, T2, T3, dr, Jd1, M, Mpr, F, C1, deltat, JdNew;
    T = k / 1236.85; // Time in Julian centuries from 1900 January 0.5
    T2 = T * T;
    T3 = T2 * T;
    dr = pi / 180;
    Jd1 = 2415020.75933 + 29.53058868 * k + 0.0001178 * T2 - 0.000000155 * T3;
    Jd1 = Jd1 + 0.00033 * sin((166.56 + 132.87 * T - 0.009173 * T2) * dr); // Mean new moon
    M = 359.2242 + 29.10535608 * k - 0.0000333 * T2 - 0.00000347 * T3; // Sun's mean anomaly
    Mpr = 306.0253 + 385.81691806 * k + 0.0107306 * T2 + 0.00001236 * T3; // Moon's mean anomaly
    F = 21.2964 + 390.67050646 * k - 0.0016528 * T2 - 0.00000239 * T3; // Moon's argument of latitude
    C1 = (0.1734 - 0.000393 * T) * sin(M * dr) + 0.0021 * sin(2 * dr * M);
    C1 = C1 - 0.4068 * sin(Mpr * dr) + 0.0161 * sin(dr * 2 * Mpr);
    C1 = C1 - 0.0004 * sin(dr * 3 * Mpr);
    C1 = C1 + 0.0104 * sin(dr * 2 * F) - 0.0051 * sin(dr * (M + Mpr));
    C1 = C1 - 0.0074 * sin(dr * (M - Mpr)) + 0.0004 * sin(dr * (2 * F + M));
    C1 = C1 - 0.0004 * sin(dr * (2 * F - M)) - 0.0006 * sin(dr * (2 * F + Mpr));
    C1 = C1 + 0.0010 * sin(dr * (2 * F - Mpr)) + 0.0005 * sin(dr * (2 * Mpr + M));
    if (T < -11) {
      deltat = 0.001 + 0.000839 * T + 0.0002261 * T2 - 0.00000845 * T3 - 0.000000081 * T * T3;
    } else {
      deltat = -0.000278 + 0.000265 * T + 0.000262 * T2;
    }
    JdNew = Jd1 + C1 - deltat;
    return _floor(JdNew + 0.5 + timeZone / 24);
  }

  static int _getLunarMonth11(int yy, int timeZone) {
    dynamic k, off, nm, sunLong;
    off = _jdFromDate(31, 12, yy) - 2415021;
    k = _floor(off / 29.530588853);
    nm = _getNewMoonDay(k, timeZone);
    sunLong = _getSunLongitude(nm, timeZone); // sun longitude at local midnight
    if (sunLong >= 9) {
      nm = _getNewMoonDay(k - 1, timeZone);
    }
    return nm;
  }

  static int _getSunLongitude(jdn, timeZone) {
    dynamic T, T2, dr, M, L0, DL, L;
    T = (jdn - 2451545.5 - timeZone / 24) / 36525; // Time in Julian centuries from 2000-01-01 12:00:00 GMT
    T2 = T * T;
    dr = pi / 180; // degree to radian
    M = 357.52910 + 35999.05030 * T - 0.0001559 * T2 - 0.00000048 * T * T2; // mean anomaly, degree
    L0 = 280.46645 + 36000.76983 * T + 0.0003032 * T2; // mean longitude, degree
    DL = (1.914600 - 0.004817 * T - 0.000014 * T2) * sin(dr * M);
    DL = DL + (0.019993 - 0.000101 * T) * sin(dr * 2 * M) + 0.000290 * sin(dr * 3 * M);
    L = L0 + DL; // true longitude, degree
    L = L * dr;
    L = L - pi * 2 * (_floor(L / (pi * 2))); // Normalize to (0, 2*PI)
    return _floor(L / pi * 6);
  }

  static int _getLeapMonthOffset(int a11, int timeZone) {
    dynamic k, last, arc, i;
    k = _floor((a11 - 2415021.076998695) / 29.530588853 + 0.5);
    last = 0;
    i = 1; // We start with the month following lunar month 11
    arc = _getSunLongitude(_getNewMoonDay(k + i, timeZone), timeZone);
    do {
      last = arc;
      i++;
      arc = _getSunLongitude(_getNewMoonDay(k + i, timeZone), timeZone);
    } while (arc != last && i < 14);
    return i - 1;
  }

  static solarToLunar(int solarYear, int solarMonth, int solarDay) {
    List<int> result = List.filled(3, 1, growable: false);
    var utcValue = 7;
    var k, dayNumber, monthStart, a11, b11;
    int lunarDay, lunarMonth, lunarYear;

    dayNumber = _jdFromDate(solarDay, solarMonth, solarYear);
    k = _floor((dayNumber - 2415021.076998695) / 29.530588853);
    monthStart = _getNewMoonDay(k + 1, utcValue);
    if (monthStart > dayNumber) {
      monthStart = _getNewMoonDay(k, utcValue);
    }
    a11 = _getLunarMonth11(solarYear, utcValue);
    b11 = a11;
    if (a11 >= monthStart) {
      lunarYear = solarYear;
      a11 = _getLunarMonth11(solarYear - 1, utcValue);
    } else {
      lunarYear = solarYear + 1;
      b11 = _getLunarMonth11(solarYear + 1, utcValue);
    }
    lunarDay = dayNumber - monthStart + 1;
    var diff = _floor((monthStart - a11) / 29);
    lunarMonth = diff + 11;
    if (b11 - a11 > 365) {
      var leapMonthDiff = _getLeapMonthOffset(a11, utcValue);
      if (diff >= leapMonthDiff) {
        lunarMonth = diff + 10;
        if (diff == leapMonthDiff) {
        }
      }
    }
    if (lunarMonth > 12) {
      lunarMonth = lunarMonth - 12;
    }
    if (lunarMonth >= 11 && diff < 4) {
      lunarYear -= 1;
    }

    result[0] = lunarDay;
    result[1] = lunarMonth;
    result[2] = lunarYear;

    return result;
  }
}