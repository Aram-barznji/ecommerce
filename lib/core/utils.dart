import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  // Simple filter for search
  static List<T> filterList<T>(
      List<T> list, String query, String Function(T) getSearchValue) {
    if (query.isEmpty) return list;
    return list
        .where((item) => getSearchValue(item).toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // Calculate cart total
  static double calculateCartTotal(List<Map<String, dynamic>> cart) {
    return cart.fold(0.0, (total, item) => total + (item['price'] * item['quantity']));
  }

  // SharedPreferences instance for simplicity (inject in repos for better architecture)
  static Future<SharedPreferences> getPrefs() async {
    return await SharedPreferences.getInstance();
  }
}