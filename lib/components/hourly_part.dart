// ignore_for_file: unnecessary_null_comparison, avoid_print

import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mepsan_hava_durumu/components/api_service.dart';
import 'package:mepsan_hava_durumu/components/weather_model.dart';
import 'package:rive/rive.dart' as rive;

class HourlyPartClass extends StatefulWidget {
  const HourlyPartClass({super.key});

  @override
  State<HourlyPartClass> createState() => _HourlyPartClassState();
}

class _HourlyPartClassState extends State<HourlyPartClass> {
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

  late WeatherTest? _userModel = WeatherTest();
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
        weatherCodeHourly =
            userModel != null ? userModel.hourly?.weathercode : [0];
      });
    } catch (error) {
      print('Error occurred: $error');
    }
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

  int getNextIndex(int currentIndex) {
    int nextIndex = currentIndex + 1;

    if (nextIndex >= hours.length) {
      nextIndex = 0;
    }

    return nextIndex;
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;

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

    String getWeatherGif(int index) {
      if (_userModel == null ||
          _userModel!.hourly == null ||
          _userModel!.hourly!.weathercode == null ||
          _userModel!.hourly!.isDay == null) {
        // Data not loaded yet
        return "";
      }

      int currentWeatherCode = _userModel!.hourly!.weathercode![index];

      if (_userModel!.hourly!.isDay![index] == 1) {
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

    return _userModel!.hourly != null
        ? Padding(
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
                                    padding: const EdgeInsets.only(left: 12.0),
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
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${_userModel!.hourly!.apparentTemperature![currentIndex].round()}°C",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
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
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "%${_userModel!.hourly!.relativehumidity2M![currentIndex]}",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
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
                                                  width: 30,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Yağış Olasılığı:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "%${_userModel!.hourly!.precipitationProbability![currentIndex]}",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
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
                                    padding: const EdgeInsets.only(left: 8.0),
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
                                                    "${_userModel!.hourly!.apparentTemperature![nextIndex1].round()}°C",
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
                                                    "%${_userModel!.hourly!.relativehumidity2M![nextIndex1]}",
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
                                                    "%${_userModel!.hourly!.precipitationProbability![nextIndex1]}",
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
                                      padding: const EdgeInsets.only(left: 8.0),
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
                                                    "${_userModel!.hourly!.apparentTemperature![nextIndex2].round()}°C",
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
                                                    "%${_userModel!.hourly!.relativehumidity2M![nextIndex2]}",
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
                                                    "%${_userModel!.hourly!.precipitationProbability![nextIndex2]}",
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
                                      padding: const EdgeInsets.only(left: 8.0),
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                    padding: const EdgeInsets.only(left: 12.0),
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
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${_userModel!.hourly!.apparentTemperature![nextIndex3].round()}°C",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
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
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "%${_userModel!.hourly!.relativehumidity2M![nextIndex3]}",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
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
                                                  width: 30,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Yağış Olasılığı:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "%${_userModel!.hourly!.precipitationProbability![nextIndex3]}",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
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
                                    padding: const EdgeInsets.only(left: 8.0),
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                    padding: const EdgeInsets.only(left: 12.0),
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
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${_userModel!.hourly!.apparentTemperature![nextIndex4].round()}°C",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
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
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "%${_userModel!.hourly!.relativehumidity2M![nextIndex4]}",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
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
                                                  width: 30,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Yağış Olasılığı:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "%${_userModel!.hourly!.precipitationProbability![nextIndex4]}",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
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
                                    padding: const EdgeInsets.only(left: 8.0),
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                    padding: const EdgeInsets.only(left: 12.0),
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
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${_userModel!.hourly!.apparentTemperature![nextIndex5].round()}°C",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
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
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "%${_userModel!.hourly!.relativehumidity2M![nextIndex5]}",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
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
                                                  width: 30,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Yağış Olasılığı:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "%${_userModel!.hourly!.precipitationProbability![nextIndex5]}",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
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
                                    padding: const EdgeInsets.only(left: 8.0),
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                    padding: const EdgeInsets.only(left: 12.0),
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
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${_userModel!.hourly!.apparentTemperature![nextIndex6].round()}°C",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
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
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "%${_userModel!.hourly!.relativehumidity2M![nextIndex6]}",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
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
                                                  width: 30,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Yağış Olasılığı:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "%${_userModel!.hourly!.precipitationProbability![nextIndex6]}",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
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
                                    padding: const EdgeInsets.only(left: 8.0),
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                    padding: const EdgeInsets.only(left: 12.0),
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
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${_userModel!.hourly!.apparentTemperature![nextIndex7].round()}°C",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
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
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "%${_userModel!.hourly!.relativehumidity2M![nextIndex7]}",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
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
                                                  width: 30,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Yağış Olasılığı:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "%${_userModel!.hourly!.precipitationProbability![nextIndex7]}",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
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
                                    padding: const EdgeInsets.only(left: 8.0),
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                    padding: const EdgeInsets.only(left: 12.0),
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
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${_userModel!.hourly!.apparentTemperature![nextIndex8].round()}°C",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
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
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "%${_userModel!.hourly!.relativehumidity2M![nextIndex8]}",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
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
                                                  width: 30,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Yağış Olasılığı:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "%${_userModel!.hourly!.precipitationProbability![nextIndex8]}",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
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
                                    padding: const EdgeInsets.only(left: 8.0),
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                    padding: const EdgeInsets.only(left: 12.0),
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
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${_userModel!.hourly!.apparentTemperature![nextIndex9].round()}°C",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
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
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "%${_userModel!.hourly!.relativehumidity2M![nextIndex9]}",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
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
                                                  width: 30,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Yağış Olasılığı:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "%${_userModel!.hourly!.precipitationProbability![nextIndex9]}",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
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
                                    padding: const EdgeInsets.only(left: 8.0),
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                    padding: const EdgeInsets.only(left: 12.0),
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
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${_userModel!.hourly!.apparentTemperature![nextIndex10].round()}°C",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
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
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "%${_userModel!.hourly!.relativehumidity2M![nextIndex10]}",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
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
                                                  width: 30,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Yağış Olasılığı:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "%${_userModel!.hourly!.precipitationProbability![nextIndex10]}",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
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
                                    padding: const EdgeInsets.only(left: 8.0),
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                    padding: const EdgeInsets.only(left: 12.0),
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
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${_userModel!.hourly!.apparentTemperature![nextIndex11].round()}°C",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
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
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "%${_userModel!.hourly!.relativehumidity2M![nextIndex11]}",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
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
                                                  width: 30,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Yağış Olasılığı:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "%${_userModel!.hourly!.precipitationProbability![nextIndex11]}",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
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
                                    padding: const EdgeInsets.only(left: 8.0),
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                    padding: const EdgeInsets.only(left: 12.0),
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
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${_userModel!.hourly!.apparentTemperature![nextIndex12].round()}°C",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
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
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "%${_userModel!.hourly!.relativehumidity2M![nextIndex12]}",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
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
                                                  width: 30,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Yağış Olasılığı:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "%${_userModel!.hourly!.precipitationProbability![nextIndex12]}",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
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
                                    padding: const EdgeInsets.only(left: 8.0),
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                    padding: const EdgeInsets.only(left: 12.0),
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
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${_userModel!.hourly!.apparentTemperature![nextIndex13].round()}°C",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
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
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "%${_userModel!.hourly!.relativehumidity2M![nextIndex13]}",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
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
                                                  width: 30,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Yağış Olasılığı:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "%${_userModel!.hourly!.precipitationProbability![nextIndex13]}",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
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
                                    padding: const EdgeInsets.only(left: 8.0),
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                    padding: const EdgeInsets.only(left: 12.0),
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
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${_userModel!.hourly!.apparentTemperature![nextIndex14].round()}°C",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
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
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "%${_userModel!.hourly!.relativehumidity2M![nextIndex14]}",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
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
                                                  width: 30,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Yağış Olasılığı:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "%${_userModel!.hourly!.precipitationProbability![nextIndex14]}",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
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
                                    padding: const EdgeInsets.only(left: 8.0),
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                    padding: const EdgeInsets.only(left: 12.0),
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
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${_userModel!.hourly!.apparentTemperature![nextIndex15].round()}°C",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
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
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "%${_userModel!.hourly!.relativehumidity2M![nextIndex15]}",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
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
                                                  width: 30,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Yağış Olasılığı:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "%${_userModel!.hourly!.precipitationProbability![nextIndex15]}",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
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
                                    padding: const EdgeInsets.only(left: 8.0),
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                    padding: const EdgeInsets.only(left: 12.0),
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
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${_userModel!.hourly!.apparentTemperature![nextIndex16].round()}°C",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
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
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "%${_userModel!.hourly!.relativehumidity2M![nextIndex16]}",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
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
                                                  width: 30,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Yağış Olasılığı:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "%${_userModel!.hourly!.precipitationProbability![nextIndex16]}",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
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
                                    padding: const EdgeInsets.only(left: 8.0),
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                    padding: const EdgeInsets.only(left: 12.0),
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
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${_userModel!.hourly!.apparentTemperature![nextIndex17].round()}°C",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
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
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "%${_userModel!.hourly!.relativehumidity2M![nextIndex17]}",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
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
                                                  width: 30,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Yağış Olasılığı:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "%${_userModel!.hourly!.precipitationProbability![nextIndex17]}",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
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
                                    padding: const EdgeInsets.only(left: 8.0),
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                    padding: const EdgeInsets.only(left: 12.0),
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
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${_userModel!.hourly!.apparentTemperature![nextIndex18].round()}°C",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
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
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "%${_userModel!.hourly!.relativehumidity2M![nextIndex18]}",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
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
                                                  width: 30,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Yağış Olasılığı:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "%${_userModel!.hourly!.precipitationProbability![nextIndex18]}",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
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
                                    padding: const EdgeInsets.only(left: 8.0),
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                    padding: const EdgeInsets.only(left: 12.0),
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
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${_userModel!.hourly!.apparentTemperature![nextIndex19].round()}°C",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
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
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "%${_userModel!.hourly!.relativehumidity2M![nextIndex19]}",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
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
                                                  width: 30,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Yağış Olasılığı:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "%${_userModel!.hourly!.precipitationProbability![nextIndex19]}",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
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
                                    padding: const EdgeInsets.only(left: 8.0),
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                    padding: const EdgeInsets.only(left: 12.0),
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
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${_userModel!.hourly!.apparentTemperature![nextIndex20].round()}°C",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
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
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "%${_userModel!.hourly!.relativehumidity2M![nextIndex20]}",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
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
                                                  width: 30,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Yağış Olasılığı:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "%${_userModel!.hourly!.precipitationProbability![nextIndex20]}",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
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
                                    padding: const EdgeInsets.only(left: 8.0),
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                    padding: const EdgeInsets.only(left: 12.0),
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
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${_userModel!.hourly!.apparentTemperature![nextIndex21].round()}°C",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
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
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "%${_userModel!.hourly!.relativehumidity2M![nextIndex21]}",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
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
                                                  width: 30,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Yağış Olasılığı:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "%${_userModel!.hourly!.precipitationProbability![nextIndex21]}",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
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
                                    padding: const EdgeInsets.only(left: 8.0),
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                    padding: const EdgeInsets.only(left: 12.0),
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
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${_userModel!.hourly!.apparentTemperature![nextIndex22].round()}°C",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
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
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "%${_userModel!.hourly!.relativehumidity2M![nextIndex22]}",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
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
                                                  width: 30,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Yağış Olasılığı:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "%${_userModel!.hourly!.precipitationProbability![nextIndex22]}",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
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
                                    padding: const EdgeInsets.only(left: 8.0),
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                    padding: const EdgeInsets.only(left: 12.0),
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
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${_userModel!.hourly!.apparentTemperature![nextIndex23].round()}°C",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
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
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "%${_userModel!.hourly!.relativehumidity2M![nextIndex23]}",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
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
                                                  width: 30,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Yağış Olasılığı:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "%${_userModel!.hourly!.precipitationProbability![nextIndex23]}",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
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
                                    padding: const EdgeInsets.only(left: 8.0),
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                    padding: const EdgeInsets.only(left: 12.0),
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
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${_userModel!.hourly!.apparentTemperature![nextIndex24].round()}°C",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
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
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "%${_userModel!.hourly!.relativehumidity2M![nextIndex24]}",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
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
                                                  width: 30,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Yağış Olasılığı:",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "%${_userModel!.hourly!.precipitationProbability![nextIndex24]}",
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
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
                                    padding: const EdgeInsets.only(left: 8.0),
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
          )
        : const Center(
            child: rive.RiveAnimation.asset("assets/gifs/mini_loader.riv"));
  }
}
