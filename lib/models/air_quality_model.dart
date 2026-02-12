class AirQuality {
  final int? aqi;
  final double? pm2_5;
  final double? pm10;
  final double? co;
  final double? no2;
  final double? so2;
  final double? o3;
  final double? nh3;
  final double? no;

  AirQuality({
    this.aqi,
    this.pm2_5,
    this.pm10,
    this.co,
    this.no2,
    this.so2,
    this.o3,
    this.nh3,
    this.no,
  });

  factory AirQuality.fromJson(Map<String, dynamic> json) {
    final list = json['list'] as List?;
    final data = (list != null && list.isNotEmpty)
        ? list.first as Map<String, dynamic>
        : null;

    final components = data?['components'] as Map<String, dynamic>?;

    return AirQuality(
      aqi: data?['main']?['aqi'] as int?,
      pm2_5: (components?['pm2_5'] as num?)?.toDouble(),
      pm10: (components?['pm10'] as num?)?.toDouble(),
      co: (components?['co'] as num?)?.toDouble(),
      no2: (components?['no2'] as num?)?.toDouble(),
      so2: (components?['so2'] as num?)?.toDouble(),
      o3: (components?['o3'] as num?)?.toDouble(),
      nh3: (components?['nh3'] as num?)?.toDouble(),
      no: (components?['no'] as num?)?.toDouble(),
    );
  }
}
