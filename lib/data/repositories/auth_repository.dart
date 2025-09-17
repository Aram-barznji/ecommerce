import '../../domain/repositories/auth_repository.dart';
import '../data_sources/local_preferences.dart';
import '../../core/constants.dart';

class AuthRepositoryImpl extends AuthRepository {
  final LocalPreferences _prefs = LocalPreferences.instance;
  
  @override
  Future<bool> login(String email, String password) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock authentication logic
    if (email.isNotEmpty && password.length >= 6) {
      await _prefs.setBool(AppConstants.keyIsLoggedIn, true);
      await _prefs.setString(AppConstants.keyUserName, email);
      return true;
    }
    return false;
  }
  
  @override
  Future<bool> logout() async {
    await _prefs.setBool(AppConstants.keyIsLoggedIn, false);
    await _prefs.remove(AppConstants.keyUserName);
    return true;
  }
  
  @override
  Future<bool> isLoggedIn() async {
    return _prefs.getBool(AppConstants.keyIsLoggedIn) ?? false;
  }
  
  @override
  Future<String?> getCurrentUser() async {
    return _prefs.getString(AppConstants.keyUserName);
  }
}