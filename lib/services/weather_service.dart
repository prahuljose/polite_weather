import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/air_quality_model.dart';
import '../models/weather_model.dart';

class WeatherService {
  static const String _baseUrl =
      'https://api.openweathermap.org/data/2.5/weather';

  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeatherByLocation({
    required double latitude,
    required double longitude,
  }) async {
    final uri = Uri.parse(
      '$_baseUrl?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric',
    );

    final response = await http.get(uri);
    if (kDebugMode) {
      debugPrint(response.body);
      print(latitude);
      print(longitude);
    }

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return Weather.fromJson(jsonData);
    } else {
      throw Exception(
        'Failed to load weather data (${response.statusCode})',
      );
    }
  }

  Future<AirQuality> getAirQualityByLocation({
    required double latitude,
    required double longitude,
  }) async {
    final uri = Uri.parse(
      'https://api.openweathermap.org/data/2.5/air_pollution'
          '?lat=$latitude&lon=$longitude&appid=$apiKey',
    );

    final response = await http.get(uri);

    if (kDebugMode) {
      debugPrint(response.body);
    }

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return AirQuality.fromJson(jsonData);
    } else {
      throw Exception(
        'Failed to load air quality data (${response.statusCode})',
      );
    }
  }

}
