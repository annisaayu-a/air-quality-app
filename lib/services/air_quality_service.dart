import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/air_quality_model.dart';

class AirQualityService {
  // Mencari koordinat berdasarkan nama kota
  Future<Map<String, dynamic>> getCityCoordinates(
    String city,
  ) async {
    final url = Uri.parse(
      'https://geocoding-api.open-meteo.com/v1/search'
      '?name=${Uri.encodeComponent(city)}'
      '&count=1&language=id&format=json',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final results = data['results'];

      if (results == null || results.isEmpty) {
        throw Exception('Kota "$city" tidak ditemukan.');
      }

      return results[0];
    } else {
      throw Exception('Gagal mencari lokasi kota.');
    }
  }

  // Mengambil data kualitas udara
  Future<AirQualityModel> fetchAirQuality(
    String city,
  ) async {
    final location = await getCityCoordinates(city);

    final latitude = location['latitude'];
    final longitude = location['longitude'];
    final cityName = location['name'];

    final url = Uri.parse(
      'https://air-quality-api.open-meteo.com/v1/air-quality'
      '?latitude=$latitude'
      '&longitude=$longitude'
      '&current=european_aqi,pm2_5,pm10',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return AirQualityModel.fromJson(data, cityName);
    } else {
      throw Exception('Gagal mengambil data kualitas udara.');
    }
  }
}
