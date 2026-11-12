class AirQualityModel {
  final String city;
  final double latitude;
  final double longitude;
  final double europeanAqi;
  final double pm25;
  final double pm10;

  AirQualityModel({
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.europeanAqi,
    required this.pm25,
    required this.pm10,
  });

  // Factory Method untuk mengubah JSON menjadi objek Dart
  factory AirQualityModel.fromJson(
    Map<String, dynamic> json,
    String city,
  ) {
    final current = json['current'];

    return AirQualityModel(
      city: city,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      europeanAqi: (current['european_aqi'] as num).toDouble(),
      pm25: (current['pm2_5'] as num).toDouble(),
      pm10: (current['pm10'] as num).toDouble(),
    );
  }

  // Menentukan kategori kualitas udara
  String get category {
    if (europeanAqi <= 20) return 'Baik';
    if (europeanAqi <= 40) return 'Cukup Baik';
    if (europeanAqi <= 60) return 'Sedang';
    if (europeanAqi <= 80) return 'Buruk';
    if (europeanAqi <= 100) return 'Sangat Buruk';
    return 'Sangat Tidak Sehat';
  }
}
