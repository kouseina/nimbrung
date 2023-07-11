import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static late SharedPreferences _sharedPrefs;

  factory SharedPrefs() => _instance;

  static final SharedPrefs _instance = SharedPrefs._internal();

  SharedPrefs._internal();

  Future<void> init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
  }

  void clear() {
    _sharedPrefs.clear();
  }

  bool? get isSkipIntro => _sharedPrefs.getBool(_keyIsSkipIntro);

  set isSkipIntro(bool? value) {
    _sharedPrefs.setBool(_keyIsSkipIntro, value ?? false);
  }

  bool? get isDark => _sharedPrefs.getBool(_keyIsDark);

  set isDark(bool? value) {
    _sharedPrefs.setBool(_keyIsDark, value ?? false);
  }
}

const String _keyIsDark = "isDark";
const String _keyIsSkipIntro = "isSkipIntro";
