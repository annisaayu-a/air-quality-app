import 'package:flutter/material.dart';

import '../models/air_quality_model.dart';
import '../services/air_quality_service.dart';
import '../services/storage_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _cityController =
      TextEditingController();

  final AirQualityService _airQualityService =
      AirQualityService();

  final StorageService _storageService =
      StorageService();

  Future<AirQualityModel>? _airQualityFuture;

  @override
  void initState() {
    super.initState();
    _loadLastCity();
  }

  // Mengambil kota terakhir dari penyimpanan lokal
  Future<void> _loadLastCity() async {
    final lastCity = await _storageService.getLastCity();

    if (!mounted) return;

    if (lastCity != null && lastCity.isNotEmpty) {
      _cityController.text = lastCity;
      _searchCity(lastCity);
    }
  }

  // Mencari data kualitas udara
  void _searchCity([String? city]) {
    final cityName = (city ?? _cityController.text).trim();

    if (cityName.isEmpty) return;

    _cityController.text = cityName;

    setState(() {
      _airQualityFuture =
          _airQualityService.fetchAirQuality(cityName);
    });

    _storageService.saveLastCity(cityName);
  }

  // Warna berdasarkan kategori AQI
  Color _getAqiColor(double aqi) {
    if (aqi <= 20) return Colors.green;
    if (aqi <= 40) return Colors.lightGreen;
    if (aqi <= 60) return Colors.orange;
    if (aqi <= 80) return Colors.deepOrange;
    if (aqi <= 100) return Colors.red;
    return Colors.purple;
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Air Quality App',
          style: TextStyle(
            color: Color(0xFF172B4D),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 10),

                const Icon(
                  Icons.air,
                  size: 55,
                  color: Colors.blue,
                ),

                const SizedBox(height: 10),

                const Text(
                  'Cek Kualitas Udara',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF172B4D),
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Cari tahu kondisi udara di kotamu',
                  style: TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 25),

                // Kolom pencarian kota
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _cityController,
                        onSubmitted: (_) => _searchCity(),
                        decoration: InputDecoration(
                          hintText: 'Masukkan nama kota...',
                          prefixIcon: const Icon(Icons.location_city),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    ElevatedButton(
                      onPressed: () => _searchCity(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Icon(Icons.search),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                // FutureBuilder: Loading, Success, Error
                Expanded(
                  child: _airQualityFuture == null
                      ? const Center(
                          child: Text(
                            'Masukkan nama kota untuk melihat kualitas udara.',
                            textAlign: TextAlign.center,
                          ),
                        )
                      : FutureBuilder<AirQualityModel>(
                          future: _airQualityFuture,
                          builder: (context, snapshot) {
                            // Kondisi Loading
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(),
                                    SizedBox(height: 15),
                                    Text('Mengambil data kualitas udara...'),
                                  ],
                                ),
                              );
                            }

                            // Kondisi Error
                            if (snapshot.hasError) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.error_outline,
                                      color: Colors.red,
                                      size: 50,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      '${snapshot.error}',
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              );
                            }

                            // Kondisi Success
                            if (snapshot.hasData) {
                              final air = snapshot.data!;
                              final color =
                                  _getAqiColor(air.europeanAqi);

                              return SingleChildScrollView(
                                child: Column(
                                  children: [
                                    // Kartu AQI
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(25),
                                      decoration: BoxDecoration(
                                        color: color,
                                        borderRadius:
                                            BorderRadius.circular(20),
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            air.city,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),

                                          const SizedBox(height: 20),

                                          const Text(
                                            'European AQI',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),

                                          Text(
                                            air.europeanAqi
                                                .toStringAsFixed(0),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 65,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),

                                          Text(
                                            air.category,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(height: 20),

                                    // Informasi polutan
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _pollutantCard(
                                            'PM2.5',
                                            air.pm25,
                                          ),
                                        ),
                                        const SizedBox(width: 15),
                                        Expanded(
                                          child: _pollutantCard(
                                            'PM10',
                                            air.pm10,
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 20),

                                    const Text(
                                      'Sumber data: Open-Meteo',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }

                            return const Center(
                              child: Text('Data tidak tersedia.'),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget informasi polutan
  Widget _pollutantCard(String title, double value) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            '${value.toStringAsFixed(1)} µg/m³',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF172B4D),
            ),
          ),
        ],
      ),
    );
  }
}
