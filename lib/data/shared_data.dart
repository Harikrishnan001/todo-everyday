import 'package:shared_preferences/shared_preferences.dart';

class SharedData {
  static SharedPreferences _sp;
  final String nameKey = 'name';
  static SharedData _sd = SharedData._internal();

  SharedData._internal();
  factory SharedData() {
    return _sd;
  }

  Future<void> init() async {
    _sp = await SharedPreferences.getInstance();
    if (_sp.getString(nameKey) == null) {
      await _sp.setString(nameKey, "User");
    }
  }

  Future<void> setName(String name) async {
    await _sp.setString(nameKey, name);
  }

  String getName() {
    return _sp.getString(nameKey);
  }
}
