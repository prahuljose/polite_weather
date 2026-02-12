import 'package:flutter/material.dart';


class Weather {
  // Location
  final double? latitude;
  final double? longitude;

  // City / meta
  final String? cityName;
  final String? country;
  final int? timezone;
  final int? cityId;

  // Weather (first item)
  final int? weatherId;
  final String? mainCondition;
  final String? description;
  final String? icon;

  // Temperature & atmosphere
  final double? temp;
  final double? feelsLike;
  final double? tempMin;
  final double? tempMax;
  final int? pressure;
  final int? humidity;
  final int? seaLevel;
  final int? groundLevel;

  // Wind
  final double? windSpeed;
  final int? windDeg;
  final double? windGust;

  // Clouds & visibility
  final int? cloudiness;
  final int? visibility;

  // Time
  final int? timestamp;
  final int? sunrise;
  final int? sunset;

  // Status
  final int? cod;

  Weather({
    this.latitude,
    this.longitude,
    this.cityName,
    this.country,
    this.timezone,
    this.cityId,
    this.weatherId,
    this.mainCondition,
    this.description,
    this.icon,
    this.temp,
    this.feelsLike,
    this.tempMin,
    this.tempMax,
    this.pressure,
    this.humidity,
    this.seaLevel,
    this.groundLevel,
    this.windSpeed,
    this.windDeg,
    this.windGust,
    this.cloudiness,
    this.visibility,
    this.timestamp,
    this.sunrise,
    this.sunset,
    this.cod,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    final weatherList = json['weather'] as List?;
    final weather = (weatherList != null && weatherList.isNotEmpty)
        ? weatherList.first as Map<String, dynamic>
        : null;


    return Weather(
      // Coord
      latitude: (json['coord']?['lat'] as num?)?.toDouble(),
      longitude: (json['coord']?['lon'] as num?)?.toDouble(),

      // City
      cityName: json['name'] as String?,
      country: json['sys']?['country'] as String?,
      timezone: json['timezone'] as int?,
      cityId: json['id'] as int?,

      // Weather
      weatherId: weather?['id'] as int?,
      mainCondition: weather?['main'] as String?,
      description: weather?['description'] as String?,
      icon: weather?['icon'] as String?,

      // Main
      temp: (json['main']?['temp'] as num?)?.toDouble(),
      feelsLike: (json['main']?['feels_like'] as num?)?.toDouble(),
      tempMin: (json['main']?['temp_min'] as num?)?.toDouble(),
      tempMax: (json['main']?['temp_max'] as num?)?.toDouble(),
      pressure: json['main']?['pressure'] as int?,
      humidity: json['main']?['humidity'] as int?,
      seaLevel: json['main']?['sea_level'] as int?,
      groundLevel: json['main']?['grnd_level'] as int?,

      // Wind
      windSpeed: (json['wind']?['speed'] as num?)?.toDouble(),
      windDeg: json['wind']?['deg'] as int?,
      windGust: (json['wind']?['gust'] as num?)?.toDouble(),

      // Clouds / visibility
      cloudiness: json['clouds']?['all'] as int?,
      visibility: json['visibility'] as int?,

      // Time
      timestamp: json['dt'] as int?,
      sunrise: json['sys']?['sunrise'] as int?,
      sunset: json['sys']?['sunset'] as int?,

      // Status
      cod: json['cod'] as int?,
    );
  }
}
