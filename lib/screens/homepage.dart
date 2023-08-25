// ignore_for_file: unnecessary_null_comparison, unused_element, avoid_print

import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mepsan_hava_durumu/components/daily_part.dart';
import 'package:mepsan_hava_durumu/components/details_part.dart';
import 'package:mepsan_hava_durumu/components/hourly_part.dart';

import '../components/api_service.dart';
import '../components/weather_model.dart';
import 'mappage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  String _cityName = "";
  String? locationMessage;
  bool positionBool = false;

  Future<Map<String, double?>> getWeatherForTargetLoc() async {
    double? latitude;
    double? longitude;
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Konum servisleri kapalı!");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Konum izni reddedildi.");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          "Konum servisleri kalıcı olarak reddedildi. Konum alınamıyor.");
    }
    try {
      Position position = await Geolocator.getCurrentPosition();
      if (position != null) {
        longitude = position.longitude;
        latitude = position.latitude;
        positionBool == true;
        setState(() {});
      } else {
        throw ("Lokasyon verileri boş geldi!");
      }
    } catch (e) {
      throw ("Lokasyon çekerken hata: ${e.toString()}");
    }

    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);

    if (placemarks.isNotEmpty) {
      Placemark placemark = placemarks.first;
      setState(() {
        _cityName = placemark.administrativeArea ?? "Şehir bulunamadı!";
      });
    }

    if (positionBool) {
      locationMessage =
          "Latitude: ${latitude.toString()}, Longitude: ${longitude.toString()}, City: $_cityName";
      setState(() {
        locationMessage =
            "Latitude: ${latitude.toString()}, Longitude: ${longitude.toString()}, City: $_cityName";
      });
    }
    Map<String, double?> locationData = {
      'latitude': latitude,
      'longitude': longitude
    };
    return locationData;
  }

  late WeatherTest? _userModel;
  int? weatherCodeCurrent;
  List<int>? isDayHourly;
  List<int>? weatherCodeHourly;

  void getData() async {
    try {
      Map<String, double?> locationData = await getWeatherForTargetLoc();

      double? latitude = locationData['latitude'];
      double? longitude = locationData['longitude'];

      WeatherTest userModel = await ApiService()
          .getWeatherForTargetCoord(latitude.toString(), longitude.toString());

      setState(() {
        _userModel = userModel;
        weatherCodeCurrent = userModel.currentWeather?.weathercode;
        isDayHourly = userModel.hourly?.isDay;
        weatherCodeHourly = userModel.hourly?.weathercode;
      });
    } catch (error) {
      print('Error occurred: $error');
    }
  }

  String getCardinalDirection(num directionInDegrees) {
    if (directionInDegrees < 22.5 || directionInDegrees >= 337.5) {
      return 'Kuzey';
    } else if (directionInDegrees >= 22.5 && directionInDegrees < 67.5) {
      return 'Kuzey Doğu';
    } else if (directionInDegrees >= 67.5 && directionInDegrees < 112.5) {
      return 'Doğu';
    } else if (directionInDegrees >= 112.5 && directionInDegrees < 157.5) {
      return 'Güney Doğu';
    } else if (directionInDegrees >= 157.5 && directionInDegrees < 202.5) {
      return 'Güney';
    } else if (directionInDegrees >= 202.5 && directionInDegrees < 247.5) {
      return 'Güney Batı';
    } else if (directionInDegrees >= 247.5 && directionInDegrees < 292.5) {
      return 'Batı';
    } else {
      return 'Kuzey Batı';
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherGifMap = {
      0: "assets/gifs/gunesli.gif",
      1: "assets/gifs/gunesli.gif",
      2: "assets/gifs/parcalibulutlu.gif",
      3: "assets/gifs/parcalibulutlu.gif",
      45: "assets/gifs/sisli.gif",
      51: "assets/gifs/yagmurlu.gif",
      53: "assets/gifs/yagmurlu.gif",
      55: "assets/gifs/yagmurlu.gif",
      56: "assets/gifs/yagmurlu.gif",
      57: "assets/gifs/yagmurlu.gif",
      61: "assets/gifs/yagmurlu.gif",
      63: "assets/gifs/yagmurlu.gif",
      65: "assets/gifs/yagmurlu.gif",
      66: "assets/gifs/yagmurlu.gif",
      67: "assets/gifs/yagmurlu.gif",
      71: "assets/gifs/karli.gif",
      73: "assets/gifs/karli.gif",
      75: "assets/gifs/karli.gif",
      77: "assets/gifs/karli.gif",
      80: "assets/gifs/saganakyagmur.gif",
      81: "assets/gifs/saganakyagmur.gif",
      82: "assets/gifs/saganakyagmur.gif",
      85: "assets/gifs/saganakkarli.gif",
      86: "assets/gifs/saganakkarli.gif",
      95: "assets/gifs/gokgurultulu.gif",
      96: "assets/gifs/gokgurultulu.gif",
      99: "assets/gifs/gokgurultulu.gif",
    };

    final weatherColorMap = {
      0: [
        const Color.fromRGBO(253, 200, 48, 1),
        const Color.fromRGBO(243, 115, 53, 1)
      ],
      1: [
        const Color.fromRGBO(253, 200, 48, 1),
        const Color.fromRGBO(243, 115, 53, 1)
      ],
      2: [
        const Color.fromRGBO(149, 184, 204, 1),
        const Color.fromRGBO(219, 212, 180, 1),
        const Color.fromRGBO(122, 161, 210, 1),
      ],
      3: [
        const Color.fromRGBO(149, 184, 204, 1),
        const Color.fromRGBO(219, 212, 180, 1),
        const Color.fromRGBO(122, 161, 210, 1),
      ],
      45: [
        const Color.fromRGBO(20, 30, 48, 1),
        const Color.fromRGBO(36, 59, 85, 1),
      ],
      51: [
        const Color.fromRGBO(75, 108, 183, 1),
        const Color.fromRGBO(24, 40, 72, 1),
      ],
      53: [
        const Color.fromRGBO(75, 108, 183, 1),
        const Color.fromRGBO(24, 40, 72, 1),
      ],
      55: [
        const Color.fromRGBO(75, 108, 183, 1),
        const Color.fromRGBO(24, 40, 72, 1),
      ],
      56: [
        const Color.fromRGBO(75, 108, 183, 1),
        const Color.fromRGBO(24, 40, 72, 1),
      ],
      57: [
        const Color.fromRGBO(75, 108, 183, 1),
        const Color.fromRGBO(24, 40, 72, 1),
      ],
      61: [
        const Color.fromRGBO(75, 108, 183, 1),
        const Color.fromRGBO(24, 40, 72, 1),
      ],
      63: [
        const Color.fromRGBO(75, 108, 183, 1),
        const Color.fromRGBO(24, 40, 72, 1),
      ],
      65: [
        const Color.fromRGBO(75, 108, 183, 1),
        const Color.fromRGBO(24, 40, 72, 1),
      ],
      66: [
        const Color.fromRGBO(75, 108, 183, 1),
        const Color.fromRGBO(24, 40, 72, 1),
      ],
      67: [
        const Color.fromRGBO(75, 108, 183, 1),
        const Color.fromRGBO(24, 40, 72, 1),
      ],
      71: [
        const Color.fromRGBO(48, 67, 82, 1),
        const Color.fromRGBO(215, 210, 204, 1),
      ],
      73: [
        const Color.fromRGBO(48, 67, 82, 1),
        const Color.fromRGBO(215, 210, 204, 1),
      ],
      75: [
        const Color.fromRGBO(48, 67, 82, 1),
        const Color.fromRGBO(215, 210, 204, 1),
      ],
      77: [
        const Color.fromRGBO(48, 67, 82, 1),
        const Color.fromRGBO(215, 210, 204, 1),
      ],
      80: [
        const Color.fromRGBO(20, 30, 48, 1),
        const Color.fromRGBO(36, 59, 85, 1),
      ],
      81: [
        const Color.fromRGBO(20, 30, 48, 1),
        const Color.fromRGBO(36, 59, 85, 1),
      ],
      82: [
        const Color.fromRGBO(20, 30, 48, 1),
        const Color.fromRGBO(36, 59, 85, 1),
      ],
      85: [
        const Color.fromRGBO(21, 28, 35, 1),
        const Color.fromRGBO(215, 210, 204, 1),
      ],
      86: [
        const Color.fromRGBO(21, 28, 35, 1),
        const Color.fromRGBO(215, 210, 204, 1),
      ],
      95: [
        const Color.fromRGBO(183, 195, 208, 1),
        const Color.fromRGBO(137, 152, 170, 1),
        const Color.fromRGBO(91, 115, 151, 1),
        const Color.fromRGBO(68, 60, 132, 1),
      ],
      96: [
        const Color.fromRGBO(183, 195, 208, 1),
        const Color.fromRGBO(137, 152, 170, 1),
        const Color.fromRGBO(91, 115, 151, 1),
        const Color.fromRGBO(68, 60, 132, 1),
      ],
      99: [
        const Color.fromRGBO(183, 195, 208, 1),
        const Color.fromRGBO(137, 152, 170, 1),
        const Color.fromRGBO(91, 115, 151, 1),
        const Color.fromRGBO(68, 60, 132, 1),
      ],
    };

    // ignore: unused_local_variable
    late List<int> weatherCodeDaily = _userModel!.daily!.weathercode!;

    List<Color>? colors = weatherColorMap[weatherCodeCurrent];

    String getWeatherGif(int index) {
      int currentWeatherCode = weatherCodeHourly![index];

      if (isDayHourly![index] == 1) {
        // Day time
        return weatherGifMap[currentWeatherCode]!;
      } else {
        // Night time
        if (currentWeatherCode == 0 ||
            currentWeatherCode == 1 ||
            currentWeatherCode == 2 ||
            currentWeatherCode == 3 ||
            currentWeatherCode == 45) {
          // Clear night
          return "assets/gifs/ay.gif";
        } else {
          // Rain/snow etc
          return weatherGifMap[currentWeatherCode]!;
        }
      }
    }

    List<Color>? getWeatherColor(int index) {
      int currentWeatherCode = weatherCodeHourly![index];

      if (isDayHourly![index] == 1) {
        // Day time
        return colors = weatherColorMap[weatherCodeCurrent];
      } else {
        // Night time
        if (currentWeatherCode == 0 ||
            currentWeatherCode == 1 ||
            currentWeatherCode == 2 ||
            currentWeatherCode == 3 ||
            currentWeatherCode == 45) {
          // Clear night
          return colors = [
            const Color.fromRGBO(0, 0, 0, 255),
            const Color.fromRGBO(67, 67, 67, 255)
          ];
        } else {
          // Rain/snow etc
          return colors = weatherColorMap[weatherCodeCurrent];
        }
      }
    }

    List<String> hours = [
      '00',
      '01',
      "02",
      "03",
      "04",
      "05",
      "06",
      "07",
      "08",
      "09",
      "10",
      "11",
      "12",
      "13",
      "14",
      "15",
      "16",
      "17",
      "18",
      "19",
      "20",
      "21",
      "22",
      '23'
    ];

    int getNextIndex(int currentIndex) {
      int nextIndex = currentIndex + 1;

      if (nextIndex >= hours.length) {
        nextIndex = 0;
      }

      return nextIndex;
    }

    int currentIndex = hours
        .indexWhere((hour) => hour == DateFormat('HH').format(DateTime.now()));

    final weatherCodeMap = {
      0: "Güneşli",
      1: "Çoğunlukla Açıklı",
      2: "Parçalı Bulutlu",
      3: "Kapalı",
      45: "Sisli",
      51: "Hafif Yağmurlu",
      53: "Hafif Yağmurlu",
      55: "Hafif Yağmurlu",
      56: "Hafif Yağmurlu",
      57: "Hafif Yağmurlu",
      61: "Yağmurlu",
      63: "Yağmurlu",
      65: "Yağmurlu",
      66: "Yağmurlu",
      67: "Yağmurlu",
      71: "Karlı",
      73: "Karlı",
      75: "Karlı",
      77: "Karlı",
      80: "Sağanak Yağmurlu",
      81: "Sağanak Yağmurlu",
      82: "Sağanak Yağmurlu",
      85: "Sağanak Karlı",
      86: "Sağanak Karlı",
      95: "Gök Gürültülü",
      96: "Gök Gürültülü",
      99: "Gök Gürültülü",
    };

    return Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: colors!,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 8,
                ),
                //Current Weather Part
                Column(
                  children: [
                    //City Name
                    Text(
                      _cityName,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.oswald(
                        color: Colors.white,
                        fontSize: 45,
                      ),
                    ),
                    //Degree
                    Text(
                      "${_userModel!.currentWeather!.temperature!.round()}°C",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.oswald(
                        color: Colors.white,
                        fontSize: 80,
                      ),
                    ),
                    //Weather Status
                    Text(
                      weatherCodeMap[weatherCodeCurrent]!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.oswald(
                        color: Colors.white,
                        fontSize: 35,
                      ),
                    ),
                    //Apperant Temperature
                    Text(
                      "Hissedilen Sıcaklık: ${_userModel!.hourly!.apparentTemperature![currentIndex].round()}°C",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.oswald(
                        color: Colors.white,
                        fontSize: 30,
                      ),
                    ),
                    //Lowest and Highest Degree of Today
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "En Düşük: ${_userModel!.daily!.temperature2MMin![0].round()}°C",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.oswald(
                            color: Colors.white,
                            fontSize: 25,
                          ),
                        ),
                        const SizedBox(
                          width: 13,
                        ),
                        Text(
                          "En Yüksek: ${_userModel!.daily!.temperature2MMax![0].round()}°C",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.oswald(
                            color: Colors.white,
                            fontSize: 25,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 35,
                ),
                const HourlyPartClass(),
                const SizedBox(
                  height: 15,
                ),
                const DailyPartClass(),
                const SizedBox(height: 25),
                const DetailsPartClass(),
                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
        //Bottom Nav Bar
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.surface,
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MapPage(),
            ),
          ),
          child: Icon(
            CupertinoIcons.map,
            color: Theme.of(context).colorScheme.onSurface,
            size: 45,
          ),
        )
        // GestureDetector(
        //   onTap: () => Navigator.push(
        //       context, MaterialPageRoute(builder: (context) => const MapPage())),
        //   child: Icon(CupertinoIcons.map,
        //       color: Theme.of(context).colorScheme.onSurface, size: 36),
        // ),
        );
  }
}
