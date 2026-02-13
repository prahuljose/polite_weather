import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/air_quality_model.dart';
import '../models/weather_bundle.dart';
import '../services/location_cache.dart';
import '../services/weather_service.dart';
import '../services/location_service.dart';
import '../models/weather_model.dart';
import '../widgets/error_view.dart';
import 'package:lottie/lottie.dart';

import '../widgets/weather_render.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> with WidgetsBindingObserver {
  late Future<WeatherBundle>? _weatherFuture;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadWeather();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadWeather();
    }
  }

  bool showLoader = false;

  void _loadWeather() {
    setState(() {
      showLoader = false;
      _weatherFuture = null; // 🔥 CLEAR previous error state
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted) return;

      setState(() {
        _weatherFuture = _fetchWeather();
      });
    });

    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted && _weatherFuture != null) {
        setState(() => showLoader = true);
      }
    });
  }

  String? error;

  Future<WeatherBundle> _fetchWeather() async {
    final locationService = LocationService();
    final weatherService = WeatherService('32429398c5b3d5d4395c19075bf6564d');

    try {
      final position = await locationService.getCurrentLocation().timeout(
        const Duration(seconds: 11),
        onTimeout: () async {
          final cached = await LocationCache.get();
          if (cached != null) {
            return Position(
              latitude: cached.$1,
              longitude: cached.$2,
              timestamp: DateTime.now(),
              accuracy: 100,
              altitude: 0,
              heading: 0,
              speed: 0,
              speedAccuracy: 0,
              altitudeAccuracy: 0,
              headingAccuracy: 0,
            );
          }
          return Position(
            latitude: 37.7749,
            longitude: -122.4194,
            timestamp: DateTime.now(),
            accuracy: 1.0,
            altitude: 0.0,
            heading: 0.0,
            speed: 0.0,
            speedAccuracy: 0.0,
            altitudeAccuracy: 0,
            headingAccuracy: 0,
          );
        },
      );

      await LocationCache.save(position.latitude, position.longitude);

      final results = await Future.wait([
        weatherService.getWeatherByLocation(
          latitude: position.latitude,
          longitude: position.longitude,
        ),
        weatherService.getAirQualityByLocation(
          latitude: position.latitude,
          longitude: position.longitude,
        ),
      ]);

      return WeatherBundle(
        weather: results[0] as Weather,
        airQuality: results[1] as AirQuality,
      );
    } catch (e) {
      debugPrint('Weather error: $e');

      if (e.toString().contains('LOCATION_DENIED_FOREVER')) {
        throw Exception('Location permission permanently denied');
      } else if (e.toString().contains('LOCATION_DENIED')) {
        throw Exception('Location permission denied');
      } else if (e.toString().contains('LOCATION_DISABLED')) {
        throw Exception('Location services are disabled');
      } else {
        throw Exception('Unable to fetch weather data');
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<WeatherBundle>(
        future: _weatherFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              showLoader) {
            if (kDebugMode) {
              print(snapshot.connectionState);
              print(showLoader);
            }

            return Center(
              child: Lottie.asset(
                'assets/lotties/loading.json',
                width: 180,
                height: 180,
                repeat: true,
              ),
            );
          }

          if (snapshot.hasError) {
            final error = snapshot.error.toString();

            if (error.contains('LOCATION_DENIED_FOREVER')) {
              return ErrorView(
                message:
                    'Location permission permanently denied.\nEnable it from settings.',
                buttonText: 'Open Settings',
                onPressed: Geolocator.openAppSettings,
                // onPressed: _loadWeather,
                lottie: Lottie.asset(
                  'assets/lotties/gpsPermission.json',
                  width: 180,
                  height: 180,
                  repeat: true,
                ),
              );
            }

            if (error.contains('LOCATION_DENIED')) {
              return ErrorView(
                message:
                    'Location permission denied.\nWe need it to show local weather.',
                buttonText: 'Try Again',
                onPressed: _loadWeather,
                lottie: Lottie.asset(
                  'assets/lotties/gpsPermission.json',
                  width: 180,
                  height: 180,
                  repeat: true,
                ),
              );
            }

            if (error.contains('LOCATION_DISABLED')) {
              return ErrorView(
                message:
                    'Location services are turned off.\nPlease enable GPS.',
                buttonText: 'Try Again',
                onPressed: _loadWeather,
                lottie: Lottie.asset(
                  'assets/lotties/gpsPermission.json',
                  width: 180,
                  height: 180,
                  repeat: true,
                ),
              );
            }

            return ErrorView(
              message:
                  'Please make sure Location Permission is allowed, and your phone is connected to the internet!',
              buttonText: 'Retry',
              onPressed: _loadWeather,
              lottie: Lottie.asset(
                'assets/lotties/warning.json',
                width: 200,
                height: 200,
                repeat: false,
              ),
            );
          }

          if (!snapshot.hasData) {
            return const SizedBox(); // or fallback UI
          }

          final weather = snapshot.data!.weather;
          final airQuality = snapshot.data!.airQuality;

          return WeatherRender(weather: weather, airQuality: airQuality);
        },
      ),
    );
  }
}
