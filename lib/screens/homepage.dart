import 'dart:core';

import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

List<Color> getGradientColors(condition) {
  if (condition == "gunesli") {
    return [
      const Color.fromRGBO(253, 200, 48, 1),
      const Color.fromRGBO(243, 115, 53, 1)
    ];
  } else if (condition == "bulutlu") {
    return [
      const Color.fromRGBO(149, 184, 204, 1),
      const Color.fromRGBO(219, 212, 180, 1),
      const Color.fromRGBO(122, 161, 210, 1),
    ];
  } else if (condition == "yagmurlu") {
    return [
      const Color.fromRGBO(75, 108, 183, 1),
      const Color.fromRGBO(24, 40, 72, 1),
    ];
  } else if (condition == "saganakyagmurlu") {
    return [
      const Color.fromRGBO(20, 30, 48, 1),
      const Color.fromRGBO(36, 59, 85, 1),
    ];
  } else if (condition == "karli") {
    return [
      const Color.fromRGBO(48, 67, 82, 1),
      const Color.fromRGBO(215, 210, 204, 1),
    ];
  } else if (condition == "saganakkarli") {
    return [
      const Color.fromRGBO(21, 28, 35, 1),
      const Color.fromRGBO(215, 210, 204, 1),
    ];
  } else if (condition == "ruzgarli") {
    return [
      const Color.fromRGBO(135, 206, 235, 1),
      const Color.fromRGBO(100, 149, 237, 1),
      const Color.fromRGBO(79, 98, 142, 1),
      const Color.fromRGBO(61, 91, 124, 1),
    ];
  } else if (condition == "gokgurultulu") {
    return [
      const Color.fromRGBO(183, 195, 208, 1),
      const Color.fromRGBO(137, 152, 170, 1),
      const Color.fromRGBO(91, 115, 151, 1),
      const Color.fromRGBO(68, 60, 132, 1),
    ];
  } else {
    return [Colors.grey, Colors.black];
  }
}

var colors = getGradientColors(weatherCondition);

String getGifAsset(String condition) {
  if (condition == "gunesli") {
    return "assets/gifs/gunesli.gif";
  } else if (condition == "bulutlu") {
    return "assets/gifs/parcalibulutlu.gif";
  } else if (condition == "yagmurlu") {
    return "assets/gifs/yagmurlu.gif";
  } else if (condition == "saganakyagmurlu") {
    return "assets/gifs/saganakyagmur.gif";
  } else if (condition == "karli") {
    return "assets/gifs/karli.gif";
  } else if (condition == "saganakkarli") {
    return "assets/gifs/saganakkarli.gif";
  } else if (condition == "ruzgarli") {
    return "assets/gifs/ruzgarli.gif";
  } else if (condition == "gokgurultulu") {
    return "assets/gifs/gokgurultulu.gif";
  } else {
    return "assets/gifs/default.png";
  }
}

String asset = getGifAsset(weatherCondition);

String getWeatherCondition(String condition) {
  if (condition == "gunesli") {
    return "Güneşli";
  } else if (condition == "bulutlu") {
    return "Bulutlu";
  } else if (condition == "yagmurlu") {
    return "Yağmurlu";
  } else if (condition == "saganakyagmurlu") {
    return "Sağanak Yağmurlu";
  } else if (condition == "karli") {
    return "Karlı";
  } else if (condition == "saganakkarli") {
    return "Sağanak Kar Yağışlı";
  } else if (condition == "ruzgarli") {
    return "Rüzgarlı";
  } else if (condition == "gokgurultulu") {
    return "Gök Gürültülü";
  } else {
    return "Açık";
  }
}

String weatherConditionProper = getWeatherCondition(weatherCondition);

var weatherCondition = "bulutlu";

class _HomePageState extends State<HomePage> {
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

