// ignore_for_file: unnecessary_null_comparison, avoid_print, unused_element

import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mepsan_hava_durumu/components/api_service.dart';
import 'package:mepsan_hava_durumu/components/weather_model.dart';
import 'package:rive/rive.dart' as rive;

class DailyPartClass extends StatefulWidget {
  const DailyPartClass({super.key});

  @override
  State<DailyPartClass> createState() => _DailyPartClassState();
}

class _DailyPartClassState extends State<DailyPartClass> {
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

  late WeatherTest? _userModel = null;
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

  List<String> days = ["Pzt", "Sal", "Çar", "Per", "Cum", "Cmt", "Paz"];

  int getNextIndexDays(int currentIndexDays) {
    int nextIndexDays = currentIndexDays + 1;

    if (nextIndexDays >= days.length) {
      nextIndexDays = 0;
    }

    return nextIndexDays;
  }

  @override
  Widget build(BuildContext context) {
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

    var brightness = MediaQuery.of(context).platformBrightness;

    return _userModel != null
        ? Padding(
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
                                          fontSize: 30,
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
                                          fontSize: 30,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 12, left: 12.0),
                                      child: Container(
                                        width: 80,
                                        height: 5,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          gradient:
                                              const LinearGradient(colors: [
                                            Color.fromARGB(255, 178, 254, 250),
                                            Color.fromARGB(255, 245, 175, 25),
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
                                        fontSize: 30,
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
                                            fontSize: 30,
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
                                            fontSize: 30,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 12, left: 12.0),
                                        child: Container(
                                          width: 80,
                                          height: 5,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            gradient:
                                                const LinearGradient(colors: [
                                              Color.fromARGB(
                                                  255, 178, 254, 250),
                                              Color.fromARGB(255, 245, 175, 25),
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
                                          fontSize: 30,
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
                                              MainAxisAlignment.spaceBetween,
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
                                              MainAxisAlignment.spaceBetween,
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
                                              MainAxisAlignment.spaceBetween,
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
                                              MainAxisAlignment.spaceBetween,
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
                                              MainAxisAlignment.spaceBetween,
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
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
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
                                          fontSize: 30,
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
                                          fontSize: 30,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 12, left: 12.0),
                                      child: Container(
                                        width: 80,
                                        height: 5,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          gradient:
                                              const LinearGradient(colors: [
                                            Color.fromARGB(255, 178, 254, 250),
                                            Color.fromARGB(255, 245, 175, 25),
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
                                        fontSize: 30,
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
                                            fontSize: 30,
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
                                            fontSize: 30,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 12, left: 12.0),
                                        child: Container(
                                          width: 80,
                                          height: 5,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            gradient:
                                                const LinearGradient(colors: [
                                              Color.fromARGB(
                                                  255, 178, 254, 250),
                                              Color.fromARGB(255, 245, 175, 25),
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
                                          fontSize: 30,
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
                                              MainAxisAlignment.spaceBetween,
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
                                              MainAxisAlignment.spaceBetween,
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
                                              MainAxisAlignment.spaceBetween,
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
                                              MainAxisAlignment.spaceBetween,
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
                                              MainAxisAlignment.spaceBetween,
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
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
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
                                          fontSize: 30,
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
                                          fontSize: 30,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 12, left: 12.0),
                                      child: Container(
                                        width: 80,
                                        height: 5,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          gradient:
                                              const LinearGradient(colors: [
                                            Color.fromARGB(255, 178, 254, 250),
                                            Color.fromARGB(255, 245, 175, 25),
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
                                        fontSize: 30,
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
                                            fontSize: 30,
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
                                            fontSize: 30,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 12, left: 12.0),
                                        child: Container(
                                          width: 80,
                                          height: 5,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            gradient:
                                                const LinearGradient(colors: [
                                              Color.fromARGB(
                                                  255, 178, 254, 250),
                                              Color.fromARGB(255, 245, 175, 25),
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
                                          fontSize: 30,
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
                                              MainAxisAlignment.spaceBetween,
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
                                              MainAxisAlignment.spaceBetween,
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
                                              MainAxisAlignment.spaceBetween,
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
                                              MainAxisAlignment.spaceBetween,
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
                                              MainAxisAlignment.spaceBetween,
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
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
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
                                          fontSize: 30,
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
                                          fontSize: 30,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 12, left: 12.0),
                                      child: Container(
                                        width: 80,
                                        height: 5,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          gradient:
                                              const LinearGradient(colors: [
                                            Color.fromARGB(255, 178, 254, 250),
                                            Color.fromARGB(255, 245, 175, 25),
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
                                        fontSize: 30,
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
                                            fontSize: 30,
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
                                            fontSize: 30,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 12, left: 12.0),
                                        child: Container(
                                          width: 80,
                                          height: 5,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            gradient:
                                                const LinearGradient(colors: [
                                              Color.fromARGB(
                                                  255, 178, 254, 250),
                                              Color.fromARGB(255, 245, 175, 25),
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
                                          fontSize: 30,
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
                                              MainAxisAlignment.spaceBetween,
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
                                              MainAxisAlignment.spaceBetween,
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
                                              MainAxisAlignment.spaceBetween,
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
                                              MainAxisAlignment.spaceBetween,
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
                                              MainAxisAlignment.spaceBetween,
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
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
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
                                          fontSize: 30,
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
                                          fontSize: 30,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 12, left: 12.0),
                                      child: Container(
                                        width: 80,
                                        height: 5,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          gradient:
                                              const LinearGradient(colors: [
                                            Color.fromARGB(255, 178, 254, 250),
                                            Color.fromARGB(255, 245, 175, 25),
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
                                        fontSize: 30,
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
                                            fontSize: 30,
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
                                            fontSize: 30,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 12, left: 12.0),
                                        child: Container(
                                          width: 80,
                                          height: 5,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            gradient:
                                                const LinearGradient(colors: [
                                              Color.fromARGB(
                                                  255, 178, 254, 250),
                                              Color.fromARGB(255, 245, 175, 25),
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
                                          fontSize: 30,
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
                                              MainAxisAlignment.spaceBetween,
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
                                              MainAxisAlignment.spaceBetween,
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
                                              MainAxisAlignment.spaceBetween,
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
                                              MainAxisAlignment.spaceBetween,
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
                                              MainAxisAlignment.spaceBetween,
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
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
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
                                          fontSize: 30,
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
                                          fontSize: 30,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 12, left: 12.0),
                                      child: Container(
                                        width: 80,
                                        height: 5,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          gradient:
                                              const LinearGradient(colors: [
                                            Color.fromARGB(255, 178, 254, 250),
                                            Color.fromARGB(255, 245, 175, 25),
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
                                        fontSize: 30,
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
                                            fontSize: 30,
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
                                            fontSize: 30,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 12, left: 12.0),
                                        child: Container(
                                          width: 80,
                                          height: 5,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            gradient:
                                                const LinearGradient(colors: [
                                              Color.fromARGB(
                                                  255, 178, 254, 250),
                                              Color.fromARGB(255, 245, 175, 25),
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
                                          fontSize: 30,
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
                                              MainAxisAlignment.spaceBetween,
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
                                              MainAxisAlignment.spaceBetween,
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
                                              MainAxisAlignment.spaceBetween,
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
                                              MainAxisAlignment.spaceBetween,
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
                                              MainAxisAlignment.spaceBetween,
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
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
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
                                          fontSize: 30,
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
                                          fontSize: 30,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 12, left: 12.0),
                                      child: Container(
                                        width: 80,
                                        height: 5,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          gradient:
                                              const LinearGradient(colors: [
                                            Color.fromARGB(255, 178, 254, 250),
                                            Color.fromARGB(255, 245, 175, 25),
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
                                        fontSize: 30,
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
                                            fontSize: 30,
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
                                            fontSize: 30,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 12, left: 12.0),
                                        child: Container(
                                          width: 80,
                                          height: 5,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            gradient:
                                                const LinearGradient(colors: [
                                              Color.fromARGB(
                                                  255, 178, 254, 250),
                                              Color.fromARGB(255, 245, 175, 25),
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
                                          fontSize: 30,
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
                                              MainAxisAlignment.spaceBetween,
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
                                              MainAxisAlignment.spaceBetween,
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
                                              MainAxisAlignment.spaceBetween,
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
                                              MainAxisAlignment.spaceBetween,
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
                                              MainAxisAlignment.spaceBetween,
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
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
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
                                          fontSize: 30,
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
                                          fontSize: 30,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 12, left: 12.0),
                                      child: Container(
                                        width: 80,
                                        height: 5,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          gradient:
                                              const LinearGradient(colors: [
                                            Color.fromARGB(255, 178, 254, 250),
                                            Color.fromARGB(255, 245, 175, 25),
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
                                        fontSize: 30,
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
                                            fontSize: 30,
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
                                            fontSize: 30,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 12, left: 12.0),
                                        child: Container(
                                          width: 80,
                                          height: 5,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            gradient:
                                                const LinearGradient(colors: [
                                              Color.fromARGB(
                                                  255, 178, 254, 250),
                                              Color.fromARGB(255, 245, 175, 25),
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
                                          fontSize: 30,
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
                                              MainAxisAlignment.spaceBetween,
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
                                              MainAxisAlignment.spaceBetween,
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
                                              MainAxisAlignment.spaceBetween,
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
                                              MainAxisAlignment.spaceBetween,
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
                                              MainAxisAlignment.spaceBetween,
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
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
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
          )
        : const Center(
            child: rive.RiveAnimation.asset(
            "assets/gifs/loader.riv",
            fit: BoxFit.fitWidth,
          ));
  }
}
