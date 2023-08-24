import 'dart:core';

import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

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

  // ignore: no_leading_underscores_for_local_identifiers
  // Future<Position> _getCurrentLocation() async {
  //   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     return Future.error("Konum servisleri kapalı!");
  //   }

  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       return Future.error("Konum izni reddedildi!");
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     return Future.error(
  //         "Konum servisleri kalıcı olarak reddedildi. Konum bilgisi alınamıyor!");
  //   }
  //   return await Geolocator.getCurrentPosition(); // biraz karışmış
  // }

  // String _city = "";
  // // ignore: unused_element
  // Future<bool> getCurrentLocationCoord() async {
  //   try {
  //     Position position = await _getCurrentLocation();
  //     // ignore: unnecessary_null_comparison
  //     if (position != null) {
  //       longitude = position.longitude;
  //       latitude = position.latitude;
  //       debugPrint("Lokasyon Verileri: $longitude , $latitude");
  //       setState(() {});
  //       List<Placemark> placemarks =
  //           await placemarkFromCoordinates(latitude!, longitude!);

  //       if (placemarks.isNotEmpty) {
  //         Placemark placemark = placemarks.first;

  //         print('Placemark: $placemark');

  //         setState(() {
  //           _city = placemark.administrativeArea ?? 'City not available';
  //         });
  //       }
  //       return true;
  //     } else {
  //       debugPrint("boş veri");
  //       throw ("Lokasyon Verileri boş geldi");
  //     }
  //   } catch (e) {
  //     debugPrint("catch içinde hata");
  //     throw ("Lokasyon Çekerken Hata : ${e.toString()}");
  //   }
  // }

  // Future<void> initiliazeLocation() async {
  //   if (await getCurrentLocationCoord()) {
  //     locationMessage =
  //         "Latitude: ${latitude.toString()}, Longitude: ${longitude.toString()}, City: $_city";
  //     debugPrint("initlocaliton func1 : $locationMessage");
  //     setState(() {
  //       locationMessage =
  //           "Latitude: ${latitude.toString()}, Longitude: ${longitude.toString()}, City: $_city";
  //       debugPrint("initlocaliton func2 : $locationMessage");
  //     });
  //   } else {
  //     debugPrint("hata buton0");
  //     setState(() {
  //       debugPrint("hata buton1");
  //       locationMessage = "Lokasyon verileri Hatalı";
  //       debugPrint("hata buton");
  //     });
  //   }
  // }

  // void _getData(String lati, String longi) async {
  //   debugPrint("_getData func: Lat: $lati, Long: $longi");
  //   _userModel = (await ApiService().getWeatherForTargetCoord(lati, longi));
  //   debugPrint("_getData func2: Lat: $lati, Long: $longi");
  // }

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
        await placemarkFromCoordinates(latitude!, longitude!);

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

    // getWeatherForTargetLoc().then((locationData) async {
    //   double? latitude = locationData['latitude'];
    //   double? longitude = locationData['longitude'];

    //   _userModel = (await ApiService()
    //       .getWeatherForTargetCoord(latitude.toString(), longitude.toString()));
    // });
  }

  DateTime now = DateTime.now();
  late int formattedHour = now.hour;

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

  List<String> days = ["Pzt", "Sal", "Çar", "Per", "Cum", "Cmt", "Paz"];

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

  int getNextIndex(int currentIndex) {
    int nextIndex = currentIndex + 1;

    if (nextIndex >= hours.length) {
      nextIndex = 0;
    }

    return nextIndex;
  }

  int getNextIndexDays(int currentIndexDays) {
    int nextIndexDays = currentIndexDays + 1;

    if (nextIndexDays >= days.length) {
      nextIndexDays = 0;
    }

    return nextIndexDays;
  }

  @override
  Widget build(BuildContext context) {
    //Days

    int weekdayIndex = DateTime.now().weekday - 1;
    String weekdayName = days[weekdayIndex];

    int nextDayIndex1 = getNextIndexDays(weekdayIndex);
    String nextDay1 = days[nextDayIndex1];

    int nextDayIndex2 = getNextIndexDays(nextDayIndex1);
    String nextDay2 = days[nextDayIndex2];

    int nextDayIndex3 = getNextIndexDays(nextDayIndex2);
    String nextDay3 = days[nextDayIndex3];

    int nextDayIndex4 = getNextIndexDays(nextDayIndex3);
    String nextDay4 = days[nextDayIndex4];

    int nextDayIndex5 = getNextIndexDays(nextDayIndex4);
    String nextDay5 = days[nextDayIndex5];

    int nextDayIndex6 = getNextIndexDays(nextDayIndex5);
    String nextDay6 = days[nextDayIndex6];

    int nextDayIndex7 = getNextIndexDays(nextDayIndex6);
    String nextDay7 = days[nextDayIndex7];

    //Hours

    int currentIndex = hours
        .indexWhere((hour) => hour == DateFormat('HH').format(DateTime.now()));

    int nextIndex1 = getNextIndex(currentIndex);
    String nextHour1 = hours[nextIndex1];

    int nextIndex2 = getNextIndex(nextIndex1);
    String nextHour2 = hours[nextIndex2];

    int nextIndex3 = getNextIndex(nextIndex2);
    String nextHour3 = hours[nextIndex3];

    int nextIndex4 = getNextIndex(nextIndex3);
    String nextHour4 = hours[nextIndex4];

    int nextIndex5 = getNextIndex(nextIndex4);
    String nextHour5 = hours[nextIndex5];

    int nextIndex6 = getNextIndex(nextIndex5);
    String nextHour6 = hours[nextIndex6];

    int nextIndex7 = getNextIndex(nextIndex6);
    String nextHour7 = hours[nextIndex7];

    int nextIndex8 = getNextIndex(nextIndex7);
    String nextHour8 = hours[nextIndex8];

    int nextIndex9 = getNextIndex(nextIndex8);
    String nextHour9 = hours[nextIndex9];

    int nextIndex10 = getNextIndex(nextIndex9);
    String nextHour10 = hours[nextIndex10];

    int nextIndex11 = getNextIndex(nextIndex10);
    String nextHour11 = hours[nextIndex11];

    int nextIndex12 = getNextIndex(nextIndex11);
    String nextHour12 = hours[nextIndex12];

    int nextIndex13 = getNextIndex(nextIndex12);
    String nextHour13 = hours[nextIndex13];

    int nextIndex14 = getNextIndex(nextIndex13);
    String nextHour14 = hours[nextIndex14];

    int nextIndex15 = getNextIndex(nextIndex14);
    String nextHour15 = hours[nextIndex15];

    int nextIndex16 = getNextIndex(nextIndex15);
    String nextHour16 = hours[nextIndex16];

    int nextIndex17 = getNextIndex(nextIndex16);
    String nextHour17 = hours[nextIndex17];

    int nextIndex18 = getNextIndex(nextIndex17);
    String nextHour18 = hours[nextIndex18];

    int nextIndex19 = getNextIndex(nextIndex18);
    String nextHour19 = hours[nextIndex19];

    int nextIndex20 = getNextIndex(nextIndex19);
    String nextHour20 = hours[nextIndex20];

    int nextIndex21 = getNextIndex(nextIndex20);
    String nextHour21 = hours[nextIndex21];

    int nextIndex22 = getNextIndex(nextIndex21);
    String nextHour22 = hours[nextIndex22];

    int nextIndex23 = getNextIndex(nextIndex22);
    String nextHour23 = hours[nextIndex23];

    int nextIndex24 = getNextIndex(nextIndex23);
    String nextHour24 = hours[nextIndex24];

    var brightness = MediaQuery.of(context).platformBrightness;

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

    // late List<int> weatherCodeHourly = _userModel!.hourly!.weathercode!;
    // ignore: unused_local_variable
    late List<int> weatherCodeDaily = _userModel!.daily!.weathercode!;

    List<Color>? colors = weatherColorMap[weatherCodeCurrent];

    // List<int> isDayHourly = _userModel!.hourly!.isDay!;

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

    // ignore: unused_element
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

    String currentHourWeatherGif = getWeatherGif(currentIndex);
    String hour1WeatherGif = getWeatherGif(nextIndex1);
    String hour2WeatherGif = getWeatherGif(nextIndex2);
    String hour3WeatherGif = getWeatherGif(nextIndex3);
    String hour4WeatherGif = getWeatherGif(nextIndex4);
    String hour5WeatherGif = getWeatherGif(nextIndex5);
    String hour6WeatherGif = getWeatherGif(nextIndex6);
    String hour7WeatherGif = getWeatherGif(nextIndex7);
    String hour8WeatherGif = getWeatherGif(nextIndex8);
    String hour9WeatherGif = getWeatherGif(nextIndex9);
    String hour10WeatherGif = getWeatherGif(nextIndex10);
    String hour11WeatherGif = getWeatherGif(nextIndex11);
    String hour12WeatherGif = getWeatherGif(nextIndex12);
    String hour13WeatherGif = getWeatherGif(nextIndex13);
    String hour14WeatherGif = getWeatherGif(nextIndex14);
    String hour15WeatherGif = getWeatherGif(nextIndex15);
    String hour16WeatherGif = getWeatherGif(nextIndex16);
    String hour17WeatherGif = getWeatherGif(nextIndex17);
    String hour18WeatherGif = getWeatherGif(nextIndex18);
    String hour19WeatherGif = getWeatherGif(nextIndex19);
    String hour20WeatherGif = getWeatherGif(nextIndex20);
    String hour21WeatherGif = getWeatherGif(nextIndex21);
    String hour22WeatherGif = getWeatherGif(nextIndex22);
    String hour23WeatherGif = getWeatherGif(nextIndex23);
    String hour24WeatherGif = getWeatherGif(nextIndex24);

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

              // Column(
              //   children: [
              //     //  TextButton(
              //     //    onPressed: () async {
              //     //      if (await getData()) {
              //     //        locationMessage =
              //     //            "Latitude: ${latitude.toString()}, Longitude: ${longitude.toString()}, City: $_city";
              //     //        debugPrint(
              //     //            "OutlinedButton from Homepage : $locationMessage");
              //     //        setState(() {
              //     //          locationMessage =
              //     //              "Latitude: ${latitude.toString()}, Longitude: ${longitude.toString()}, City: $_city";
              //     //          debugPrint(
              //     //              "OutlinedButton from Homepage : $locationMessage");
              //     //        });
              //     //      } else {
              //     //        debugPrint("hata buton0");
              //     //        setState(() {
              //     //          debugPrint("hata buton1");
              //     //          locationMessage = "Lokasyon verileri Hatalı";
              //     //          debugPrint("hata buton");
              //     //        });
              //     //      }
              //     //    },
              //     //    child: Text(
              //     //      "Konum Göster",
              //     //      style: TextStyle(fontSize: 40, color: Colors.white),
              //     //    ),
              //     //  ),
              //     Text(_cityName)
              //   ],
              // ),

              //City Name
              Text(
                _cityName ?? "boş",
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
                    "En Düşük: ${_userModel!.daily!.temperature2MMin![currentIndex].round()}°C",
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
                    "En Yüksek: ${_userModel!.daily!.temperature2MMax![currentIndex].round()}°C",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.oswald(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 35,
              ),
              //Hourly Part
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                child: Card(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    //Hourly Weather Top Container
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const SizedBox(
                            width: 12,
                          ),
                          ExpandableNotifier(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expandable(
                                  collapsed: ExpandableButton(
                                    child: Column(
                                      children: [
                                        Text(
                                          "Şu An",
                                          style: GoogleFonts.oswald(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                        Image.asset(currentHourWeatherGif),
                                        Text(
                                          "${_userModel!.hourly!.temperature2M![currentIndex].round()}°C",
                                          style: GoogleFonts.oswald(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  expanded: Row(
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            "Şu An",
                                            style: GoogleFonts.oswald(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          Image.asset(currentHourWeatherGif),
                                          Text(
                                            "${_userModel!.hourly!.temperature2M![currentIndex].round()}°C",
                                            style: GoogleFonts.oswald(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12.0),
                                        child: SizedBox(
                                          width: 200,
                                          height: 100,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                4, 2, 4, 2),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/hissedilensiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/hissedilenbeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Hissedilen Sıcaklık:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${_userModel!.hourly!.apparentTemperature![currentIndex].round()}°C",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/nemsiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/nembeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Nem:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "%${_userModel!.hourly!.relativehumidity2M![currentIndex]}",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/yagisolasiligisiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/yagisolasiligibeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Yağış Olasılığı:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "%${_userModel!.hourly!.precipitationProbability![currentIndex]}",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: ExpandableButton(
                                            child: const Icon(
                                                CupertinoIcons.chevron_left)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          ExpandableNotifier(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expandable(
                                    collapsed: ExpandableButton(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            nextHour1.toString(),
                                            style: GoogleFonts.oswald(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          Image.asset(hour1WeatherGif),
                                          Text(
                                            "${_userModel!.hourly!.temperature2M![nextIndex1].round()}°C",
                                            style: GoogleFonts.oswald(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    expanded: Row(
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              nextHour1.toString(),
                                              style: GoogleFonts.oswald(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                            Image.asset(hour1WeatherGif),
                                            Text(
                                              "${_userModel!.hourly!.temperature2M![nextIndex1].round()}°C",
                                              style: GoogleFonts.oswald(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 12.0),
                                          child: SizedBox(
                                            width: 200,
                                            height: 100,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      4, 2, 4, 2),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Image(
                                                        image: brightness ==
                                                                Brightness.light
                                                            ? const AssetImage(
                                                                "assets/images/hissedilensiyah.png")
                                                            : const AssetImage(
                                                                "assets/images/hissedilenbeyaz.png"),
                                                        width: 30,
                                                        fit: BoxFit.cover,
                                                      ),
                                                      Text(
                                                        "Hissedilen Sıcaklık:",
                                                        style:
                                                            GoogleFonts.oswald(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      Text(
                                                        "${_userModel!.hourly!.apparentTemperature![nextIndex1].round()}°C",
                                                        style:
                                                            GoogleFonts.oswald(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Image(
                                                        image: brightness ==
                                                                Brightness.light
                                                            ? const AssetImage(
                                                                "assets/images/nemsiyah.png")
                                                            : const AssetImage(
                                                                "assets/images/nembeyaz.png"),
                                                        width: 30,
                                                        fit: BoxFit.cover,
                                                      ),
                                                      Text(
                                                        "Nem:",
                                                        style:
                                                            GoogleFonts.oswald(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      Text(
                                                        "%${_userModel!.hourly!.relativehumidity2M![nextIndex1]}",
                                                        style:
                                                            GoogleFonts.oswald(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Image(
                                                        image: brightness ==
                                                                Brightness.light
                                                            ? const AssetImage(
                                                                "assets/images/yagisolasiligisiyah.png")
                                                            : const AssetImage(
                                                                "assets/images/yagisolasiligibeyaz.png"),
                                                        width: 30,
                                                        fit: BoxFit.cover,
                                                      ),
                                                      Text(
                                                        "Yağış Olasılığı:",
                                                        style:
                                                            GoogleFonts.oswald(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      Text(
                                                        "%${_userModel!.hourly!.precipitationProbability![nextIndex1]}",
                                                        style:
                                                            GoogleFonts.oswald(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: ExpandableButton(
                                              child: const Icon(
                                                  CupertinoIcons.chevron_left)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          ExpandableNotifier(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expandable(
                                    collapsed: ExpandableButton(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            nextHour2.toString(),
                                            style: GoogleFonts.oswald(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 20,
                                            ),
                                          ),
                                          Image.asset(hour2WeatherGif),
                                          Text(
                                            " ${_userModel!.hourly!.temperature2M![nextIndex2].round()}°C",
                                            style: GoogleFonts.oswald(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    expanded: Row(
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              nextHour2.toString(),
                                              style: GoogleFonts.oswald(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                            Image.asset(hour2WeatherGif),
                                            Text(
                                              "${_userModel!.hourly!.temperature2M![nextIndex2].round()}°C",
                                              style: GoogleFonts.oswald(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 12.0),
                                          child: SizedBox(
                                            width: 200,
                                            height: 100,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      4, 2, 4, 2),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Image(
                                                        image: brightness ==
                                                                Brightness.light
                                                            ? const AssetImage(
                                                                "assets/images/hissedilensiyah.png")
                                                            : const AssetImage(
                                                                "assets/images/hissedilenbeyaz.png"),
                                                        width: 30,
                                                        fit: BoxFit.cover,
                                                      ),
                                                      Text(
                                                        "Hissedilen Sıcaklık:",
                                                        style:
                                                            GoogleFonts.oswald(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      Text(
                                                        "${_userModel!.hourly!.apparentTemperature![nextIndex2].round()}°C",
                                                        style:
                                                            GoogleFonts.oswald(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Image(
                                                        image: brightness ==
                                                                Brightness.light
                                                            ? const AssetImage(
                                                                "assets/images/nemsiyah.png")
                                                            : const AssetImage(
                                                                "assets/images/nembeyaz.png"),
                                                        width: 30,
                                                        fit: BoxFit.cover,
                                                      ),
                                                      Text(
                                                        "Nem:",
                                                        style:
                                                            GoogleFonts.oswald(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      Text(
                                                        "%${_userModel!.hourly!.relativehumidity2M![nextIndex2]}",
                                                        style:
                                                            GoogleFonts.oswald(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Image(
                                                        image: brightness ==
                                                                Brightness.light
                                                            ? const AssetImage(
                                                                "assets/images/yagisolasiligisiyah.png")
                                                            : const AssetImage(
                                                                "assets/images/yagisolasiligibeyaz.png"),
                                                        width: 30,
                                                        fit: BoxFit.cover,
                                                      ),
                                                      Text(
                                                        "Yağış Olasılığı:",
                                                        style:
                                                            GoogleFonts.oswald(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      Text(
                                                        "%${_userModel!.hourly!.precipitationProbability![nextIndex2]}",
                                                        style:
                                                            GoogleFonts.oswald(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: ExpandableButton(
                                              child: const Icon(
                                                  CupertinoIcons.chevron_left)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          ExpandableNotifier(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expandable(
                                  collapsed: ExpandableButton(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          nextHour3.toString(),
                                          style: GoogleFonts.oswald(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 20,
                                          ),
                                        ),
                                        Image.asset(hour3WeatherGif),
                                        Text(
                                          " ${_userModel!.hourly!.temperature2M![nextIndex3].round()}°C",
                                          style: GoogleFonts.oswald(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  expanded: Row(
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            nextHour3.toString(),
                                            style: GoogleFonts.oswald(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          Image.asset(hour3WeatherGif),
                                          Text(
                                            "${_userModel!.hourly!.temperature2M![nextIndex3].round()}°C",
                                            style: GoogleFonts.oswald(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12.0),
                                        child: SizedBox(
                                          width: 200,
                                          height: 100,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                4, 2, 4, 2),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/hissedilensiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/hissedilenbeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Hissedilen Sıcaklık:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${_userModel!.hourly!.apparentTemperature![nextIndex3].round()}°C",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/nemsiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/nembeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Nem:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "%${_userModel!.hourly!.relativehumidity2M![nextIndex3]}",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/yagisolasiligisiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/yagisolasiligibeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Yağış Olasılığı:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "%${_userModel!.hourly!.precipitationProbability![nextIndex3]}",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: ExpandableButton(
                                            child: const Icon(
                                                CupertinoIcons.chevron_left)),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          ExpandableNotifier(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expandable(
                                  collapsed: ExpandableButton(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          nextHour4.toString(),
                                          style: GoogleFonts.oswald(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 20,
                                          ),
                                        ),
                                        Image.asset(hour4WeatherGif),
                                        Text(
                                          "${_userModel!.hourly!.temperature2M![nextIndex4].round()}°C",
                                          style: GoogleFonts.oswald(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  expanded: Row(
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            nextHour4.toString(),
                                            style: GoogleFonts.oswald(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          Image.asset(hour4WeatherGif),
                                          Text(
                                            "${_userModel!.hourly!.temperature2M![nextIndex4].round()}°C",
                                            style: GoogleFonts.oswald(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12.0),
                                        child: SizedBox(
                                          width: 200,
                                          height: 100,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                4, 2, 4, 2),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/hissedilensiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/hissedilenbeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Hissedilen Sıcaklık:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${_userModel!.hourly!.apparentTemperature![nextIndex4].round()}°C",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/nemsiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/nembeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Nem:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "%${_userModel!.hourly!.relativehumidity2M![nextIndex4]}",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/yagisolasiligisiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/yagisolasiligibeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Yağış Olasılığı:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "%${_userModel!.hourly!.precipitationProbability![nextIndex4]}",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: ExpandableButton(
                                            child: const Icon(
                                                CupertinoIcons.chevron_left)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          ExpandableNotifier(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expandable(
                                  collapsed: ExpandableButton(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          nextHour5.toString(),
                                          style: GoogleFonts.oswald(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 20,
                                          ),
                                        ),
                                        Image.asset(hour5WeatherGif),
                                        Text(
                                          "${_userModel!.hourly!.temperature2M![nextIndex5].round()}°C",
                                          style: GoogleFonts.oswald(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  expanded: Row(
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            nextHour5.toString(),
                                            style: GoogleFonts.oswald(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          Image.asset(hour5WeatherGif),
                                          Text(
                                            "${_userModel!.hourly!.temperature2M![nextIndex5].round()}°C",
                                            style: GoogleFonts.oswald(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12.0),
                                        child: SizedBox(
                                          width: 200,
                                          height: 100,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                4, 2, 4, 2),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/hissedilensiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/hissedilenbeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Hissedilen Sıcaklık:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${_userModel!.hourly!.apparentTemperature![nextIndex5].round()}°C",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/nemsiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/nembeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Nem:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "%${_userModel!.hourly!.relativehumidity2M![nextIndex5]}",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/yagisolasiligisiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/yagisolasiligibeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Yağış Olasılığı:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "%${_userModel!.hourly!.precipitationProbability![nextIndex5]}",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: ExpandableButton(
                                            child: const Icon(
                                                CupertinoIcons.chevron_left)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          ExpandableNotifier(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expandable(
                                  collapsed: ExpandableButton(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          nextHour6.toString(),
                                          style: GoogleFonts.oswald(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 20,
                                          ),
                                        ),
                                        Image.asset(hour6WeatherGif),
                                        Text(
                                          "${_userModel!.hourly!.temperature2M![nextIndex6].round()}°C",
                                          style: GoogleFonts.oswald(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  expanded: Row(
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            nextHour6.toString(),
                                            style: GoogleFonts.oswald(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          Image.asset(hour6WeatherGif),
                                          Text(
                                            "${_userModel!.hourly!.temperature2M![nextIndex6].round()}°C",
                                            style: GoogleFonts.oswald(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12.0),
                                        child: SizedBox(
                                          width: 200,
                                          height: 100,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                4, 2, 4, 2),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/hissedilensiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/hissedilenbeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Hissedilen Sıcaklık:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${_userModel!.hourly!.apparentTemperature![nextIndex6].round()}°C",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/nemsiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/nembeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Nem:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "%${_userModel!.hourly!.relativehumidity2M![nextIndex6]}",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/yagisolasiligisiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/yagisolasiligibeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Yağış Olasılığı:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "%${_userModel!.hourly!.precipitationProbability![nextIndex6]}",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: ExpandableButton(
                                            child: const Icon(
                                                CupertinoIcons.chevron_left)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          ExpandableNotifier(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expandable(
                                  collapsed: ExpandableButton(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          nextHour7.toString(),
                                          style: GoogleFonts.oswald(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 20,
                                          ),
                                        ),
                                        Image.asset(hour7WeatherGif),
                                        Text(
                                          "${_userModel!.hourly!.temperature2M![nextIndex7].round()}°C",
                                          style: GoogleFonts.oswald(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  expanded: Row(
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            nextHour7.toString(),
                                            style: GoogleFonts.oswald(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          Image.asset(hour7WeatherGif),
                                          Text(
                                            "${_userModel!.hourly!.temperature2M![nextIndex7].round()}°C",
                                            style: GoogleFonts.oswald(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12.0),
                                        child: SizedBox(
                                          width: 200,
                                          height: 100,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                4, 2, 4, 2),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/hissedilensiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/hissedilenbeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Hissedilen Sıcaklık:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${_userModel!.hourly!.apparentTemperature![nextIndex7].round()}°C",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/nemsiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/nembeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Nem:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "%${_userModel!.hourly!.relativehumidity2M![nextIndex7]}",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/yagisolasiligisiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/yagisolasiligibeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Yağış Olasılığı:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "%${_userModel!.hourly!.precipitationProbability![nextIndex7]}",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: ExpandableButton(
                                            child: const Icon(
                                                CupertinoIcons.chevron_left)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          ExpandableNotifier(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expandable(
                                  collapsed: ExpandableButton(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          nextHour8.toString(),
                                          style: GoogleFonts.oswald(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 20,
                                          ),
                                        ),
                                        Image.asset(hour8WeatherGif),
                                        Text(
                                          "${_userModel!.hourly!.temperature2M![nextIndex8].round()}°C",
                                          style: GoogleFonts.oswald(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  expanded: Row(
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            nextHour8.toString(),
                                            style: GoogleFonts.oswald(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          Image.asset(hour8WeatherGif),
                                          Text(
                                            "${_userModel!.hourly!.temperature2M![nextIndex8].round()}°C",
                                            style: GoogleFonts.oswald(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12.0),
                                        child: SizedBox(
                                          width: 200,
                                          height: 100,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                4, 2, 4, 2),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/hissedilensiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/hissedilenbeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Hissedilen Sıcaklık:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${_userModel!.hourly!.apparentTemperature![nextIndex8].round()}°C",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/nemsiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/nembeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Nem:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "%${_userModel!.hourly!.relativehumidity2M![nextIndex8]}",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/yagisolasiligisiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/yagisolasiligibeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Yağış Olasılığı:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "%${_userModel!.hourly!.precipitationProbability![nextIndex8]}",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: ExpandableButton(
                                            child: const Icon(
                                                CupertinoIcons.chevron_left)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          ExpandableNotifier(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expandable(
                                  collapsed: ExpandableButton(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          nextHour9.toString(),
                                          style: GoogleFonts.oswald(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 20,
                                          ),
                                        ),
                                        Image.asset(hour9WeatherGif),
                                        Text(
                                          "${_userModel!.hourly!.temperature2M![nextIndex9].round()}°C",
                                          style: GoogleFonts.oswald(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  expanded: Row(
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            nextHour9.toString(),
                                            style: GoogleFonts.oswald(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          Image.asset(hour9WeatherGif),
                                          Text(
                                            "${_userModel!.hourly!.temperature2M![nextIndex9].round()}°C",
                                            style: GoogleFonts.oswald(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12.0),
                                        child: SizedBox(
                                          width: 200,
                                          height: 100,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                4, 2, 4, 2),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/hissedilensiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/hissedilenbeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Hissedilen Sıcaklık:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${_userModel!.hourly!.apparentTemperature![nextIndex9].round()}°C",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/nemsiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/nembeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Nem:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "%${_userModel!.hourly!.relativehumidity2M![nextIndex9]}",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/yagisolasiligisiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/yagisolasiligibeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Yağış Olasılığı:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "%${_userModel!.hourly!.precipitationProbability![nextIndex9]}",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: ExpandableButton(
                                            child: const Icon(
                                                CupertinoIcons.chevron_left)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          ExpandableNotifier(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expandable(
                                  collapsed: ExpandableButton(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          nextHour10.toString(),
                                          style: GoogleFonts.oswald(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 20,
                                          ),
                                        ),
                                        Image.asset(hour10WeatherGif),
                                        Text(
                                          "${_userModel!.hourly!.temperature2M![nextIndex10].round()}°C",
                                          style: GoogleFonts.oswald(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  expanded: Row(
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            nextHour10.toString(),
                                            style: GoogleFonts.oswald(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          Image.asset(hour10WeatherGif),
                                          Text(
                                            "${_userModel!.hourly!.temperature2M![nextIndex10].round()}°C",
                                            style: GoogleFonts.oswald(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12.0),
                                        child: SizedBox(
                                          width: 200,
                                          height: 100,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                4, 2, 4, 2),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/hissedilensiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/hissedilenbeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Hissedilen Sıcaklık:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${_userModel!.hourly!.apparentTemperature![nextIndex10].round()}°C",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/nemsiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/nembeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Nem:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "%${_userModel!.hourly!.relativehumidity2M![nextIndex10]}",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/yagisolasiligisiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/yagisolasiligibeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Yağış Olasılığı:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "%${_userModel!.hourly!.precipitationProbability![nextIndex10]}",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: ExpandableButton(
                                            child: const Icon(
                                                CupertinoIcons.chevron_left)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          ExpandableNotifier(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expandable(
                                  collapsed: ExpandableButton(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          nextHour11.toString(),
                                          style: GoogleFonts.oswald(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 20,
                                          ),
                                        ),
                                        Image.asset(hour11WeatherGif),
                                        Text(
                                          "${_userModel!.hourly!.temperature2M![nextIndex11].round()}°C",
                                          style: GoogleFonts.oswald(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  expanded: Row(
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            nextHour11.toString(),
                                            style: GoogleFonts.oswald(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          Image.asset(hour11WeatherGif),
                                          Text(
                                            "${_userModel!.hourly!.temperature2M![nextIndex11].round()}°C",
                                            style: GoogleFonts.oswald(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12.0),
                                        child: SizedBox(
                                          width: 200,
                                          height: 100,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                4, 2, 4, 2),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/hissedilensiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/hissedilenbeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Hissedilen Sıcaklık:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${_userModel!.hourly!.apparentTemperature![nextIndex11].round()}°C",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/nemsiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/nembeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Nem:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "%${_userModel!.hourly!.relativehumidity2M![nextIndex11]}",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/yagisolasiligisiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/yagisolasiligibeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Yağış Olasılığı:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "%${_userModel!.hourly!.precipitationProbability![nextIndex11]}",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: ExpandableButton(
                                            child: const Icon(
                                                CupertinoIcons.chevron_left)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          ExpandableNotifier(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expandable(
                                  collapsed: ExpandableButton(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          nextHour12.toString(),
                                          style: GoogleFonts.oswald(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 20,
                                          ),
                                        ),
                                        Image.asset(hour12WeatherGif),
                                        Text(
                                          "${_userModel!.hourly!.temperature2M![nextIndex12].round()}°C",
                                          style: GoogleFonts.oswald(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  expanded: Row(
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            nextHour12.toString(),
                                            style: GoogleFonts.oswald(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          Image.asset(hour12WeatherGif),
                                          Text(
                                            "${_userModel!.hourly!.temperature2M![nextIndex12].round()}°C",
                                            style: GoogleFonts.oswald(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12.0),
                                        child: SizedBox(
                                          width: 200,
                                          height: 100,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                4, 2, 4, 2),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/hissedilensiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/hissedilenbeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Hissedilen Sıcaklık:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${_userModel!.hourly!.apparentTemperature![nextIndex12].round()}°C",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/nemsiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/nembeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Nem:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "%${_userModel!.hourly!.relativehumidity2M![nextIndex12]}",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/yagisolasiligisiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/yagisolasiligibeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Yağış Olasılığı:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "%${_userModel!.hourly!.precipitationProbability![nextIndex12]}",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: ExpandableButton(
                                            child: const Icon(
                                                CupertinoIcons.chevron_left)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          ExpandableNotifier(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expandable(
                                  collapsed: ExpandableButton(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          nextHour13.toString(),
                                          style: GoogleFonts.oswald(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 20,
                                          ),
                                        ),
                                        Image.asset(hour13WeatherGif),
                                        Text(
                                          "${_userModel!.hourly!.temperature2M![nextIndex13].round()}°C",
                                          style: GoogleFonts.oswald(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  expanded: Row(
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            nextHour13.toString(),
                                            style: GoogleFonts.oswald(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          Image.asset(hour13WeatherGif),
                                          Text(
                                            "${_userModel!.hourly!.temperature2M![nextIndex13].round()}°C",
                                            style: GoogleFonts.oswald(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12.0),
                                        child: SizedBox(
                                          width: 200,
                                          height: 100,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                4, 2, 4, 2),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/hissedilensiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/hissedilenbeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Hissedilen Sıcaklık:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${_userModel!.hourly!.apparentTemperature![nextIndex13].round()}°C",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/nemsiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/nembeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Nem:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "%${_userModel!.hourly!.relativehumidity2M![nextIndex13]}",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/yagisolasiligisiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/yagisolasiligibeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Yağış Olasılığı:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "%${_userModel!.hourly!.precipitationProbability![nextIndex13]}",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: ExpandableButton(
                                            child: const Icon(
                                                CupertinoIcons.chevron_left)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          ExpandableNotifier(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expandable(
                                  collapsed: ExpandableButton(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          nextHour14.toString(),
                                          style: GoogleFonts.oswald(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 20,
                                          ),
                                        ),
                                        Image.asset(hour14WeatherGif),
                                        Text(
                                          "${_userModel!.hourly!.temperature2M![nextIndex14].round()}°C",
                                          style: GoogleFonts.oswald(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  expanded: Row(
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            nextHour14.toString(),
                                            style: GoogleFonts.oswald(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          Image.asset(hour14WeatherGif),
                                          Text(
                                            "${_userModel!.hourly!.temperature2M![nextIndex14].round()}°C",
                                            style: GoogleFonts.oswald(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12.0),
                                        child: SizedBox(
                                          width: 200,
                                          height: 100,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                4, 2, 4, 2),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/hissedilensiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/hissedilenbeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Hissedilen Sıcaklık:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${_userModel!.hourly!.apparentTemperature![nextIndex14].round()}°C",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/nemsiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/nembeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Nem:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "%${_userModel!.hourly!.relativehumidity2M![nextIndex14]}",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/yagisolasiligisiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/yagisolasiligibeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Yağış Olasılığı:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "%${_userModel!.hourly!.precipitationProbability![nextIndex14]}",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: ExpandableButton(
                                            child: const Icon(
                                                CupertinoIcons.chevron_left)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          ExpandableNotifier(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expandable(
                                  collapsed: ExpandableButton(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          nextHour15.toString(),
                                          style: GoogleFonts.oswald(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 20,
                                          ),
                                        ),
                                        Image.asset(hour15WeatherGif),
                                        Text(
                                          "${_userModel!.hourly!.temperature2M![nextIndex15].round()}°C",
                                          style: GoogleFonts.oswald(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  expanded: Row(
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            nextHour15.toString(),
                                            style: GoogleFonts.oswald(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          Image.asset(hour15WeatherGif),
                                          Text(
                                            "${_userModel!.hourly!.temperature2M![nextIndex15].round()}°C",
                                            style: GoogleFonts.oswald(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12.0),
                                        child: SizedBox(
                                          width: 200,
                                          height: 100,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                4, 2, 4, 2),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/hissedilensiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/hissedilenbeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Hissedilen Sıcaklık:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${_userModel!.hourly!.apparentTemperature![nextIndex15].round()}°C",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/nemsiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/nembeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Nem:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "%${_userModel!.hourly!.relativehumidity2M![nextIndex15]}",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/yagisolasiligisiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/yagisolasiligibeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Yağış Olasılığı:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "%${_userModel!.hourly!.precipitationProbability![nextIndex15]}",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: ExpandableButton(
                                            child: const Icon(
                                                CupertinoIcons.chevron_left)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          ExpandableNotifier(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expandable(
                                  collapsed: ExpandableButton(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          nextHour16.toString(),
                                          style: GoogleFonts.oswald(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 20,
                                          ),
                                        ),
                                        Image.asset(hour16WeatherGif),
                                        Text(
                                          "${_userModel!.hourly!.temperature2M![nextIndex16].round()}°C",
                                          style: GoogleFonts.oswald(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  expanded: Row(
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            nextHour16.toString(),
                                            style: GoogleFonts.oswald(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          Image.asset(hour16WeatherGif),
                                          Text(
                                            "${_userModel!.hourly!.temperature2M![nextIndex16].round()}°C",
                                            style: GoogleFonts.oswald(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12.0),
                                        child: SizedBox(
                                          width: 200,
                                          height: 100,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                4, 2, 4, 2),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/hissedilensiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/hissedilenbeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Hissedilen Sıcaklık:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${_userModel!.hourly!.apparentTemperature![nextIndex16].round()}°C",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/nemsiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/nembeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Nem:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "%${_userModel!.hourly!.relativehumidity2M![nextIndex16]}",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/yagisolasiligisiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/yagisolasiligibeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Yağış Olasılığı:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "%${_userModel!.hourly!.precipitationProbability![nextIndex16]}",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: ExpandableButton(
                                            child: const Icon(
                                                CupertinoIcons.chevron_left)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          ExpandableNotifier(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expandable(
                                  collapsed: ExpandableButton(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          nextHour17.toString(),
                                          style: GoogleFonts.oswald(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 20,
                                          ),
                                        ),
                                        Image.asset(hour17WeatherGif),
                                        Text(
                                          "${_userModel!.hourly!.temperature2M![nextIndex17].round()}°C",
                                          style: GoogleFonts.oswald(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  expanded: Row(
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            nextHour17.toString(),
                                            style: GoogleFonts.oswald(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          Image.asset(hour17WeatherGif),
                                          Text(
                                            "${_userModel!.hourly!.temperature2M![nextIndex17].round()}°C",
                                            style: GoogleFonts.oswald(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12.0),
                                        child: SizedBox(
                                          width: 200,
                                          height: 100,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                4, 2, 4, 2),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/hissedilensiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/hissedilenbeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Hissedilen Sıcaklık:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${_userModel!.hourly!.apparentTemperature![nextIndex17].round()}°C",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/nemsiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/nembeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Nem:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "%${_userModel!.hourly!.relativehumidity2M![nextIndex17]}",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/yagisolasiligisiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/yagisolasiligibeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Yağış Olasılığı:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "%${_userModel!.hourly!.precipitationProbability![nextIndex17]}",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: ExpandableButton(
                                            child: const Icon(
                                                CupertinoIcons.chevron_left)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          ExpandableNotifier(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expandable(
                                  collapsed: ExpandableButton(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          nextHour18.toString(),
                                          style: GoogleFonts.oswald(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 20,
                                          ),
                                        ),
                                        Image.asset(hour18WeatherGif),
                                        Text(
                                          "${_userModel!.hourly!.temperature2M![nextIndex18].round()}°C",
                                          style: GoogleFonts.oswald(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  expanded: Row(
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            nextHour18.toString(),
                                            style: GoogleFonts.oswald(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          Image.asset(hour18WeatherGif),
                                          Text(
                                            "${_userModel!.hourly!.temperature2M![nextIndex18].round()}°C",
                                            style: GoogleFonts.oswald(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12.0),
                                        child: SizedBox(
                                          width: 200,
                                          height: 100,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                4, 2, 4, 2),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/hissedilensiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/hissedilenbeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Hissedilen Sıcaklık:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${_userModel!.hourly!.apparentTemperature![nextIndex18].round()}°C",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/nemsiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/nembeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Nem:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "%${_userModel!.hourly!.relativehumidity2M![nextIndex18]}",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/yagisolasiligisiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/yagisolasiligibeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Yağış Olasılığı:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "%${_userModel!.hourly!.precipitationProbability![nextIndex18]}",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: ExpandableButton(
                                            child: const Icon(
                                                CupertinoIcons.chevron_left)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          ExpandableNotifier(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expandable(
                                  collapsed: ExpandableButton(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          nextHour19.toString(),
                                          style: GoogleFonts.oswald(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 20,
                                          ),
                                        ),
                                        Image.asset(hour19WeatherGif),
                                        Text(
                                          "${_userModel!.hourly!.temperature2M![nextIndex19].round()}°C",
                                          style: GoogleFonts.oswald(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  expanded: Row(
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            nextHour19.toString(),
                                            style: GoogleFonts.oswald(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          Image.asset(hour19WeatherGif),
                                          Text(
                                            "${_userModel!.hourly!.temperature2M![nextIndex19].round()}°C",
                                            style: GoogleFonts.oswald(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12.0),
                                        child: SizedBox(
                                          width: 200,
                                          height: 100,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                4, 2, 4, 2),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/hissedilensiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/hissedilenbeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Hissedilen Sıcaklık:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${_userModel!.hourly!.apparentTemperature![nextIndex19].round()}°C",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/nemsiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/nembeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Nem:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "%${_userModel!.hourly!.relativehumidity2M![nextIndex19]}",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/yagisolasiligisiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/yagisolasiligibeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Yağış Olasılığı:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "%${_userModel!.hourly!.precipitationProbability![nextIndex19]}",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: ExpandableButton(
                                            child: const Icon(
                                                CupertinoIcons.chevron_left)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          ExpandableNotifier(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expandable(
                                  collapsed: ExpandableButton(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          nextHour20.toString(),
                                          style: GoogleFonts.oswald(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 20,
                                          ),
                                        ),
                                        Image.asset(hour20WeatherGif),
                                        Text(
                                          "${_userModel!.hourly!.temperature2M![nextIndex20].round()}°C",
                                          style: GoogleFonts.oswald(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  expanded: Row(
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            nextHour20.toString(),
                                            style: GoogleFonts.oswald(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          Image.asset(hour20WeatherGif),
                                          Text(
                                            "${_userModel!.hourly!.temperature2M![nextIndex20].round()}°C",
                                            style: GoogleFonts.oswald(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12.0),
                                        child: SizedBox(
                                          width: 200,
                                          height: 100,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                4, 2, 4, 2),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/hissedilensiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/hissedilenbeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Hissedilen Sıcaklık:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${_userModel!.hourly!.apparentTemperature![nextIndex20].round()}°C",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/nemsiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/nembeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Nem:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "%${_userModel!.hourly!.relativehumidity2M![nextIndex20]}",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/yagisolasiligisiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/yagisolasiligibeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Yağış Olasılığı:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "%${_userModel!.hourly!.precipitationProbability![nextIndex20]}",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: ExpandableButton(
                                            child: const Icon(
                                                CupertinoIcons.chevron_left)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          ExpandableNotifier(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expandable(
                                  collapsed: ExpandableButton(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          nextHour21.toString(),
                                          style: GoogleFonts.oswald(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 20,
                                          ),
                                        ),
                                        Image.asset(hour21WeatherGif),
                                        Text(
                                          "${_userModel!.hourly!.temperature2M![nextIndex21].round()}°C",
                                          style: GoogleFonts.oswald(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  expanded: Row(
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            nextHour21.toString(),
                                            style: GoogleFonts.oswald(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          Image.asset(hour21WeatherGif),
                                          Text(
                                            "${_userModel!.hourly!.temperature2M![nextIndex21].round()}°C",
                                            style: GoogleFonts.oswald(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12.0),
                                        child: SizedBox(
                                          width: 200,
                                          height: 100,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                4, 2, 4, 2),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/hissedilensiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/hissedilenbeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Hissedilen Sıcaklık:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${_userModel!.hourly!.apparentTemperature![nextIndex21].round()}°C",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/nemsiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/nembeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Nem:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "%${_userModel!.hourly!.relativehumidity2M![nextIndex21]}",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/yagisolasiligisiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/yagisolasiligibeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Yağış Olasılığı:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "%${_userModel!.hourly!.precipitationProbability![nextIndex21]}",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: ExpandableButton(
                                            child: const Icon(
                                                CupertinoIcons.chevron_left)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          ExpandableNotifier(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expandable(
                                  collapsed: ExpandableButton(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          nextHour22.toString(),
                                          style: GoogleFonts.oswald(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 20,
                                          ),
                                        ),
                                        Image.asset(hour22WeatherGif),
                                        Text(
                                          "${_userModel!.hourly!.temperature2M![nextIndex22].round()}°C",
                                          style: GoogleFonts.oswald(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  expanded: Row(
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            nextHour22.toString(),
                                            style: GoogleFonts.oswald(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          Image.asset(hour22WeatherGif),
                                          Text(
                                            "${_userModel!.hourly!.temperature2M![nextIndex22].round()}°C",
                                            style: GoogleFonts.oswald(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12.0),
                                        child: SizedBox(
                                          width: 200,
                                          height: 100,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                4, 2, 4, 2),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/hissedilensiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/hissedilenbeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Hissedilen Sıcaklık:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${_userModel!.hourly!.apparentTemperature![nextIndex22].round()}°C",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/nemsiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/nembeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Nem:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "%${_userModel!.hourly!.relativehumidity2M![nextIndex22]}",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/yagisolasiligisiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/yagisolasiligibeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Yağış Olasılığı:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "%${_userModel!.hourly!.precipitationProbability![nextIndex22]}",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: ExpandableButton(
                                            child: const Icon(
                                                CupertinoIcons.chevron_left)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          ExpandableNotifier(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expandable(
                                  collapsed: ExpandableButton(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          nextHour23.toString(),
                                          style: GoogleFonts.oswald(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 20,
                                          ),
                                        ),
                                        Image.asset(hour23WeatherGif),
                                        Text(
                                          "${_userModel!.hourly!.temperature2M![nextIndex23].round()}°C",
                                          style: GoogleFonts.oswald(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  expanded: Row(
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            nextHour23.toString(),
                                            style: GoogleFonts.oswald(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          Image.asset(hour23WeatherGif),
                                          Text(
                                            "${_userModel!.hourly!.temperature2M![nextIndex23].round()}°C",
                                            style: GoogleFonts.oswald(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12.0),
                                        child: SizedBox(
                                          width: 200,
                                          height: 100,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                4, 2, 4, 2),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/hissedilensiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/hissedilenbeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Hissedilen Sıcaklık:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${_userModel!.hourly!.apparentTemperature![nextIndex23].round()}°C",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/nemsiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/nembeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Nem:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "%${_userModel!.hourly!.relativehumidity2M![nextIndex23]}",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/yagisolasiligisiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/yagisolasiligibeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Yağış Olasılığı:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "%${_userModel!.hourly!.precipitationProbability![nextIndex23]}",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: ExpandableButton(
                                            child: const Icon(
                                                CupertinoIcons.chevron_left)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          ExpandableNotifier(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expandable(
                                  collapsed: ExpandableButton(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          nextHour24.toString(),
                                          style: GoogleFonts.oswald(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 20,
                                          ),
                                        ),
                                        Image.asset(hour24WeatherGif),
                                        Text(
                                          "${_userModel!.hourly!.temperature2M![nextIndex24].round()}°C",
                                          style: GoogleFonts.oswald(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  expanded: Row(
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            nextHour24.toString(),
                                            style: GoogleFonts.oswald(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          Image.asset(hour24WeatherGif),
                                          Text(
                                            "${_userModel!.hourly!.temperature2M![nextIndex24].round()}°C",
                                            style: GoogleFonts.oswald(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12.0),
                                        child: SizedBox(
                                          width: 200,
                                          height: 100,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                4, 2, 4, 2),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/hissedilensiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/hissedilenbeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Hissedilen Sıcaklık:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${_userModel!.hourly!.apparentTemperature![nextIndex24].round()}°C",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/nemsiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/nembeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Nem:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "%${_userModel!.hourly!.relativehumidity2M![nextIndex24]}",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image: brightness ==
                                                              Brightness.light
                                                          ? const AssetImage(
                                                              "assets/images/yagisolasiligisiyah.png")
                                                          : const AssetImage(
                                                              "assets/images/yagisolasiligibeyaz.png"),
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      "Yağış Olasılığı:",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "%${_userModel!.hourly!.precipitationProbability![nextIndex24]}",
                                                      style: GoogleFonts.oswald(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: ExpandableButton(
                                            child: const Icon(
                                                CupertinoIcons.chevron_left)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              //Daily Part
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                child: Card(
                  child: Expanded(
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: ExpandableNotifier(
                            child: Column(
                              children: [
                                Expandable(
                                  collapsed: ExpandableButton(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const SizedBox(width: 5),
                                        Expanded(
                                          child: Text(
                                            weekdayName,
                                            style: GoogleFonts.oswald(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                              fontWeight: FontWeight.w300,
                                              fontSize: 35,
                                            ),
                                          ),
                                        ),
                                        Image.asset(weatherGifMap[_userModel!
                                            .currentWeather!.weathercode]!),
                                        Expanded(
                                          child: Text(
                                            "${_userModel!.daily!.temperature2MMin![weekdayIndex].round()}°C",
                                            textAlign: TextAlign.end,
                                            style: GoogleFonts.oswald(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                              fontWeight: FontWeight.w300,
                                              fontSize: 35,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 12, left: 12.0),
                                          child: Container(
                                            width: 100,
                                            height: 5,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              gradient:
                                                  const LinearGradient(colors: [
                                                Color.fromARGB(
                                                    255, 178, 254, 250),
                                                Color.fromARGB(
                                                    255, 245, 175, 25),
                                                Color.fromARGB(255, 241, 39, 17)
                                              ]),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "${_userModel!.daily!.temperature2MMax![weekdayIndex].round()}°C",
                                          textAlign: TextAlign.end,
                                          style: GoogleFonts.oswald(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                            fontWeight: FontWeight.w300,
                                            fontSize: 35,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  expanded: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const SizedBox(width: 5),
                                          Expanded(
                                            child: Text(
                                              weekdayName,
                                              style: GoogleFonts.oswald(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface,
                                                fontWeight: FontWeight.w300,
                                                fontSize: 35,
                                              ),
                                            ),
                                          ),
                                          Image.asset(weatherGifMap[_userModel!
                                              .currentWeather!.weathercode]!),
                                          Expanded(
                                            child: Text(
                                              "${_userModel!.daily!.temperature2MMin![weekdayIndex].round()}°C",
                                              textAlign: TextAlign.end,
                                              style: GoogleFonts.oswald(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface,
                                                fontWeight: FontWeight.w300,
                                                fontSize: 35,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 12, left: 12.0),
                                            child: Container(
                                              width: 100,
                                              height: 5,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                gradient: const LinearGradient(
                                                    colors: [
                                                      Color.fromARGB(
                                                          255, 178, 254, 250),
                                                      Color.fromARGB(
                                                          255, 245, 175, 25),
                                                      Color.fromARGB(
                                                          255, 241, 39, 17)
                                                    ]),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "${_userModel!.daily!.temperature2MMax![weekdayIndex].round()}°C",
                                            textAlign: TextAlign.end,
                                            style: GoogleFonts.oswald(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                              fontWeight: FontWeight.w300,
                                              fontSize: 35,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Image(
                                                  image: brightness ==
                                                          Brightness.light
                                                      ? const AssetImage(
                                                          "assets/images/maxsicakliksiyah.png")
                                                      : const AssetImage(
                                                          "assets/images/maxsicaklikbeyaz.png"),
                                                  width: 35,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Maksimum Sıcaklık:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${_userModel!.daily!.temperature2MMax![weekdayIndex].round()}°C",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Image(
                                                  image: brightness ==
                                                          Brightness.light
                                                      ? const AssetImage(
                                                          "assets/images/minsicakliksiyah.png")
                                                      : const AssetImage(
                                                          "assets/images/minsicaklikbeyaz.png"),
                                                  width: 35,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Minimum Sıcaklık:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${_userModel!.daily!.temperature2MMin![weekdayIndex].round()}°C",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Image(
                                                  image: brightness ==
                                                          Brightness.light
                                                      ? const AssetImage(
                                                          "assets/images/yagisolasiligisiyah.png")
                                                      : const AssetImage(
                                                          "assets/images/yagisolasiligibeyaz.png"),
                                                  width: 35,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Yağış Olasılığı:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "%${_userModel!.daily!.precipitationProbabilityMax![weekdayIndex]}",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Image(
                                                  image: brightness ==
                                                          Brightness.light
                                                      ? const AssetImage(
                                                          "assets/images/ruzgarhizisiyah.png")
                                                      : const AssetImage(
                                                          "assets/images/ruzgarhizibeyaz.png"),
                                                  width: 35,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Maksimum Rüzgar Hızı:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${_userModel!.daily!.windspeed10MMax![weekdayIndex]} km/sa",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Image(
                                                  image: brightness ==
                                                          Brightness.light
                                                      ? const AssetImage(
                                                          "assets/images/ruzgaryonusiyah.png")
                                                      : const AssetImage(
                                                          "assets/images/ruzgaryonubeyaz.png"),
                                                  width: 35,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Hakim Rüzgar Yönü:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${_userModel!.daily!.winddirection10MDominant![weekdayIndex]}°",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: ExpandableButton(
                                                child: const Icon(
                                                    CupertinoIcons.chevron_up),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                            height: 10,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 7.0),
                              child: Divider(
                                  thickness: 1.5,
                                  color: brightness == Brightness.light
                                      ? Colors.black.withOpacity(0.4)
                                      : Colors.white.withOpacity(0.5)),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: ExpandableNotifier(
                            child: Column(
                              children: [
                                Expandable(
                                  collapsed: ExpandableButton(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const SizedBox(width: 5),
                                        Expanded(
                                          child: Text(
                                            nextDay1,
                                            style: GoogleFonts.oswald(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                              fontWeight: FontWeight.w300,
                                              fontSize: 35,
                                            ),
                                          ),
                                        ),
                                        Image.asset(weatherGifMap[_userModel!
                                            .currentWeather!.weathercode]!),
                                        Expanded(
                                          child: Text(
                                            "${_userModel!.daily!.temperature2MMin![nextDayIndex1].round()}°C",
                                            textAlign: TextAlign.end,
                                            style: GoogleFonts.oswald(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                              fontWeight: FontWeight.w300,
                                              fontSize: 35,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 12, left: 12.0),
                                          child: Container(
                                            width: 100,
                                            height: 5,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              gradient:
                                                  const LinearGradient(colors: [
                                                Color.fromARGB(
                                                    255, 178, 254, 250),
                                                Color.fromARGB(
                                                    255, 245, 175, 25),
                                                Color.fromARGB(255, 241, 39, 17)
                                              ]),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "${_userModel!.daily!.temperature2MMax![nextDayIndex1].round()}°C",
                                          textAlign: TextAlign.end,
                                          style: GoogleFonts.oswald(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                            fontWeight: FontWeight.w300,
                                            fontSize: 35,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  expanded: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const SizedBox(width: 5),
                                          Expanded(
                                            child: Text(
                                              nextDay1,
                                              style: GoogleFonts.oswald(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface,
                                                fontWeight: FontWeight.w300,
                                                fontSize: 35,
                                              ),
                                            ),
                                          ),
                                          Image.asset(weatherGifMap[_userModel!
                                              .currentWeather!.weathercode]!),
                                          Expanded(
                                            child: Text(
                                              "${_userModel!.daily!.temperature2MMin![nextDayIndex1].round()}°C",
                                              textAlign: TextAlign.end,
                                              style: GoogleFonts.oswald(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface,
                                                fontWeight: FontWeight.w300,
                                                fontSize: 35,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 12, left: 12.0),
                                            child: Container(
                                              width: 100,
                                              height: 5,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                gradient: const LinearGradient(
                                                    colors: [
                                                      Color.fromARGB(
                                                          255, 178, 254, 250),
                                                      Color.fromARGB(
                                                          255, 245, 175, 25),
                                                      Color.fromARGB(
                                                          255, 241, 39, 17)
                                                    ]),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "${_userModel!.daily!.temperature2MMax![nextDayIndex1].round()}°C",
                                            textAlign: TextAlign.end,
                                            style: GoogleFonts.oswald(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                              fontWeight: FontWeight.w300,
                                              fontSize: 35,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Image(
                                                  image: brightness ==
                                                          Brightness.light
                                                      ? const AssetImage(
                                                          "assets/images/maxsicakliksiyah.png")
                                                      : const AssetImage(
                                                          "assets/images/maxsicaklikbeyaz.png"),
                                                  width: 35,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Maksimum Sıcaklık:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${_userModel!.daily!.temperature2MMax![nextDayIndex1].round()}°C",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Image(
                                                  image: brightness ==
                                                          Brightness.light
                                                      ? const AssetImage(
                                                          "assets/images/minsicakliksiyah.png")
                                                      : const AssetImage(
                                                          "assets/images/minsicaklikbeyaz.png"),
                                                  width: 35,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Minimum Sıcaklık:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${_userModel!.daily!.temperature2MMin![nextDayIndex1].round()}°C",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Image(
                                                  image: brightness ==
                                                          Brightness.light
                                                      ? const AssetImage(
                                                          "assets/images/yagisolasiligisiyah.png")
                                                      : const AssetImage(
                                                          "assets/images/yagisolasiligibeyaz.png"),
                                                  width: 35,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Yağış Olasılığı:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "%${_userModel!.daily!.precipitationProbabilityMax![nextDayIndex1]}",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Image(
                                                  image: brightness ==
                                                          Brightness.light
                                                      ? const AssetImage(
                                                          "assets/images/ruzgarhizisiyah.png")
                                                      : const AssetImage(
                                                          "assets/images/ruzgarhizibeyaz.png"),
                                                  width: 35,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Maksimum Rüzgar Hızı:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${_userModel!.daily!.windspeed10MMax![nextDayIndex1]} km/sa",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Image(
                                                  image: brightness ==
                                                          Brightness.light
                                                      ? const AssetImage(
                                                          "assets/images/ruzgaryonusiyah.png")
                                                      : const AssetImage(
                                                          "assets/images/ruzgaryonubeyaz.png"),
                                                  width: 35,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Hakim Rüzgar Yönü:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${_userModel!.daily!.winddirection10MDominant![nextDayIndex1]}°",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: ExpandableButton(
                                                child: const Icon(
                                                    CupertinoIcons.chevron_up),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                            height: 10,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 7.0),
                              child: Divider(
                                  thickness: 1.5,
                                  color: brightness == Brightness.light
                                      ? Colors.black.withOpacity(0.4)
                                      : Colors.white.withOpacity(0.5)),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: ExpandableNotifier(
                            child: Column(
                              children: [
                                Expandable(
                                  collapsed: ExpandableButton(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const SizedBox(width: 5),
                                        Expanded(
                                          child: Text(
                                            nextDay2,
                                            style: GoogleFonts.oswald(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                              fontWeight: FontWeight.w300,
                                              fontSize: 35,
                                            ),
                                          ),
                                        ),
                                        Image.asset(weatherGifMap[_userModel!
                                            .currentWeather!.weathercode]!),
                                        Expanded(
                                          child: Text(
                                            "${_userModel!.daily!.temperature2MMin![nextDayIndex2].round()}°C",
                                            textAlign: TextAlign.end,
                                            style: GoogleFonts.oswald(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                              fontWeight: FontWeight.w300,
                                              fontSize: 35,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 12, left: 12.0),
                                          child: Container(
                                            width: 100,
                                            height: 5,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              gradient:
                                                  const LinearGradient(colors: [
                                                Color.fromARGB(
                                                    255, 178, 254, 250),
                                                Color.fromARGB(
                                                    255, 245, 175, 25),
                                                Color.fromARGB(255, 241, 39, 17)
                                              ]),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "${_userModel!.daily!.temperature2MMax![nextDayIndex2].round()}°C",
                                          textAlign: TextAlign.end,
                                          style: GoogleFonts.oswald(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                            fontWeight: FontWeight.w300,
                                            fontSize: 35,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  expanded: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const SizedBox(width: 5),
                                          Expanded(
                                            child: Text(
                                              nextDay2,
                                              style: GoogleFonts.oswald(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface,
                                                fontWeight: FontWeight.w300,
                                                fontSize: 35,
                                              ),
                                            ),
                                          ),
                                          Image.asset(weatherGifMap[_userModel!
                                              .currentWeather!.weathercode]!),
                                          Expanded(
                                            child: Text(
                                              "${_userModel!.daily!.temperature2MMin![nextDayIndex2].round()}°C",
                                              textAlign: TextAlign.end,
                                              style: GoogleFonts.oswald(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface,
                                                fontWeight: FontWeight.w300,
                                                fontSize: 35,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 12, left: 12.0),
                                            child: Container(
                                              width: 100,
                                              height: 5,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                gradient: const LinearGradient(
                                                    colors: [
                                                      Color.fromARGB(
                                                          255, 178, 254, 250),
                                                      Color.fromARGB(
                                                          255, 245, 175, 25),
                                                      Color.fromARGB(
                                                          255, 241, 39, 17)
                                                    ]),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "${_userModel!.daily!.temperature2MMax![nextDayIndex2].round()}°C",
                                            textAlign: TextAlign.end,
                                            style: GoogleFonts.oswald(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                              fontWeight: FontWeight.w300,
                                              fontSize: 35,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Image(
                                                  image: brightness ==
                                                          Brightness.light
                                                      ? const AssetImage(
                                                          "assets/images/maxsicakliksiyah.png")
                                                      : const AssetImage(
                                                          "assets/images/maxsicaklikbeyaz.png"),
                                                  width: 35,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Maksimum Sıcaklık:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${_userModel!.daily!.temperature2MMax![nextDayIndex2].round()}°C",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Image(
                                                  image: brightness ==
                                                          Brightness.light
                                                      ? const AssetImage(
                                                          "assets/images/minsicakliksiyah.png")
                                                      : const AssetImage(
                                                          "assets/images/minsicaklikbeyaz.png"),
                                                  width: 35,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Minimum Sıcaklık:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${_userModel!.daily!.temperature2MMin![nextDayIndex2].round()}°C",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Image(
                                                  image: brightness ==
                                                          Brightness.light
                                                      ? const AssetImage(
                                                          "assets/images/yagisolasiligisiyah.png")
                                                      : const AssetImage(
                                                          "assets/images/yagisolasiligibeyaz.png"),
                                                  width: 35,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Yağış Olasılığı:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "%${_userModel!.daily!.precipitationProbabilityMax![nextDayIndex2]}",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Image(
                                                  image: brightness ==
                                                          Brightness.light
                                                      ? const AssetImage(
                                                          "assets/images/ruzgarhizisiyah.png")
                                                      : const AssetImage(
                                                          "assets/images/ruzgarhizibeyaz.png"),
                                                  width: 35,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Maksimum Rüzgar Hızı:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${_userModel!.daily!.windspeed10MMax![nextDayIndex2]} km/sa",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Image(
                                                  image: brightness ==
                                                          Brightness.light
                                                      ? const AssetImage(
                                                          "assets/images/ruzgaryonusiyah.png")
                                                      : const AssetImage(
                                                          "assets/images/ruzgaryonubeyaz.png"),
                                                  width: 35,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Hakim Rüzgar Yönü:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${_userModel!.daily!.winddirection10MDominant![nextDayIndex2]}°",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: ExpandableButton(
                                                child: const Icon(
                                                    CupertinoIcons.chevron_up),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                            height: 10,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 7.0),
                              child: Divider(
                                  thickness: 1.5,
                                  color: brightness == Brightness.light
                                      ? Colors.black.withOpacity(0.4)
                                      : Colors.white.withOpacity(0.5)),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: ExpandableNotifier(
                            child: Column(
                              children: [
                                Expandable(
                                  collapsed: ExpandableButton(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const SizedBox(width: 5),
                                        Expanded(
                                          child: Text(
                                            nextDay3,
                                            style: GoogleFonts.oswald(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                              fontWeight: FontWeight.w300,
                                              fontSize: 35,
                                            ),
                                          ),
                                        ),
                                        Image.asset(weatherGifMap[_userModel!
                                            .currentWeather!.weathercode]!),
                                        Expanded(
                                          child: Text(
                                            "${_userModel!.daily!.temperature2MMin![nextDayIndex3].round()}°C",
                                            textAlign: TextAlign.end,
                                            style: GoogleFonts.oswald(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                              fontWeight: FontWeight.w300,
                                              fontSize: 35,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 12, left: 12.0),
                                          child: Container(
                                            width: 100,
                                            height: 5,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              gradient:
                                                  const LinearGradient(colors: [
                                                Color.fromARGB(
                                                    255, 178, 254, 250),
                                                Color.fromARGB(
                                                    255, 245, 175, 25),
                                                Color.fromARGB(255, 241, 39, 17)
                                              ]),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "${_userModel!.daily!.temperature2MMax![nextDayIndex3].round()}°C",
                                          textAlign: TextAlign.end,
                                          style: GoogleFonts.oswald(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                            fontWeight: FontWeight.w300,
                                            fontSize: 35,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  expanded: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const SizedBox(width: 5),
                                          Expanded(
                                            child: Text(
                                              nextDay3,
                                              style: GoogleFonts.oswald(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface,
                                                fontWeight: FontWeight.w300,
                                                fontSize: 35,
                                              ),
                                            ),
                                          ),
                                          Image.asset(weatherGifMap[_userModel!
                                              .currentWeather!.weathercode]!),
                                          Expanded(
                                            child: Text(
                                              "${_userModel!.daily!.temperature2MMin![nextDayIndex3].round()}°C",
                                              textAlign: TextAlign.end,
                                              style: GoogleFonts.oswald(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface,
                                                fontWeight: FontWeight.w300,
                                                fontSize: 35,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 12, left: 12.0),
                                            child: Container(
                                              width: 100,
                                              height: 5,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                gradient: const LinearGradient(
                                                    colors: [
                                                      Color.fromARGB(
                                                          255, 178, 254, 250),
                                                      Color.fromARGB(
                                                          255, 245, 175, 25),
                                                      Color.fromARGB(
                                                          255, 241, 39, 17)
                                                    ]),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "${_userModel!.daily!.temperature2MMax![nextDayIndex3].round()}°C",
                                            textAlign: TextAlign.end,
                                            style: GoogleFonts.oswald(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                              fontWeight: FontWeight.w300,
                                              fontSize: 35,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Image(
                                                  image: brightness ==
                                                          Brightness.light
                                                      ? const AssetImage(
                                                          "assets/images/maxsicakliksiyah.png")
                                                      : const AssetImage(
                                                          "assets/images/maxsicaklikbeyaz.png"),
                                                  width: 35,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Maksimum Sıcaklık:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${_userModel!.daily!.temperature2MMax![nextDayIndex3].round()}°C",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Image(
                                                  image: brightness ==
                                                          Brightness.light
                                                      ? const AssetImage(
                                                          "assets/images/minsicakliksiyah.png")
                                                      : const AssetImage(
                                                          "assets/images/minsicaklikbeyaz.png"),
                                                  width: 35,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Minimum Sıcaklık:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${_userModel!.daily!.temperature2MMin![nextDayIndex3].round()}°C",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Image(
                                                  image: brightness ==
                                                          Brightness.light
                                                      ? const AssetImage(
                                                          "assets/images/yagisolasiligisiyah.png")
                                                      : const AssetImage(
                                                          "assets/images/yagisolasiligibeyaz.png"),
                                                  width: 35,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Yağış Olasılığı:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "%${_userModel!.daily!.precipitationProbabilityMax![nextDayIndex3]}",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Image(
                                                  image: brightness ==
                                                          Brightness.light
                                                      ? const AssetImage(
                                                          "assets/images/ruzgarhizisiyah.png")
                                                      : const AssetImage(
                                                          "assets/images/ruzgarhizibeyaz.png"),
                                                  width: 35,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Maksimum Rüzgar Hızı:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${_userModel!.daily!.windspeed10MMax![nextDayIndex3]} km/sa",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Image(
                                                  image: brightness ==
                                                          Brightness.light
                                                      ? const AssetImage(
                                                          "assets/images/ruzgaryonusiyah.png")
                                                      : const AssetImage(
                                                          "assets/images/ruzgaryonubeyaz.png"),
                                                  width: 35,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Hakim Rüzgar Yönü:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${_userModel!.daily!.winddirection10MDominant![nextDayIndex3]}°",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: ExpandableButton(
                                                child: const Icon(
                                                    CupertinoIcons.chevron_up),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                            height: 10,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 7.0),
                              child: Divider(
                                  thickness: 1.5,
                                  color: brightness == Brightness.light
                                      ? Colors.black.withOpacity(0.4)
                                      : Colors.white.withOpacity(0.5)),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: ExpandableNotifier(
                            child: Column(
                              children: [
                                Expandable(
                                  collapsed: ExpandableButton(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const SizedBox(width: 5),
                                        Expanded(
                                          child: Text(
                                            nextDay4,
                                            style: GoogleFonts.oswald(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                              fontWeight: FontWeight.w300,
                                              fontSize: 35,
                                            ),
                                          ),
                                        ),
                                        Image.asset(weatherGifMap[_userModel!
                                            .currentWeather!.weathercode]!),
                                        Expanded(
                                          child: Text(
                                            "${_userModel!.daily!.temperature2MMin![nextDayIndex4].round()}°C",
                                            textAlign: TextAlign.end,
                                            style: GoogleFonts.oswald(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                              fontWeight: FontWeight.w300,
                                              fontSize: 35,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 12, left: 12.0),
                                          child: Container(
                                            width: 100,
                                            height: 5,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              gradient:
                                                  const LinearGradient(colors: [
                                                Color.fromARGB(
                                                    255, 178, 254, 250),
                                                Color.fromARGB(
                                                    255, 245, 175, 25),
                                                Color.fromARGB(255, 241, 39, 17)
                                              ]),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "${_userModel!.daily!.temperature2MMax![nextDayIndex4].round()}°C",
                                          textAlign: TextAlign.end,
                                          style: GoogleFonts.oswald(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                            fontWeight: FontWeight.w300,
                                            fontSize: 35,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  expanded: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const SizedBox(width: 5),
                                          Expanded(
                                            child: Text(
                                              nextDay4,
                                              style: GoogleFonts.oswald(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface,
                                                fontWeight: FontWeight.w300,
                                                fontSize: 35,
                                              ),
                                            ),
                                          ),
                                          Image.asset(weatherGifMap[_userModel!
                                              .currentWeather!.weathercode]!),
                                          Expanded(
                                            child: Text(
                                              "${_userModel!.daily!.temperature2MMin![nextDayIndex4].round()}°C",
                                              textAlign: TextAlign.end,
                                              style: GoogleFonts.oswald(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface,
                                                fontWeight: FontWeight.w300,
                                                fontSize: 35,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 12, left: 12.0),
                                            child: Container(
                                              width: 100,
                                              height: 5,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                gradient: const LinearGradient(
                                                    colors: [
                                                      Color.fromARGB(
                                                          255, 178, 254, 250),
                                                      Color.fromARGB(
                                                          255, 245, 175, 25),
                                                      Color.fromARGB(
                                                          255, 241, 39, 17)
                                                    ]),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "${_userModel!.daily!.temperature2MMax![nextDayIndex4].round()}°C",
                                            textAlign: TextAlign.end,
                                            style: GoogleFonts.oswald(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                              fontWeight: FontWeight.w300,
                                              fontSize: 35,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Image(
                                                  image: brightness ==
                                                          Brightness.light
                                                      ? const AssetImage(
                                                          "assets/images/maxsicakliksiyah.png")
                                                      : const AssetImage(
                                                          "assets/images/maxsicaklikbeyaz.png"),
                                                  width: 35,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Maksimum Sıcaklık:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${_userModel!.daily!.temperature2MMax![nextDayIndex4].round()}°C",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Image(
                                                  image: brightness ==
                                                          Brightness.light
                                                      ? const AssetImage(
                                                          "assets/images/minsicakliksiyah.png")
                                                      : const AssetImage(
                                                          "assets/images/minsicaklikbeyaz.png"),
                                                  width: 35,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Minimum Sıcaklık:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${_userModel!.daily!.temperature2MMin![nextDayIndex4].round()}°C",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Image(
                                                  image: brightness ==
                                                          Brightness.light
                                                      ? const AssetImage(
                                                          "assets/images/yagisolasiligisiyah.png")
                                                      : const AssetImage(
                                                          "assets/images/yagisolasiligibeyaz.png"),
                                                  width: 35,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Yağış Olasılığı:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "%${_userModel!.daily!.precipitationProbabilityMax![nextDayIndex4]}",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Image(
                                                  image: brightness ==
                                                          Brightness.light
                                                      ? const AssetImage(
                                                          "assets/images/ruzgarhizisiyah.png")
                                                      : const AssetImage(
                                                          "assets/images/ruzgarhizibeyaz.png"),
                                                  width: 35,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Maksimum Rüzgar Hızı:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${_userModel!.daily!.windspeed10MMax![nextDayIndex4]} km/sa",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Image(
                                                  image: brightness ==
                                                          Brightness.light
                                                      ? const AssetImage(
                                                          "assets/images/ruzgaryonusiyah.png")
                                                      : const AssetImage(
                                                          "assets/images/ruzgaryonubeyaz.png"),
                                                  width: 35,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Hakim Rüzgar Yönü:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${_userModel!.daily!.winddirection10MDominant![nextDayIndex4]}°",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: ExpandableButton(
                                                child: const Icon(
                                                    CupertinoIcons.chevron_up),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                            height: 10,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 7.0),
                              child: Divider(
                                  thickness: 1.5,
                                  color: brightness == Brightness.light
                                      ? Colors.black.withOpacity(0.4)
                                      : Colors.white.withOpacity(0.5)),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: ExpandableNotifier(
                            child: Column(
                              children: [
                                Expandable(
                                  collapsed: ExpandableButton(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const SizedBox(width: 5),
                                        Expanded(
                                          child: Text(
                                            nextDay5,
                                            style: GoogleFonts.oswald(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                              fontWeight: FontWeight.w300,
                                              fontSize: 35,
                                            ),
                                          ),
                                        ),
                                        Image.asset(weatherGifMap[_userModel!
                                            .currentWeather!.weathercode]!),
                                        Expanded(
                                          child: Text(
                                            "${_userModel!.daily!.temperature2MMin![nextDayIndex5].round()}°C",
                                            textAlign: TextAlign.end,
                                            style: GoogleFonts.oswald(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                              fontWeight: FontWeight.w300,
                                              fontSize: 35,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 12, left: 12.0),
                                          child: Container(
                                            width: 100,
                                            height: 5,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              gradient:
                                                  const LinearGradient(colors: [
                                                Color.fromARGB(
                                                    255, 178, 254, 250),
                                                Color.fromARGB(
                                                    255, 245, 175, 25),
                                                Color.fromARGB(255, 241, 39, 17)
                                              ]),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "${_userModel!.daily!.temperature2MMax![nextDayIndex5].round()}°C",
                                          textAlign: TextAlign.end,
                                          style: GoogleFonts.oswald(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                            fontWeight: FontWeight.w300,
                                            fontSize: 35,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  expanded: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const SizedBox(width: 5),
                                          Expanded(
                                            child: Text(
                                              nextDay5,
                                              style: GoogleFonts.oswald(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface,
                                                fontWeight: FontWeight.w300,
                                                fontSize: 35,
                                              ),
                                            ),
                                          ),
                                          Image.asset(weatherGifMap[_userModel!
                                              .currentWeather!.weathercode]!),
                                          Expanded(
                                            child: Text(
                                              "${_userModel!.daily!.temperature2MMin![nextDayIndex5].round()}°C",
                                              textAlign: TextAlign.end,
                                              style: GoogleFonts.oswald(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface,
                                                fontWeight: FontWeight.w300,
                                                fontSize: 35,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 12, left: 12.0),
                                            child: Container(
                                              width: 100,
                                              height: 5,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                gradient: const LinearGradient(
                                                    colors: [
                                                      Color.fromARGB(
                                                          255, 178, 254, 250),
                                                      Color.fromARGB(
                                                          255, 245, 175, 25),
                                                      Color.fromARGB(
                                                          255, 241, 39, 17)
                                                    ]),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "${_userModel!.daily!.temperature2MMax![nextDayIndex5].round()}°C",
                                            textAlign: TextAlign.end,
                                            style: GoogleFonts.oswald(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                              fontWeight: FontWeight.w300,
                                              fontSize: 35,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Image(
                                                  image: brightness ==
                                                          Brightness.light
                                                      ? const AssetImage(
                                                          "assets/images/maxsicakliksiyah.png")
                                                      : const AssetImage(
                                                          "assets/images/maxsicaklikbeyaz.png"),
                                                  width: 35,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Maksimum Sıcaklık:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${_userModel!.daily!.temperature2MMax![nextDayIndex5].round()}°C",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Image(
                                                  image: brightness ==
                                                          Brightness.light
                                                      ? const AssetImage(
                                                          "assets/images/minsicakliksiyah.png")
                                                      : const AssetImage(
                                                          "assets/images/minsicaklikbeyaz.png"),
                                                  width: 35,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Minimum Sıcaklık:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${_userModel!.daily!.temperature2MMin![nextDayIndex5].round()}°C",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Image(
                                                  image: brightness ==
                                                          Brightness.light
                                                      ? const AssetImage(
                                                          "assets/images/yagisolasiligisiyah.png")
                                                      : const AssetImage(
                                                          "assets/images/yagisolasiligibeyaz.png"),
                                                  width: 35,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Yağış Olasılığı:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "%${_userModel!.daily!.precipitationProbabilityMax![nextDayIndex5]}",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Image(
                                                  image: brightness ==
                                                          Brightness.light
                                                      ? const AssetImage(
                                                          "assets/images/ruzgarhizisiyah.png")
                                                      : const AssetImage(
                                                          "assets/images/ruzgarhizibeyaz.png"),
                                                  width: 35,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Maksimum Rüzgar Hızı:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${_userModel!.daily!.windspeed10MMax![nextDayIndex5]} km/sa",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Image(
                                                  image: brightness ==
                                                          Brightness.light
                                                      ? const AssetImage(
                                                          "assets/images/ruzgaryonusiyah.png")
                                                      : const AssetImage(
                                                          "assets/images/ruzgaryonubeyaz.png"),
                                                  width: 35,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Hakim Rüzgar Yönü:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${_userModel!.daily!.winddirection10MDominant![nextDayIndex5]}°",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: ExpandableButton(
                                                child: const Icon(
                                                    CupertinoIcons.chevron_up),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                            height: 10,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 7.0),
                              child: Divider(
                                  thickness: 1.5,
                                  color: brightness == Brightness.light
                                      ? Colors.black.withOpacity(0.4)
                                      : Colors.white.withOpacity(0.5)),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: ExpandableNotifier(
                            child: Column(
                              children: [
                                Expandable(
                                  collapsed: ExpandableButton(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const SizedBox(width: 5),
                                        Expanded(
                                          child: Text(
                                            nextDay6,
                                            style: GoogleFonts.oswald(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                              fontWeight: FontWeight.w300,
                                              fontSize: 35,
                                            ),
                                          ),
                                        ),
                                        Image.asset(weatherGifMap[_userModel!
                                            .currentWeather!.weathercode]!),
                                        Expanded(
                                          child: Text(
                                            "${_userModel!.daily!.temperature2MMin![nextDayIndex6].round()}°C",
                                            textAlign: TextAlign.end,
                                            style: GoogleFonts.oswald(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                              fontWeight: FontWeight.w300,
                                              fontSize: 35,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 12, left: 12.0),
                                          child: Container(
                                            width: 100,
                                            height: 5,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              gradient:
                                                  const LinearGradient(colors: [
                                                Color.fromARGB(
                                                    255, 178, 254, 250),
                                                Color.fromARGB(
                                                    255, 245, 175, 25),
                                                Color.fromARGB(255, 241, 39, 17)
                                              ]),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "${_userModel!.daily!.temperature2MMax![nextDayIndex6].round()}°C",
                                          textAlign: TextAlign.end,
                                          style: GoogleFonts.oswald(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                            fontWeight: FontWeight.w300,
                                            fontSize: 35,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  expanded: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const SizedBox(width: 5),
                                          Expanded(
                                            child: Text(
                                              nextDay6,
                                              style: GoogleFonts.oswald(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface,
                                                fontWeight: FontWeight.w300,
                                                fontSize: 35,
                                              ),
                                            ),
                                          ),
                                          Image.asset(weatherGifMap[_userModel!
                                              .currentWeather!.weathercode]!),
                                          Expanded(
                                            child: Text(
                                              "${_userModel!.daily!.temperature2MMin![nextDayIndex6].round()}°C",
                                              textAlign: TextAlign.end,
                                              style: GoogleFonts.oswald(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface,
                                                fontWeight: FontWeight.w300,
                                                fontSize: 35,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 12, left: 12.0),
                                            child: Container(
                                              width: 100,
                                              height: 5,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                gradient: const LinearGradient(
                                                    colors: [
                                                      Color.fromARGB(
                                                          255, 178, 254, 250),
                                                      Color.fromARGB(
                                                          255, 245, 175, 25),
                                                      Color.fromARGB(
                                                          255, 241, 39, 17)
                                                    ]),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "${_userModel!.daily!.temperature2MMax![nextDayIndex6].round()}°C",
                                            textAlign: TextAlign.end,
                                            style: GoogleFonts.oswald(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                              fontWeight: FontWeight.w300,
                                              fontSize: 35,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Image(
                                                  image: brightness ==
                                                          Brightness.light
                                                      ? const AssetImage(
                                                          "assets/images/maxsicakliksiyah.png")
                                                      : const AssetImage(
                                                          "assets/images/maxsicaklikbeyaz.png"),
                                                  width: 35,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Maksimum Sıcaklık:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${_userModel!.daily!.temperature2MMax![nextDayIndex6].round()}°C",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Image(
                                                  image: brightness ==
                                                          Brightness.light
                                                      ? const AssetImage(
                                                          "assets/images/minsicakliksiyah.png")
                                                      : const AssetImage(
                                                          "assets/images/minsicaklikbeyaz.png"),
                                                  width: 35,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Minimum Sıcaklık:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${_userModel!.daily!.temperature2MMin![nextDayIndex6].round()}°C",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Image(
                                                  image: brightness ==
                                                          Brightness.light
                                                      ? const AssetImage(
                                                          "assets/images/yagisolasiligisiyah.png")
                                                      : const AssetImage(
                                                          "assets/images/yagisolasiligibeyaz.png"),
                                                  width: 35,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Yağış Olasılığı:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "%${_userModel!.daily!.precipitationProbabilityMax![nextDayIndex6]}",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Image(
                                                  image: brightness ==
                                                          Brightness.light
                                                      ? const AssetImage(
                                                          "assets/images/ruzgarhizisiyah.png")
                                                      : const AssetImage(
                                                          "assets/images/ruzgarhizibeyaz.png"),
                                                  width: 35,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Maksimum Rüzgar Hızı:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${_userModel!.daily!.windspeed10MMax![nextDayIndex6]} km/sa",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Image(
                                                  image: brightness ==
                                                          Brightness.light
                                                      ? const AssetImage(
                                                          "assets/images/ruzgaryonusiyah.png")
                                                      : const AssetImage(
                                                          "assets/images/ruzgaryonubeyaz.png"),
                                                  width: 35,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Hakim Rüzgar Yönü:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${_userModel!.daily!.winddirection10MDominant![nextDayIndex6]}°",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: ExpandableButton(
                                                child: const Icon(
                                                    CupertinoIcons.chevron_up),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                            height: 10,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 7.0),
                              child: Divider(
                                  thickness: 1.5,
                                  color: brightness == Brightness.light
                                      ? Colors.black.withOpacity(0.4)
                                      : Colors.white.withOpacity(0.5)),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: ExpandableNotifier(
                            child: Column(
                              children: [
                                Expandable(
                                  collapsed: ExpandableButton(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const SizedBox(width: 5),
                                        Expanded(
                                          child: Text(
                                            nextDay7,
                                            style: GoogleFonts.oswald(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                              fontWeight: FontWeight.w300,
                                              fontSize: 35,
                                            ),
                                          ),
                                        ),
                                        Image.asset(weatherGifMap[_userModel!
                                            .currentWeather!.weathercode]!),
                                        Expanded(
                                          child: Text(
                                            "${_userModel!.daily!.temperature2MMin![nextDayIndex7].round()}°C",
                                            textAlign: TextAlign.end,
                                            style: GoogleFonts.oswald(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                              fontWeight: FontWeight.w300,
                                              fontSize: 35,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 12, left: 12.0),
                                          child: Container(
                                            width: 100,
                                            height: 5,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              gradient:
                                                  const LinearGradient(colors: [
                                                Color.fromARGB(
                                                    255, 178, 254, 250),
                                                Color.fromARGB(
                                                    255, 245, 175, 25),
                                                Color.fromARGB(255, 241, 39, 17)
                                              ]),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "${_userModel!.daily!.temperature2MMax![nextDayIndex7].round()}°C",
                                          textAlign: TextAlign.end,
                                          style: GoogleFonts.oswald(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                            fontWeight: FontWeight.w300,
                                            fontSize: 35,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  expanded: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const SizedBox(width: 5),
                                          Expanded(
                                            child: Text(
                                              nextDay7,
                                              style: GoogleFonts.oswald(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface,
                                                fontWeight: FontWeight.w300,
                                                fontSize: 35,
                                              ),
                                            ),
                                          ),
                                          Image.asset(weatherGifMap[_userModel!
                                              .currentWeather!.weathercode]!),
                                          Expanded(
                                            child: Text(
                                              "${_userModel!.daily!.temperature2MMin![nextDayIndex7].round()}°C",
                                              textAlign: TextAlign.end,
                                              style: GoogleFonts.oswald(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface,
                                                fontWeight: FontWeight.w300,
                                                fontSize: 35,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 12, left: 12.0),
                                            child: Container(
                                              width: 100,
                                              height: 5,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                gradient: const LinearGradient(
                                                    colors: [
                                                      Color.fromARGB(
                                                          255, 178, 254, 250),
                                                      Color.fromARGB(
                                                          255, 245, 175, 25),
                                                      Color.fromARGB(
                                                          255, 241, 39, 17)
                                                    ]),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "${_userModel!.daily!.temperature2MMax![nextDayIndex7].round()}°C",
                                            textAlign: TextAlign.end,
                                            style: GoogleFonts.oswald(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                              fontWeight: FontWeight.w300,
                                              fontSize: 35,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Image(
                                                  image: brightness ==
                                                          Brightness.light
                                                      ? const AssetImage(
                                                          "assets/images/maxsicakliksiyah.png")
                                                      : const AssetImage(
                                                          "assets/images/maxsicaklikbeyaz.png"),
                                                  width: 35,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Maksimum Sıcaklık:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${_userModel!.daily!.temperature2MMax![nextDayIndex7].round()}°C",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Image(
                                                  image: brightness ==
                                                          Brightness.light
                                                      ? const AssetImage(
                                                          "assets/images/minsicakliksiyah.png")
                                                      : const AssetImage(
                                                          "assets/images/minsicaklikbeyaz.png"),
                                                  width: 35,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Minimum Sıcaklık:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${_userModel!.daily!.temperature2MMin![nextDayIndex7].round()}°C",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Image(
                                                  image: brightness ==
                                                          Brightness.light
                                                      ? const AssetImage(
                                                          "assets/images/yagisolasiligisiyah.png")
                                                      : const AssetImage(
                                                          "assets/images/yagisolasiligibeyaz.png"),
                                                  width: 35,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Yağış Olasılığı:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "%${_userModel!.daily!.precipitationProbabilityMax![nextDayIndex7]}",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Image(
                                                  image: brightness ==
                                                          Brightness.light
                                                      ? const AssetImage(
                                                          "assets/images/ruzgarhizisiyah.png")
                                                      : const AssetImage(
                                                          "assets/images/ruzgarhizibeyaz.png"),
                                                  width: 35,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Maksimum Rüzgar Hızı:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${_userModel!.daily!.windspeed10MMax![nextDayIndex7]} km/sa",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Image(
                                                  image: brightness ==
                                                          Brightness.light
                                                      ? const AssetImage(
                                                          "assets/images/ruzgaryonusiyah.png")
                                                      : const AssetImage(
                                                          "assets/images/ruzgaryonubeyaz.png"),
                                                  width: 35,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Hakim Rüzgar Yönü:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${_userModel!.daily!.winddirection10MDominant![nextDayIndex7]}°",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: ExpandableButton(
                                                child: const Icon(
                                                    CupertinoIcons.chevron_up),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              //Details
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                    child: Card(
                      child: Container(
                        width: (MediaQuery.of(context).size.width / 1.1) / 2.1,
                        height: (MediaQuery.of(context).size.width / 1.1) / 2.1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Gün Doğumu",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.oswald(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w400,
                                fontSize: 25,
                              ),
                            ),
                            SizedBox(
                              height: 60,
                              child: Image.asset("assets/gifs/gundogumu.gif",
                                  fit: BoxFit.fill),
                            ),
                            Text(
                              _userModel!.daily!.sunrise![weekdayIndex]
                                  .substring(11),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.oswald(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w400,
                                fontSize: 25,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                    child: Card(
                      child: Container(
                        width: (MediaQuery.of(context).size.width / 1.1) / 2.1,
                        height: (MediaQuery.of(context).size.width / 1.1) / 2.1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Gün Batımı",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.oswald(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w400,
                                fontSize: 25,
                              ),
                            ),
                            SizedBox(
                              height: 60,
                              child: Image.asset("assets/gifs/gunbatimi.gif",
                                  fit: BoxFit.fill),
                            ),
                            Text(
                              _userModel!.daily!.sunset![weekdayIndex]
                                  .substring(11),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.oswald(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w400,
                                fontSize: 25,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                    child: Card(
                      child: Container(
                        width: (MediaQuery.of(context).size.width / 1.1) / 2.1,
                        height: (MediaQuery.of(context).size.width / 1.1) / 2.1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Rüzgar",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.oswald(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w400,
                                fontSize: 25,
                              ),
                            ),
                            SizedBox(
                              height: 60,
                              child: Image.asset("assets/gifs/ruzgar.gif",
                                  fit: BoxFit.fill),
                            ),
                            Text(
                              "${_userModel!.hourly!.windspeed10M![currentIndex]} km/sa",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.oswald(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w400,
                                fontSize: 25,
                              ),
                            ),
                            Text(
                              getCardinalDirection(_userModel!
                                  .hourly!.winddirection10M![currentIndex]),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.oswald(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w400,
                                fontSize: 25,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                    child: Card(
                      child: Container(
                        width: (MediaQuery.of(context).size.width / 1.1) / 2.1,
                        height: (MediaQuery.of(context).size.width / 1.1) / 2.1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Nem",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.oswald(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w400,
                                fontSize: 25,
                              ),
                            ),
                            SizedBox(
                              height: 60,
                              child: Image.asset("assets/gifs/nem.gif",
                                  fit: BoxFit.fill),
                            ),
                            Text(
                              "%${_userModel!.hourly!.relativehumidity2M![currentIndex]}",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.oswald(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w400,
                                fontSize: 25,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                    child: Card(
                      child: Container(
                        width: (MediaQuery.of(context).size.width / 1.1) / 2.1,
                        height: (MediaQuery.of(context).size.width / 1.1) / 2.1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Görüş Mesafesi",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.oswald(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w400,
                                fontSize: 25,
                              ),
                            ),
                            SizedBox(
                              height: 60,
                              child: Image.asset(
                                  "assets/gifs/gorusmesafesi.gif",
                                  fit: BoxFit.fill),
                            ),
                            Text(
                              "${_userModel!.hourly!.visibility![currentIndex].toString().substring(0, 2)} km",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.oswald(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w400,
                                fontSize: 25,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                    child: Card(
                      child: Container(
                        width: (MediaQuery.of(context).size.width / 1.1) / 2.1,
                        height: (MediaQuery.of(context).size.width / 1.1) / 2.1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Yağış",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.oswald(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w400,
                                fontSize: 25,
                              ),
                            ),
                            SizedBox(
                              height: 60,
                              child: Image.asset("assets/gifs/yagmurlu.gif",
                                  fit: BoxFit.fill),
                            ),
                            Text(
                              "${_userModel!.hourly!.rain![currentIndex].toInt()} mm",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.oswald(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w400,
                                fontSize: 25,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                    child: Card(
                      child: Container(
                        width: (MediaQuery.of(context).size.width / 1.1) / 2.1,
                        height: (MediaQuery.of(context).size.width / 1.1) / 2.1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Hissedilen Sıcaklık",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.oswald(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w400,
                                fontSize: 25,
                              ),
                            ),
                            SizedBox(
                              height: 60,
                              child: Image.asset(
                                  "assets/gifs/hissedilensicaklik.gif",
                                  fit: BoxFit.fill),
                            ),
                            Text(
                              "${_userModel!.hourly!.apparentTemperature![currentIndex]} °C",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.oswald(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w400,
                                fontSize: 25,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                    child: Card(
                      child: Container(
                        width: (MediaQuery.of(context).size.width / 1.1) / 2.1,
                        height: (MediaQuery.of(context).size.width / 1.1) / 2.1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Yağış Olasılığı",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.oswald(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w400,
                                fontSize: 25,
                              ),
                            ),
                            SizedBox(
                              height: 60,
                              child: Image.asset("assets/gifs/yagmurlu.gif",
                                  fit: BoxFit.fill),
                            ),
                            Text(
                              "%${_userModel!.hourly!.precipitationProbability![currentIndex]}",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.oswald(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w400,
                                fontSize: 25,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                    child: Card(
                      child: Container(
                        width: (MediaQuery.of(context).size.width / 1.1) / 2.1,
                        height: (MediaQuery.of(context).size.width / 1.1) / 2.1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "UV Endeksi",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.oswald(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w400,
                                fontSize: 25,
                              ),
                            ),
                            SizedBox(
                              height: 60,
                              child: Image.asset("assets/gifs/uv.png",
                                  fit: BoxFit.fill),
                            ),
                            Text(
                              "${_userModel!.hourly!.uvIndex![currentIndex]}",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.oswald(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w400,
                                fontSize: 25,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                    child: Card(
                      child: Container(
                        width: (MediaQuery.of(context).size.width / 1.1) / 2.1,
                        height: (MediaQuery.of(context).size.width / 1.1) / 2.1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Basınç",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.oswald(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w400,
                                fontSize: 25,
                              ),
                            ),
                            SizedBox(
                              height: 60,
                              child: Image.asset("assets/images/basinc.png",
                                  fit: BoxFit.fill),
                            ),
                            Text(
                              "${_userModel!.hourly!.surfacePressure![currentIndex].toInt()} hPa",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.oswald(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w400,
                                fontSize: 25,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
      //Bottom Nav Bar
      bottomNavigationBar: SizedBox(
          height: 55,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const MapPage())),
                child: Icon(CupertinoIcons.map,
                    color: Theme.of(context).colorScheme.onSurface, size: 36),
              ),
              GestureDetector(
                onTap: () {},
                child: Icon(CupertinoIcons.add_circled,
                    color: Theme.of(context).colorScheme.onSurface, size: 36),
              ),
              GestureDetector(
                onTap: () {},
                child: Icon(CupertinoIcons.list_bullet_indent,
                    color: Theme.of(context).colorScheme.onSurface, size: 36),
              ),
            ],
          )),
    );
  }
}
