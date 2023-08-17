import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

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

  List<String> days = [
    "Pazartesi",
    "Salı",
    "Çarşamba",
    "Perşembe",
    "Cuma",
    "Cumartesi",
    "Pazar"
  ];

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

  // void getHourlyDetails(int hourIndex) {
  //   int hissedilensicaklik = 35;
  //   int yagisolasiligi = 17;
  //   int nem = 30;
  //   int uv = 6;
  // }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
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
      return await Geolocator.getCurrentPosition();
    }

    String? latitude;
    String? longitude;
    late String? locationMessage = "";
    Future<void> _getCurrentLocationCoord() async {
      Position position = await _getCurrentLocation();

      latitude = '${position.latitude}';
      longitude = '${position.longitude}';
    }

    void _liveLocation() {
      LocationSettings locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );

      Geolocator.getPositionStream(locationSettings: locationSettings)
          .listen((Position position) {
        latitude = position.latitude.toString();
        longitude = position.longitude.toString();

        setState(() {
          locationMessage = 'Latitude: $latitude , Longitude: $longitude';
        });
      });
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

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () async {
                      await _getCurrentLocationCoord();

                      setState(() {
                        locationMessage =
                            'Latitude: $latitude , Longitude: $longitude';
                      });

                      debugPrint(locationMessage);
                      _liveLocation();
                    },
                    child: const Text("Konum"),
                  ),
                  const SizedBox(height: 20), // Adding some spacing
                  Text(
                    locationMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 40),
                  ),
                ],
              ),
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
                " 25 °C",
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
                  fontSize: 25,
                ),
              ),
              Text(
                "Hissedilen Sıcaklık: 28 °C",
                textAlign: TextAlign.center,
                style: GoogleFonts.oswald(
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
              //Lowest and Highest Degree of Today
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "En Düşük: 21°",
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
                    "En Yüksek: 41°",
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
                                          "  25°",
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
                                            "  25°",
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
                                          width: 190,
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
                                                      "35 °C",
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
                                                      "%99",
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
                                                      "%100",
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                "  40°",
                                style: GoogleFonts.oswald(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                "  40°",
                                style: GoogleFonts.oswald(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                "  40°",
                                style: GoogleFonts.oswald(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                "  40°",
                                style: GoogleFonts.oswald(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                "  40°",
                                style: GoogleFonts.oswald(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                "  40°",
                                style: GoogleFonts.oswald(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                "  40°",
                                style: GoogleFonts.oswald(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                "  40°",
                                style: GoogleFonts.oswald(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                "  40°",
                                style: GoogleFonts.oswald(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                "  40°",
                                style: GoogleFonts.oswald(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                "  40°",
                                style: GoogleFonts.oswald(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                "  40°",
                                style: GoogleFonts.oswald(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                "  40°",
                                style: GoogleFonts.oswald(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                "  40°",
                                style: GoogleFonts.oswald(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                "  40°",
                                style: GoogleFonts.oswald(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                "  40°",
                                style: GoogleFonts.oswald(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                "  40°",
                                style: GoogleFonts.oswald(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                "  40°",
                                style: GoogleFonts.oswald(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                "  40°",
                                style: GoogleFonts.oswald(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                "  40°",
                                style: GoogleFonts.oswald(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                "  40°",
                                style: GoogleFonts.oswald(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                "  40°",
                                style: GoogleFonts.oswald(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                "  40°",
                                style: GoogleFonts.oswald(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                "  40°",
                                style: GoogleFonts.oswald(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20,
                                ),
                              ),
                            ],
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
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                child: Card(
                  child: Expanded(
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
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
                                              "36°",
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
                                        ],
                                      ),
                                    ),
                                    expanded: Column(children: [
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
                                              "36°",
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
                                                  "39 °C",
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
                                                  "22 °C",
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
                                                  "%15",
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
                                                  "15km/sa",
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
                                                  "Güneydoğu",
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
                                                      CupertinoIcons
                                                          .chevron_up)),
                                            ),
                                          ],
                                        ),
                                      )
                                    ]))
                              ],
                            ))),
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  nextDay1,
                                  style: GoogleFonts.oswald(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 35,
                                  ),
                                ),
                              ),
                              Image.asset(asset),
                              Expanded(
                                child: Text(
                                  "35°",
                                  textAlign: TextAlign.end,
                                  style: GoogleFonts.oswald(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 35,
                                  ),
                                ),
                              ),
                            ],
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  nextDay2,
                                  style: GoogleFonts.oswald(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 35,
                                  ),
                                ),
                              ),
                              Image.asset(asset),
                              Expanded(
                                child: Text(
                                  "38°",
                                  textAlign: TextAlign.end,
                                  style: GoogleFonts.oswald(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 35,
                                  ),
                                ),
                              ),
                            ],
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  nextDay3,
                                  style: GoogleFonts.oswald(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 35,
                                  ),
                                ),
                              ),
                              Image.asset(asset),
                              Expanded(
                                child: Text(
                                  "36°",
                                  textAlign: TextAlign.end,
                                  style: GoogleFonts.oswald(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 35,
                                  ),
                                ),
                              ),
                            ],
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  nextDay4,
                                  style: GoogleFonts.oswald(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 35,
                                  ),
                                ),
                              ),
                              Image.asset(asset),
                              // SizedBox(
                              //   width: 25,
                              // ),
                              Expanded(
                                child: Text(
                                  "35°",
                                  textAlign: TextAlign.end,
                                  style: GoogleFonts.oswald(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 35,
                                  ),
                                ),
                              ),
                            ],
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  nextDay5,
                                  style: GoogleFonts.oswald(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontSize: 35,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                              Image.asset(asset),
                              Expanded(
                                child: Text(
                                  "38°",
                                  textAlign: TextAlign.end,
                                  style: GoogleFonts.oswald(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 35,
                                  ),
                                ),
                              ),
                            ],
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  nextDay6,
                                  style: GoogleFonts.oswald(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 35,
                                  ),
                                ),
                              ),
                              Image.asset(asset),
                              // SizedBox(
                              //   width: 25,
                              // ),
                              Expanded(
                                child: Text(
                                  "35°",
                                  textAlign: TextAlign.end,
                                  style: GoogleFonts.oswald(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 35,
                                  ),
                                ),
                              ),
                            ],
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  nextDay7,
                                  style: GoogleFonts.oswald(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 35,
                                  ),
                                ),
                              ),
                              Image.asset(asset),
                              Expanded(
                                child: Text(
                                  "38°",
                                  textAlign: TextAlign.end,
                                  style: GoogleFonts.oswald(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 35,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
                              "05.36",
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
                              "20.18",
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
                              "6 km/sa",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.oswald(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w400,
                                fontSize: 25,
                              ),
                            ),
                            Text(
                              "Batı",
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
                              "%14",
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
                              "24 km",
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
                              "0mm",
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
                              "36 °C",
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
                              "%26",
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
                              "8",
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
                              "1010 pHa",
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
