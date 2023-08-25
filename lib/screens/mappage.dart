// ignore_for_file: unused_element

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart' as loc;
import 'package:syncfusion_flutter_maps/maps.dart';
import 'homepage.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

//

class _MapPageState extends State<MapPage> {
  Future<loc.LocationData?> _currentLocation() async {
    bool serviceEnabled;
    loc.PermissionStatus permissionGranted;

    loc.Location location = loc.Location();

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) {
        return null;
      }
    }
    return await location.getLocation();
  }

  late MapZoomPanBehavior? _mapZoomPanBehavior;

  @override
  void initState() {
    _mapZoomPanBehavior =
        MapZoomPanBehavior(); //..focalLatLng = MapLatLng(0, 0)
    populateCityNames();
    super.initState();
  }

// Update focal point and zoom
  void _handleTap(MapLatLng tapPoint) {
    _mapZoomPanBehavior!.focalLatLng = tapPoint;
    _mapZoomPanBehavior!.zoomLevel = 12;
  }

// Zoom in/out
  void _handlePinch(ScaleUpdateDetails details) {
    _mapZoomPanBehavior!.zoomLevel *= details.scale;
  }

// Pan
  void _handlePan(DragUpdateDetails details) {
    if (_mapZoomPanBehavior?.focalLatLng != null) {
      final focal = _mapZoomPanBehavior?.focalLatLng!;
      final deltaLat = details.delta.dy;
      final deltaLng = details.delta.dx;

      final newLat = focal!.latitude + deltaLat;
      final newLng = focal.longitude + deltaLng;

      _mapZoomPanBehavior?.focalLatLng = MapLatLng(newLat, newLng);
    }
  }

  final List<MapLatLng> _markerLocations = [
    const MapLatLng(39.9334, 32.8597),
    const MapLatLng(37.1674, 38.7955),
    const MapLatLng(40.9862, 37.8797),
  ];

  final List _cityNameList = [];

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
  Future<String> getCityNameMap(double lat, double long) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);

    if (placemarks.isNotEmpty) {
      Placemark placemark = placemarks.first;

      setState(() {
        _city = placemark.administrativeArea ?? 'City not available';
      });
    }

    return _city;
  }

  Future<void> populateCityNames() async {
    for (var loc in _markerLocations) {
      _cityNameList.add(await getCityNameMap(loc.latitude, loc.longitude));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Harita Görünümü",
            style: GoogleFonts.barlowCondensed(
                textStyle: const TextStyle(
                    fontSize: 35, fontWeight: FontWeight.w300))),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomePage()));
            },
            icon: const Icon(CupertinoIcons.chevron_back)),
        actions: <Widget>[
          IconButton(
            icon: const Icon(CupertinoIcons.question_diamond),
            onPressed: () {
              setState(() {
                Widget okButton = TextButton(
                  child: const Text("Tamam"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                );
                AlertDialog alert = AlertDialog(
                  title: Text("Harita Görünümü Nedir?",
                      style: GoogleFonts.barlowCondensed(
                          textStyle: const TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w300))),
                  content: Text(
                    "Harita görünümü ile hava durumunu takip etmek için eklediğiniz şehirleri harita üzerinde görebilirsiniz.",
                    style: GoogleFonts.dmSans(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                    ),
                  ),
                  actions: [
                    okButton,
                  ],
                );

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return alert;
                  },
                );
              });
            },
          )
        ],
      ),
      body: FutureBuilder<loc.LocationData?>(
        future: _currentLocation(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapchat) {
          if (snapchat.hasData) {
            final loc.LocationData currentLocation = snapchat.data;
            getCityNameMap(
                currentLocation.latitude!, currentLocation.longitude!);

            _markerLocations.insert(
                0,
                MapLatLng(
                    currentLocation.latitude!, currentLocation.longitude!));
            return SfMaps(
              layers: [
                MapTileLayer(
                  zoomPanBehavior: _mapZoomPanBehavior,
                  initialFocalLatLng: MapLatLng(
                      currentLocation.latitude!, currentLocation.longitude!),
                  initialZoomLevel: 7,
                  initialMarkersCount: _markerLocations.length,
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  markerBuilder: (BuildContext context, int index) {
                    final markerLoc = _markerLocations[index];
                    return MapMarker(
                      latitude: markerLoc.latitude,
                      longitude: markerLoc.longitude,
                      size: const Size(50, 85),
                      child: Column(
                        children: [
                          // Text(
                          //   _city.toString() ?? "HATA",
                          //   style: const TextStyle(
                          //       color: Colors.amber, fontSize: 38),
                          // ),
                          Icon(
                            Icons.location_on,
                            color: Colors.red[800],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: IconButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(25),
                ),
              ),
              builder: (BuildContext context) {
                return ListView.builder(
                  itemCount: _cityNameList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {},
                      title: Text(_cityNameList[index]),
                    );
                  },
                );
              });
        },
        icon: const Icon(
          CupertinoIcons.list_bullet_indent,
          size: 50,
          color: Colors.deepOrange,
        ),
      ),
    );
  }
}
