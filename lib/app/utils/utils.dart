import 'package:intl/intl.dart';

class Utils {
  String dateCustomFormat(String value) {
    try {
      DateTime date = DateTime.parse(value);
      DateTime dateNow = DateTime.now();
      double diffDate =
          (dateNow.millisecondsSinceEpoch - date.millisecondsSinceEpoch) / 1000;

      if (diffDate < 60) return 'baru saja';

      /// same day
      if (diffDate < 60 * 60 * 24 && date.day == dateNow.day) {
        return DateFormat.Hm().format(date);
      }

      /// yesterday
      if (diffDate < 60 * 60 * 24 * 2 && dateNow.day - date.day == 1) {
        return 'kemarin ${DateFormat.Hm().format(date)}';
      }

      return DateFormat('d/M/y').format(date);
    } catch (e) {
      return '';
    }
  }
}
