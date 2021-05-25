

class TimeElapsed {
  static String fromDateStr(strTime) {
    /// if time is greater than a week {first checks > writtn on memo}
    final diffDays =
        DateTime.parse(strTime).difference(DateTime.now().toUtc()).inDays;

    if (diffDays <= -7) {
      final week = (diffDays ~/ -7).toInt();

      /// calcs Week
      return week.toString().replaceAll('-', '') + ' hafta önce';
    } else if (diffDays <= -1 && diffDays > -7) {
      /// return days > still same increment on memo
      return diffDays.toString().replaceAll('-', '') + ' gün önce';
    } else {
      final diffHours =
          DateTime.parse(strTime).difference(DateTime.now().toUtc()).inHours;

      /// if not {third checks > 2° writtn on memo}
      if (diffHours <= -1) {
        return diffHours.toString().replaceAll('-', '') + ' saat önce';
      } else {
        /// if not {last checks > last writtn on memo}
        final diffMin = DateTime.parse(strTime)
            .difference(DateTime.now().toUtc())
            .inMinutes;
        if (diffMin <= -1) {
          return diffMin.toString().replaceAll('-', '') + ' dakika önce';
        } else {
          return ' şimdi';
        }
      }
    }
  }

  static String fromDateTime(DateTime time,{bool short=false}) {
    /// if time is greater than a week {first checks > writtn on memo}
    final diffDays = time.difference(DateTime.now().toUtc()).inDays;

    if (diffDays <= -7) {
      final week = (diffDays ~/ -7).toInt();

      /// calcs Week
      return week.toString().replaceAll('-', '') + (short ? " h" : ' hafta önce');
    } else if (diffDays <= -1 && diffDays > -7) {
      /// return days > still same increment on memo
      return diffDays.toString().replaceAll('-', '') + (short ? " g" : ' gün önce');
    } else {
      final diffHours = time.difference(DateTime.now().toUtc()).inHours;

      /// if not {third checks > 2° writtn on memo}
      if (diffHours <= -1) {
        return diffHours.toString().replaceAll('-', '') + (short ? " s" : ' saat önce');
      } else {
        /// if not {last checks > last writtn on memo}
        final diffMin = time.difference(DateTime.now().toUtc()).inMinutes;
        if (diffMin <= -1) {
          return diffMin.toString().replaceAll('-', '') + (short ? " d" : ' dakika önce');
        } else {
          return 'şimdi';
        }
      }
    }
  }

  /// Method to parse data even if it is String or DateTime
  /// TimeElapsed().elapsedTimeDynamic(yourDate);
  String elapsedTimeDynamic(date) {
    if (date.runtimeType == DateTime) {
      return fromDateTime(date);
    } else {
      return fromDateStr(date);
    }
  }
}