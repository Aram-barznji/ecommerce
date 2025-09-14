import 'package:shared_preferences/shared_preferences.dart';

class LocalPreferences {
  final SharedPreferences _prefs;

  LocalPreferences(this._prefs);

  static Future<LocalPreferences> init() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalPreferences(prefs);
  }

  Future<void> setFavorites(List<int> favorites) async {
    await _prefs.setStringList('favorites', favorites.map((e) => e.toString()).toList());
  }

  List<int> getFavorites() {
    final list = _prefs.getStringList('favorites') ?? [];
    return list.map((e) => int.parse(e)).toList();
  }
}