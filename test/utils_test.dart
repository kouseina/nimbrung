import 'package:chat_app/app/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:test/test.dart';

void main() {
  group("Date Custom Format", () {
    test('value should be just now', () {
      String date = DateTime.now()
          .subtract(const Duration(seconds: 40))
          .toIso8601String();

      String dateFormatted = Utils().dateCustomFormat(date);

      expect(dateFormatted, 'baru saja');
    });

    test("value should be 00:00", () {
      DateTime date = DateTime.now().subtract(const Duration(minutes: 5));

      String dateFormatted = Utils().dateCustomFormat(date.toIso8601String());

      expect(dateFormatted, DateFormat.Hm().format(date));
    });

    test("value should be yesterday 00:00", () {
      DateTime date = DateTime.now().subtract(const Duration(hours: 12));

      String dateFormatted = Utils().dateCustomFormat(date.toIso8601String());

      expect(dateFormatted, 'kemarin ${DateFormat.Hm().format(date)}');
    });

    test("value should be d/m/y", () {
      DateTime date = DateTime.now().subtract(const Duration(hours: 30));

      String dateFormatted = Utils().dateCustomFormat(date.toIso8601String());

      expect(dateFormatted, DateFormat('d/M/y').format(date));
    });
  });
}
