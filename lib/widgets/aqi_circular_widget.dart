import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AqiCircularGauge extends StatelessWidget {
  const AqiCircularGauge({
    super.key,
    required this.aqi,
    required this.textColor,
  });

  final int aqi;
  final Color textColor;

  String aqiText(int aqi) {
    switch (aqi) {
      case 1:
        return 'Good';
      case 2:
        return 'Fair';
      case 3:
        return 'Moderate';
      case 4:
        return 'Poor';
      case 5:
        return 'Very Poor';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    //final ringColor = Colors.black87;
    //final Color ringColor;
    final ringColor = Colors.black45;

    /// AQI scale: 0–300 → normalize to 0–1
    final double progress = 1 - (aqi / 5);
    //print(progress);

    return Stack(
      alignment: Alignment.center,
      children: [
        /// Circular Ring
        SizedBox(
          width: 300,
          height: 115,
          child: LinearProgressIndicator(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            value: progress,
            backgroundColor: Colors.black12,
            valueColor: AlwaysStoppedAnimation(ringColor),
          ),
        ),

        /// Center Content
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 0),
            Text(
              aqiText(aqi),
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 0),
            Text(
              'AQI Rating: ${aqi.toInt()}',
              style: TextStyle(fontSize: 16, color: textColor),
            ),
          ],
        ),
      ],
    );
  }
}
