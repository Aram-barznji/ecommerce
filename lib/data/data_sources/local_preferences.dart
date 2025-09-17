import 'package:shared_preferences/shared_preferences.dart';

class LocalPreferences {
  static final LocalPreferences _instance = LocalPreferences._internal();
  factory LocalPreferences() => _instance;
  LocalPreferences._internal();
  
  static LocalPreferences get instance => _instance;
  
  SharedPreferences? _prefs;
  
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }
  
  Future<bool> setBool(String key, bool value) async {
    await init();
    return await _prefs!.setBool(key, value);
  }
  
  bool? getBool(String key) {
    return _prefs?.getBool(key);
  }
  
  Future<bool> setString(String key, String value) async {
    await init();
    return await _prefs!.setString(key, value);
  }
  
  String? getString(String key) {
    return _prefs?.getString(key);
  }
  
  Future<bool> remove(String key) async {
    await init();
    return await _prefs!.remove(key);
  }
  
  Future<bool> clear() async {
    await init();
    return await _prefs!.clear();
  }
}