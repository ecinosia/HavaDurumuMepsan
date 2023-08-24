import 'package:syncfusion_flutter_maps/maps.dart';

class MarkerLocations {
  static final MarkerLocations _instance = MarkerLocations._internal();

  factory MarkerLocations() => _instance;

  MarkerLocations._internal();

  List<MapLatLng> _markerList = [];

  List<MapLatLng> get markers => _markerList;
}