  late WeatherTest? _userModel;
  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    _userModel = (await ApiService().getWeatherForTargetCoord());
  }

  late double? latitude;
  late double? longitude;
  //String? currentAddress;
  String? locationMessage;

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

    // ignore: no_leading_underscores_for_local_identifiers
    Future<Position> _getCurrentLocation() async {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error("Konum servisleri kapalı!");
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error("Konum izni reddedildi!");
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            "Konum servisleri kalıcı olarak reddedildi. Konum bilgisi alınamıyor!");
      }
      return await Geolocator.getCurrentPosition(); // biraz karışmış
    }

    Future<bool> getCurrentLocationCoord() async {
      try {
        Position position = await _getCurrentLocation();
        if (!position.latitude.isNaN && !position.longitude.isNaN) {
          longitude = position.longitude;
          latitude = position.latitude;
          debugPrint("Lokasyon Verileri: $longitude , $latitude");
          setState(() {});
          return true;
        } else {
          throw ("Lokasyon Verileri boş geldi");
        }
      } catch (e) {
        throw ("Lokasyon Çekerken Hata : ${e.toString()}");
      }
    }

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: colors,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 8,
              ),

              // Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     OutlinedButton(
              //         child: const Text("Konum"),
              //         onPressed: () async {
              //           if (await getCurrentLocationCoord()) {
              //             setState(() {
              //               locationMessage =
              //                   "Latitude: ${latitude.toString()}, Longitude: ${longitude.toString()}";
              //               debugPrint(
              //                   "OutlinedButton from Homepage : $locationMessage");
              //             });
              //           } else {
              //             setState(() {
              //               locationMessage = "Lokasyon verileri Hatalı";
              //             });

              //             debugPrint(latitude.toString());
              //           }
              //         }),
              //     const SizedBox(height: 20), // Adding some spacing
              //     Text(
              //       locationMessage == null
              //           ? "Veriler Yükleniyor..."
              //           : locationMessage!,
              //       textAlign: TextAlign.center,
              //       style: const TextStyle(fontSize: 40),
              //     ),

              //   ],
              // ),
              //City Name
              Text(
                "Konya",
                textAlign: TextAlign.center,
                style: GoogleFonts.oswald(
                  color: Colors.white,
                  fontSize: 45,
                ),
              ),
              //Degree
              Text(
                "${_userModel!.currentWeather!.temperature}°C",
                textAlign: TextAlign.center,
                style: GoogleFonts.oswald(
                  color: Colors.white,
                  fontSize: 80,
                ),
              ),
              //Weather Status
              Text(
                weatherConditionProper,
                textAlign: TextAlign.center,
                style: GoogleFonts.oswald(
                  color: Colors.white,
                  fontSize: 35,
                ),
              ),
              //Apperant Temperature
              Text(
                "Hissedilen Sıcaklık: ${_userModel!.hourly!.apparentTemperature![currentIndex]}°C",
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
                    "En Düşük: ${_userModel!.daily!.temperature2MMin![0]}°C",
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
                    "En Yüksek: ${_userModel!.daily!.temperature2MMax![0]}°C",
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
                                        Image.asset(asset),
                                        Text(
                                          "${_userModel!.hourly!.temperature2M![currentIndex]}°C",
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
                                          Image.asset(asset),
                                          Text(
                                            "${_userModel!.hourly!.temperature2M![0]}°C",
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
                                                      "${_userModel!.hourly!.apparentTemperature![currentIndex]}°C",
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
                                          Image.asset(asset),
                                          Text(
                                            "${_userModel!.hourly!.temperature2M![nextIndex1]}°C",
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
                                            Image.asset(asset),
                                            Text(
                                              "${_userModel!.hourly!.temperature2M![nextIndex1]}°C",
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
                                                        "${_userModel!.hourly!.apparentTemperature![nextIndex1]}°C",
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
                                          Image.asset(asset),
                                          Text(
                                            " ${_userModel!.hourly!.temperature2M![nextIndex2]}°C",
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
                                            Image.asset(asset),
                                            Text(
                                              "${_userModel!.hourly!.temperature2M![nextIndex2]}°C",
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
                                                        "${_userModel!.hourly!.apparentTemperature![nextIndex2]}°C",
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
                                        Image.asset(asset),
                                        Text(
                                          " ${_userModel!.hourly!.temperature2M![nextIndex3]}°C",
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
                                          Image.asset(asset),
                                          Text(
                                            "${_userModel!.hourly!.temperature2M![nextIndex3]}°C",
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
                                                      "${_userModel!.hourly!.apparentTemperature![nextIndex3]}°C",
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
                                        Image.asset(asset),
                                        Text(
                                          "${_userModel!.hourly!.temperature2M![nextIndex4]}°C",
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
                                          Image.asset(asset),
                                          Text(
                                            "${_userModel!.hourly!.temperature2M![nextIndex4]}°C",
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
                                                      "${_userModel!.hourly!.apparentTemperature![nextIndex4]}°C",
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
                                        Image.asset(asset),
                                        Text(
                                          "${_userModel!.hourly!.temperature2M![nextIndex5]}°C",
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
                                          Image.asset(asset),
                                          Text(
                                            "${_userModel!.hourly!.temperature2M![nextIndex5]}°C",
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
                                                      "${_userModel!.hourly!.apparentTemperature![nextIndex5]}°C",
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
                                        Image.asset(asset),
                                        Text(
                                          "${_userModel!.hourly!.temperature2M![nextIndex6]}°C",
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
                                          Image.asset(asset),
                                          Text(
                                            "${_userModel!.hourly!.temperature2M![nextIndex6]}°C",
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
                                                      "${_userModel!.hourly!.apparentTemperature![nextIndex6]}°C",
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
                                        Image.asset(asset),
                                        Text(
                                          "${_userModel!.hourly!.temperature2M![nextIndex7]}°C",
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
                                          Image.asset(asset),
                                          Text(
                                            "${_userModel!.hourly!.temperature2M![nextIndex7]}°C",
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
                                                      "${_userModel!.hourly!.apparentTemperature![nextIndex7]}°C",
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
                                        Image.asset(asset),
                                        Text(
                                          "${_userModel!.hourly!.temperature2M![nextIndex8]}°C",
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
                                          Image.asset(asset),
                                          Text(
                                            "${_userModel!.hourly!.temperature2M![nextIndex8]}°C",
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
                                                      "${_userModel!.hourly!.apparentTemperature![nextIndex8]}°C",
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
                                        Image.asset(asset),
                                        Text(
                                          "${_userModel!.hourly!.temperature2M![nextIndex9]}°C",
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
                                          Image.asset(asset),
                                          Text(
                                            "${_userModel!.hourly!.temperature2M![nextIndex9]}°C",
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
                                                      "${_userModel!.hourly!.apparentTemperature![nextIndex9]}°C",
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
                                        Image.asset(asset),
                                        Text(
                                          "${_userModel!.hourly!.temperature2M![nextIndex10]}°C",
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
                                          Image.asset(asset),
                                          Text(
                                            "${_userModel!.hourly!.temperature2M![nextIndex10]}°C",
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
                                                      "${_userModel!.hourly!.apparentTemperature![nextIndex10]}°C",
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
                                        Image.asset(asset),
                                        Text(
                                          "${_userModel!.hourly!.temperature2M![nextIndex11]}°C",
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
                                          Image.asset(asset),
                                          Text(
                                            "${_userModel!.hourly!.temperature2M![nextIndex11]}°C",
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
                                                      "${_userModel!.hourly!.apparentTemperature![nextIndex11]}°C",
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
                                        Image.asset(asset),
                                        Text(
                                          "${_userModel!.hourly!.temperature2M![nextIndex12]}°C",
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
                                          Image.asset(asset),
                                          Text(
                                            "${_userModel!.hourly!.temperature2M![nextIndex12]}°C",
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
                                                      "${_userModel!.hourly!.apparentTemperature![nextIndex12]}°C",
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
                                        Image.asset(asset),
                                        Text(
                                          "${_userModel!.hourly!.temperature2M![nextIndex13]}°C",
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
                                          Image.asset(asset),
                                          Text(
                                            "${_userModel!.hourly!.temperature2M![nextIndex13]}°C",
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
                                                      "${_userModel!.hourly!.apparentTemperature![nextIndex13]}°C",
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
                                        Image.asset(asset),
                                        Text(
                                          "${_userModel!.hourly!.temperature2M![nextIndex14]}°C",
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
                                          Image.asset(asset),
                                          Text(
                                            "${_userModel!.hourly!.temperature2M![nextIndex14]}°C",
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
                                                      "${_userModel!.hourly!.apparentTemperature![nextIndex14]}°C",
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
                                        Image.asset(asset),
                                        Text(
                                          "${_userModel!.hourly!.temperature2M![nextIndex15]}°C",
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
                                          Image.asset(asset),
                                          Text(
                                            "${_userModel!.hourly!.temperature2M![nextIndex15]}°C",
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
                                                      "${_userModel!.hourly!.apparentTemperature![nextIndex15]}°C",
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
                                        Image.asset(asset),
                                        Text(
                                          "${_userModel!.hourly!.temperature2M![nextIndex16]}°C",
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
                                          Image.asset(asset),
                                          Text(
                                            "${_userModel!.hourly!.temperature2M![nextIndex16]}°C",
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
                                                      "${_userModel!.hourly!.apparentTemperature![nextIndex16]}°C",
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
                                        Image.asset(asset),
                                        Text(
                                          "${_userModel!.hourly!.temperature2M![nextIndex17]}°C",
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
                                          Image.asset(asset),
                                          Text(
                                            "${_userModel!.hourly!.temperature2M![nextIndex17]}°C",
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
                                                      "${_userModel!.hourly!.apparentTemperature![nextIndex17]}°C",
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
                                        Image.asset(asset),
                                        Text(
                                          "${_userModel!.hourly!.temperature2M![nextIndex18]}°C",
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
                                          Image.asset(asset),
                                          Text(
                                            "${_userModel!.hourly!.temperature2M![nextIndex18]}°C",
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
                                                      "${_userModel!.hourly!.apparentTemperature![nextIndex18]}°C",
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
                                        Image.asset(asset),
                                        Text(
                                          "${_userModel!.hourly!.temperature2M![nextIndex19]}°C",
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
                                          Image.asset(asset),
                                          Text(
                                            "${_userModel!.hourly!.temperature2M![nextIndex19]}°C",
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
                                                      "${_userModel!.hourly!.apparentTemperature![nextIndex19]}°C",
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
                                        Image.asset(asset),
                                        Text(
                                          "${_userModel!.hourly!.temperature2M![nextIndex20]}°C",
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
                                          Image.asset(asset),
                                          Text(
                                            "${_userModel!.hourly!.temperature2M![nextIndex20]}°C",
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
                                                      "${_userModel!.hourly!.apparentTemperature![nextIndex20]}°C",
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
                                        Image.asset(asset),
                                        Text(
                                          "${_userModel!.hourly!.temperature2M![nextIndex21]}°C",
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
                                          Image.asset(asset),
                                          Text(
                                            "${_userModel!.hourly!.temperature2M![nextIndex21]}°C",
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
                                                      "${_userModel!.hourly!.apparentTemperature![nextIndex21]}°C",
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
                                        Image.asset(asset),
                                        Text(
                                          "${_userModel!.hourly!.temperature2M![nextIndex22]}°C",
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
                                          Image.asset(asset),
                                          Text(
                                            "${_userModel!.hourly!.temperature2M![nextIndex22]}°C",
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
                                                      "${_userModel!.hourly!.apparentTemperature![nextIndex22]}°C",
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
                                        Image.asset(asset),
                                        Text(
                                          "${_userModel!.hourly!.temperature2M![nextIndex23]}°C",
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
                                          Image.asset(asset),
                                          Text(
                                            "${_userModel!.hourly!.temperature2M![nextIndex23]}°C",
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
                                                      "${_userModel!.hourly!.apparentTemperature![nextIndex23]}°C",
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
                                        Image.asset(asset),
                                        Text(
                                          "${_userModel!.hourly!.temperature2M![nextIndex24]}°C",
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
                                          Image.asset(asset),
                                          Text(
                                            "${_userModel!.hourly!.temperature2M![nextIndex24]}°C",
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
                                                      "${_userModel!.hourly!.apparentTemperature![nextIndex24]}°C",
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
                                        Image.asset(asset),
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
                                          Image.asset(asset),
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
                                        Image.asset(asset),
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
                                          Image.asset(asset),
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
                                        Image.asset(asset),
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
                                          Image.asset(asset),
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
                                        Image.asset(asset),
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
                                          Image.asset(asset),
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
                                        Image.asset(asset),
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
                                          Image.asset(asset),
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
                                        Image.asset(asset),
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
                                          Image.asset(asset),
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
                                        Image.asset(asset),
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
                                          Image.asset(asset),
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
                                        Image.asset(asset),
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
                                          Image.asset(asset),
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
