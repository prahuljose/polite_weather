import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:polite_weather/models/air_quality_model.dart';
import '../models/weather_model.dart';
import 'aqi_circular_widget.dart';
import 'glass_card.dart';

class WeatherRender extends StatefulWidget {
  const WeatherRender({
    super.key,
    required this.weather,
    required this.airQuality,
  });

  final Weather weather;
  final AirQuality airQuality;

  @override
  State<WeatherRender> createState() => _WeatherRenderState();
}

class _WeatherRenderState extends State<WeatherRender>
    with SingleTickerProviderStateMixin {
  // Mocked values for now
  final int _mockedCondition = 300;
  final String _mockedDayNight = "day";

  // Rotation controller for arrow
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  double _currentDegrees = 0; // current rotation in degrees

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // Initial animation (0°)
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Animate to a new degree
  void rotateArrow(double newDegrees) {
    _rotationAnimation = Tween<double>(
      begin: _currentDegrees,
      end: newDegrees,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _currentDegrees = newDegrees;
    _controller
      ..reset()
      ..forward();
  }

  Color getBackgroundColor(int? condition) {
    switch (condition) {
      case 200:
      case 201:
      case 202:
      case 221:
      case 230:
      case 231:
      case 232:
      case 210:
      case 211:
      case 212:
        return Colors.deepPurple;

      case 300:
      case 301:
      case 302:
      case 310:
      case 311:
      case 312:
      case 313:
      case 314:
      case 321:
        return Colors.lightBlueAccent;

      case 500:
      case 501:
      case 502:
      case 503:
      case 504:
      case 511:
      case 520:
      case 521:
      case 522:
      case 531:
        return Colors.blueGrey;

      case 600:
      case 601:
      case 602:
      case 611:
      case 612:
      case 613:
      case 615:
      case 616:
      case 620:
      case 621:
      case 622:
        return Colors.white;

      case 701:
      case 711:
      case 721:
      case 731:
      case 741:
      case 751:
      case 761:
      case 762:
      case 771:
      case 781:
        return Colors.teal;

      case 800:
        return Colors.orangeAccent;

      case 801:
      case 802:
      case 803:
      case 804:
        return Colors.grey;

      default:
        return Colors.grey;
    }
  }

  Color getTextColor(int? condition) {
    switch (condition) {
      case 600:
      case 601:
      case 602:
      case 611:
      case 612:
      case 613:
      case 615:
      case 616:
      case 620:
      case 621:
      case 622:
        return Colors.black;

      case 701:
      case 711:
      case 721:
      case 731:
      case 741:
      case 751:
      case 761:
      case 762:
      case 771:
      case 781:
        return Colors.white;

      default:
        return Colors.white;
    }
  }

  String getLottie(int? condition, String? dayNight) {
    switch (condition) {
      // Thunderstorm
      case 200:
      case 201:
      case 202:
      case 221:
      case 230:
      case 231:
      case 232:
        return 'assets/lotties/weatherLottie/thunderstorm-rain.json';
      case 210:
      case 211:
      case 212:
        return 'assets/lotties/weatherLottie/thunder.json';

      // Drizzle
      case 300:
      case 301:
      case 302:
      case 310:
      case 311:
      case 312:
      case 313:
      case 314:
      case 321:
        return 'assets/lotties/weatherLottie/rain.json';

      // Rain
      case 500:
      case 501:
      case 502:
      case 503:
      case 504:
      case 511:
      case 520:
      case 521:
      case 522:
      case 531:
        return 'assets/lotties/weatherLottie/rain-day.json';

      // Snow
      case 600:
      case 601:
      case 602:
      case 611:
      case 612:
      case 613:
      case 615:
      case 616:
      case 620:
      case 621:
      case 622:
        return 'assets/lotties/weatherLottie/snow.json';

      // Atmosphere
      case 701:
      case 711:
      case 721:
      case 731:
      case 741:
      case 751:
      case 761:
      case 762:
      case 771:
      case 781:
        return 'assets/lotties/weatherLottie/atmosphere.json';

      // Clear
      case 800:
        return 'assets/lotties/weatherLottie/clear.json';

      // Clouds
      case 801:
      case 802:
      case 803:
      case 804:
        {
          if ((dayNight ?? '').toLowerCase() == "day") {
            return 'assets/lotties/weatherLottie/clear.json';
          }
          return 'assets/lotties/weatherLottie/clear.json';
        }

      default:
        return 'assets/lotties/warning.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime toLocalTime(int epochSeconds) {
      return DateTime.fromMillisecondsSinceEpoch(
        epochSeconds * 1000,
        isUtc: true,
      ).toLocal();
    }

    String formatTime12Hr(DateTime dt) {
      final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
      final minute = dt.minute.toString().padLeft(2, '0');
      final period = dt.hour >= 12 ? 'PM' : 'AM';

      return "$hour:$minute $period";
    }

    final weather = widget.weather;
    final airQuality = widget.airQuality;

    // Determine day/night
    String dayNight =
        (weather.timestamp! >= weather.sunrise! &&
            weather.timestamp! <= weather.sunset!)
        ? "day"
        : "night";

    // Mocking values
    final weatherId = weather.weatherId;
    if (kDebugMode) {
      print(weatherId);
      print(dayNight);
    }
    final bgColor = getBackgroundColor(_mockedCondition);
    final textColor = getTextColor(_mockedCondition);
    final lottieToShow = getLottie(_mockedCondition, dayNight);

    // Example: Rotate arrow to wind direction (mocked 90° for demo)
    rotateArrow(
      weather.windDeg!.toDouble(),
    ); // You can replace this with weather.wind?.deg

    final arrowAsset = textColor == Colors.white
        ? 'assets/images/upArrowWhite.png'
        : 'assets/images/upArrowBlack.png';

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: bgColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(lottieToShow, width: 180, height: 180, repeat: true),
              Text(
                weather.cityName ?? 'N/A',
                style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
              Text(
                weather.mainCondition ?? 'N/A',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w400,
                  color: textColor,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    weather.temp != null
                        ? '${weather.temp!.toStringAsFixed(0)}'
                        : '--',
                    style: TextStyle(
                      fontSize: 115,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(5, 25),
                    child: Text(
                      '°',
                      style: TextStyle(fontSize: 60, color: textColor),
                    ),
                  ),
                ],
              ),
              //const SizedBox(height: 10),

              // Arrow Image rotating
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GlassCard(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedBuilder(
                            animation: _rotationAnimation,
                            builder: (context, child) {
                              return Transform.rotate(
                                angle:
                                    _rotationAnimation.value *
                                    3.1415926 /
                                    180, // degrees → radians
                                child: child,
                              );
                            },
                            child: Image.asset(
                              arrowAsset, // Your arrow pointing up by default
                              width: 15,
                              height: 15,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Transform.translate(
                                offset: const Offset(0, 0),
                                child: Text(
                                  '${weather.windSpeed}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 10,
                                    color: textColor,
                                  ),
                                ),
                              ),
                              SizedBox(width: 2),
                              Transform.translate(
                                offset: const Offset(0, 0),
                                child: Text(
                                  'm/s',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 7,
                                    color: textColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    //const SizedBox(width: 10),
                    GlassCard(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cloud, size: 17, color: textColor),
                          Transform.translate(
                            offset: const Offset(0, 0),
                            child: Text(
                              '${weather.cloudiness}%',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 10,
                                color: textColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //const SizedBox(width: 10),
                    GlassCard(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.sunny, size: 17, color: textColor),
                          Transform.translate(
                            offset: const Offset(0, 0),
                            child: Text(
                              '${formatTime12Hr(toLocalTime(weather.sunrise!))}',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 10,
                                color: textColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //const SizedBox(width: 10),
                    GlassCard(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.nights_stay, size: 17, color: textColor),
                          Transform.translate(
                            offset: const Offset(0, 0),
                            child: Text(
                              '${formatTime12Hr(toLocalTime(weather.sunset!))}',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 10,
                                color: textColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GlassCard(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.water, size: 13, color: textColor),
                              Transform.translate(
                                offset: const Offset(0, 0),
                                child: Text(
                                  ' PM2.5',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 10,
                                    color: textColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Transform.translate(
                            offset: const Offset(0, 0),
                            child: Text(
                              '${airQuality.pm2_5!.toStringAsFixed(1)}µg/m³',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 10,
                                color: textColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //SizedBox(width: 10),
                    GlassCard(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.water, size: 13, color: textColor),
                              Transform.translate(
                                offset: const Offset(0, 0),
                                child: Text(
                                  ' PM10',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 10,
                                    color: textColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Transform.translate(
                            offset: const Offset(0, 0),
                            child: Text(
                              '${airQuality.pm10!.toStringAsFixed(1)}µg/m³',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 10,
                                color: textColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //SizedBox(width: 10),
                    GlassCard(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.water, size: 13, color: textColor),
                              Transform.translate(
                                offset: const Offset(0, 0),
                                child: Text(
                                  ' CO',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 10,
                                    color: textColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Transform.translate(
                            offset: const Offset(0, 0),
                            child: Text(
                              '${airQuality.co!.toStringAsFixed(1)}µg/m³',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 10,
                                color: textColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //SizedBox(width: 10),
                    GlassCard(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.water, size: 13, color: textColor),
                              Transform.translate(
                                offset: const Offset(0, 0),
                                child: Text(
                                  ' O3',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 10,
                                    color: textColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Transform.translate(
                            offset: const Offset(0, 0),
                            child: Text(
                              '${airQuality.o3!.toStringAsFixed(1)}µg/m³',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 10,
                                color: textColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 35),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [AqiCircularGauge(aqi: airQuality.aqi ?? 1, textColor: textColor)],
              ),
              SizedBox(height: 30,),
              Transform.translate(
                offset: const Offset(0, 0),
                child: Text(
                  'Weather data accurate up until:${toLocalTime(weather.timestamp!)}',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 8,
                    color: textColor.withAlpha((0.6 * 255).round()),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
