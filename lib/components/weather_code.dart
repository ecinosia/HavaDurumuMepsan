import 'package:flutter/material.dart';
import 'api_service.dart';
import 'weather_model.dart';

class WeatherCode extends StatefulWidget {
  const WeatherCode({super.key});

  @override
  State<WeatherCode> createState() => _WeatherCodeState();
}

class _WeatherCodeState extends State<WeatherCode> {
  late WeatherTest? _userModel;
  @override
  void initState() {
    super.initState();
    _getData();
    getCurrentWeatherString();
  }

  void _getData() async {
    _userModel = (await ApiService().getWeatherForTargetCoord());
  }

  late int? weatherCodeCurrent = _userModel!.currentWeather!.weathercode;
  late List<int>? weatherCodeHourly = _userModel!.hourly!.weathercode;
  late List<int>? weatherCodeDaily = _userModel!.daily!.weathercode;

  static late String weatherCodeCurrentStr;

  String getCurrentWeatherString() {
    return weatherCodeCurrentStr;
  }

  void getCurrentWeatherCode() {
    switch (weatherCodeCurrent) {
      case 0:
        weatherCodeCurrentStr = "Güneşli";
        break;
      case 1:
        weatherCodeCurrentStr = "Çoğunlukla Açık";
        break;
      case 2:
        weatherCodeCurrentStr = "Parçalı Bulutlu";
        break;
      case 3:
        weatherCodeCurrentStr = "Kapalı";
        break;
      case 45:
        weatherCodeCurrentStr = "Sisli";
        break;
      case const (51 | 53 | 55 | 56 | 57):
        weatherCodeCurrentStr = "Hafif Yağmurlu";
        break;
      case const (61 | 63 | 65 | 66 | 67):
        weatherCodeCurrentStr = "Yağmurlu";
        break;
      case const (71 | 73 | 75 | 77):
        weatherCodeCurrentStr = "Karlı";
        break;
      case const (80 | 81 | 82):
        weatherCodeCurrentStr = "Sağanak Yağmurlu";
        break;
      case const (85 | 86):
        weatherCodeCurrentStr = "Sağanak Karlı";
        break;
      case const (95 | 96 | 99):
        weatherCodeCurrentStr = "Gök Gürültülü";
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
