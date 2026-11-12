import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _lastCityKey = 'last_city';

  // Menyimpan kota terakhir
  Future<void> saveLastCity(String city) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_lastCityKey, city);
  }

  // Mengambil kota terakhir
  Future<String?> getLastCity() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(_lastCityKey);
  }
}
