abstract class AuthRepository {
  Future<bool> login(String email, String password);
  Future<bool> logout();
  Future<bool> isLoggedIn();
  Future<String?> getCurrentUser();
}