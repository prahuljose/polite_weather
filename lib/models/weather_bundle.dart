import 'weather_model.dart';
import 'air_quality_model.dart';

class WeatherBundle {
  final Weather weather;
  final AirQuality airQuality;

  WeatherBundle({
    required this.weather,
    required this.airQuality,
  });
}