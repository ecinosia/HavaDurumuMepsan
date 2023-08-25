// ignore_for_file: unnecessary_null_comparison, avoid_print

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mepsan_hava_durumu/components/api_service.dart';
import 'package:mepsan_hava_durumu/components/weather_model.dart';

class DetailsPartClass extends StatefulWidget {
  const DetailsPartClass({super.key});

  @override
  State<DetailsPartClass> createState() => _DetailsPartClassState();
}

class _DetailsPartClassState extends State<DetailsPartClass> {
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
    int weekdayIndex = DateTime.now().weekday - 1;

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

    int currentIndex = hours
        .indexWhere((hour) => hour == DateFormat('HH').format(DateTime.now()));

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
              child: GestureDetector(
                onTap: () {
                  // showModalBottomSheet(
                  //     context: context,
                  //     shape: const RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.vertical(
                  //         top: Radius.circular(25),
                  //       ),
                  //     ),
                  //     builder: (BuildContext context) {
                  //       return LineChart();
                  //     });
                },
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
                        _userModel!.daily!.sunset![weekdayIndex].substring(11),
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
                        child: Image.asset("assets/gifs/gorusmesafesi.gif",
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
                        child: Image.asset("assets/gifs/hissedilensicaklik.gif",
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
                        child:
                            Image.asset("assets/gifs/uv.png", fit: BoxFit.fill),
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
      ],
    );
  }
}
