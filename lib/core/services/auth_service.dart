import '../di/injector.dart';
import '../services/storage_service.dart';

class AuthService {
  static const String _keyRegisteredEmail = 'registered_email';
  static const String _keyRegisteredPassword = 'registered_password';
  static const String _keyCurrentEmail = 'current_email';
  static const String _keyCurrentName = 'current_name';
  static const String _keyIsLoggedIn = 'is_logged_in';

  static bool isLoggedIn = false;
  static String? currentEmail;
  static String? currentName;

  static Future<void> init() async {
    final storage = getIt<StorageService>();
    isLoggedIn = await storage.getBool(_keyIsLoggedIn) ?? false;
    currentEmail = await storage.getString(_keyCurrentEmail);
    currentName = await storage.getString(_keyCurrentName);
  }

  static Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final storage = getIt<StorageService>();
    await storage.setString(_keyRegisteredEmail, email);
    await storage.setString(_keyRegisteredPassword, password);
    await storage.setString(_keyCurrentEmail, email);
    await storage.setString(_keyCurrentName, name);
    await storage.setBool(_keyIsLoggedIn, true);

    isLoggedIn = true;
    currentEmail = email;
    currentName = name;
    return true;
  }

  static Future<bool> login(String email, String password) async {
    final storage = getIt<StorageService>();
    final registeredEmail = await storage.getString(_keyRegisteredEmail);
    final registeredPassword = await storage.getString(_keyRegisteredPassword);

    if (registeredEmail == null || registeredPassword == null) {
      return false;
    }

    if (registeredEmail == email && registeredPassword == password) {
      await storage.setBool(_keyIsLoggedIn, true);
      await storage.setString(_keyCurrentEmail, email);
      currentName = await storage.getString(_keyCurrentName);
      currentEmail = email;
      isLoggedIn = true;
      return true;
    }

    return false;
  }

  static Future<String?> getSavedEmail() async {
    final storage = getIt<StorageService>();
    return storage.getString(_keyCurrentEmail);
  }

  static Future<void> logout() async {
    final storage = getIt<StorageService>();
    await storage.setBool(_keyIsLoggedIn, false);
    await storage.remove(_keyCurrentEmail);
    isLoggedIn = false;
    currentEmail = null;
    currentName = null;
  }
}
