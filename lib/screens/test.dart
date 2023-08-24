import "package:flutter/material.dart";
import "package:geocoding/geocoding.dart";
import "package:geolocator/geolocator.dart";

class CoordTest extends StatefulWidget {
  const CoordTest({super.key});

  @override
  State<CoordTest> createState() => _CoordTestState();
}

class _CoordTestState extends State<CoordTest> {
  double? latitude;
  double? longitude;
  String? locationMessage;

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

  String _city = "";
  String _additionalInfo = "";
  Future<bool> getCurrentLocationCoord() async {
    try {
      Position position = await _getCurrentLocation();
      if (position != null) {
        longitude = position.longitude;
        latitude = position.latitude;
        debugPrint("Lokasyon Verileri: $longitude , $latitude");
        setState(() {});
        List<Placemark> placemarks =
            await placemarkFromCoordinates(latitude!, longitude!);

        if (placemarks.isNotEmpty) {
          Placemark placemark = placemarks.first;

          print('Placemark: $placemark');

          setState(() {
            _city = placemark.administrativeArea ?? 'City not available';
            _additionalInfo = placemark.subLocality ?? '';
          });
        }
        return true;
      } else {
        debugPrint("boş veri");
        throw ("Lokasyon Verileri boş geldi");
      }
    } catch (e) {
      debugPrint("catch içinde hata");
      throw ("Lokasyon Çekerken Hata : ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          TextButton(
            onPressed: () async {
              if (await getCurrentLocationCoord()) {
                locationMessage =
                    "Latitude: ${latitude.toString()}, Longitude: ${longitude.toString()}, City: $_city";
                debugPrint("OutlinedButton from Homepage : $locationMessage");
                setState(() {
                  locationMessage =
                      "Latitude: ${latitude.toString()}, Longitude: ${longitude.toString()}, City: $_city";
                  debugPrint("OutlinedButton from Homepage : $locationMessage");
                });
              } else {
                debugPrint("hata buton0");
                setState(() {
                  debugPrint("hata buton1");
                  locationMessage = "Lokasyon verileri Hatalı";
                  debugPrint("hata buton");
                });
              }
            },
            child: Text(
              "Konum Göster",
              style: TextStyle(fontSize: 40, color: Colors.white),
            ),
          ),
          Text(locationMessage ?? "Hata Var")
        ],
      ),
    );
  }
}
//   import 'package:flutter/material.dart';
//   import 'package:geocoding/geocoding.dart';
//   import 'package:geolocator/geolocator.dart';

//   class DenemeCord extends StatefulWidget {
//     @override
//     _DenemeCordState createState() => _DenemeCordState();
//   }

//   class _DenemeCordState extends State<DenemeCord> {
//     String _city = '';
//     String _additionalInfo = '';

//    @override
//    void initState() {
//      super.initState();
//      _getUserLocation();
//    }

//  void _getUserLocation() async {
//    Position position = await Geolocator.getCurrentPosition();
//    double latitude = position.latitude;
//    double longitude = position.longitude;

//    print('Latitude: $latitude, Longitude: $longitude');

//    List<Placemark> placemarks =
//        await placemarkFromCoordinates(latitude, longitude);

//    if (placemarks.isNotEmpty) {
//      Placemark placemark = placemarks.first;

//      print('Placemark: $placemark');

//      setState(() {
//        _city = placemark.locality ?? 'City not available';
//        _additionalInfo = placemark.subLocality ?? '';
//      });
//    }
//  }

//    @override
//    Widget build(BuildContext context) {
//      return MaterialApp(
//        home: Scaffold(
//          appBar: AppBar(
//            title: Text('Get User Location'),
//          ),
//          body: Center(
//            child: Column(
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: [
//                Text('City: $_city'),
//                SizedBox(height: 16),
//                Text('Additional Info: $_additionalInfo'),
//              ],
//            ),
//          ),
//        ),
//      );
//    }
//  }
