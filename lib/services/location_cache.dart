import 'package:shared_preferences/shared_preferences.dart';

class LocationCache {
  static const _latKey = 'last_latitude';
  static const _lonKey = 'last_longitude';

  static Future<void> save(double lat, double lon) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_latKey, lat);
    await prefs.setDouble(_lonKey, lon);
  }

  static Future<(double, double)?> get() async {
    final prefs = await SharedPreferences.getInstance();

    final lat = prefs.getDouble(_latKey);
    final lon = prefs.getDouble(_lonKey);

    if (lat == null || lon == null) return null;
    return (lat, lon);
  }
}
