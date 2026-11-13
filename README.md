# 🌬️ Air Quality App

A Flutter-based application for checking air quality in different cities using the Open-Meteo REST API. The application displays the Air Quality Index (AQI), PM2.5, and PM10 levels, and saves the last searched city using SharedPreferences.

## ✨ Features

- **City Search:** Search for air quality information by city name.
- **Air Quality Index (AQI):** Display the European AQI value and its category.
- **Pollutant Information:** Display PM2.5 and PM10 concentrations.
- **Asynchronous UI:** Implement FutureBuilder to handle Loading, Success, and Error states.
- **Local Storage:** Save and retrieve the last searched city using SharedPreferences.

## 🛠️ Technologies Used

- Flutter
- Dart
- HTTP Package
- SharedPreferences
- Open-Meteo REST API

## 📁 Project Structure

```text
lib/
├── models/
│   └── air_quality_model.dart
├── screens/
│   └── home_screen.dart
├── services/
│   ├── air_quality_service.dart
│   └── storage_service.dart
├── widgets/
└── main.dart
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK
- Visual Studio Code
- Google Chrome

### Installation

1. Clone this repository:

```bash
git clone https://github.com/annisayu-a/air-quality-app.git
```

2. Navigate to the project directory:

```bash
cd air-quality-app
```

3. Install the dependencies:

```bash
flutter pub get
```

### Run the Application

Run the following command in the terminal:

```bash
flutter run -d chrome --web-port=51470
```

## 📱 Tampilan Aplikasi

### 1. Tampilan Awal

![Tampilan Awal](dokumentasi/tampilan-aplikasi.png)

### 2. Hasil Pencarian Kualitas Udara

![Hasil Pencarian](dokumentasi/tampilan-aplikasi1.png)


## 🌐 API Sources

This application uses the following Open-Meteo APIs:

- [Geocoding API](https://open-meteo.com/en/docs/geocoding-api)
- [Air Quality API](https://open-meteo.com/en/docs/air-quality-api)

## 👩‍💻 Author

**Annisa Ayu Anggraini**

Mobile Programming Course Project.

Developed using Flutter and Dart.
