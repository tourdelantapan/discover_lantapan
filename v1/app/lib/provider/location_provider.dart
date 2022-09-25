// ignore_for_file: non_constant_identifier_names

import 'package:app/models/directions_model.dart';
import 'package:app/models/place_model.dart';
import 'package:app/utilities/constants.dart';
import 'package:app/utilities/directions_repository.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationProvider extends ChangeNotifier {
  LatLng _coordinates = const LatLng(8.143548493162127, 125.13147031688014);
  LatLng get coordinates => _coordinates;

  Place _destination =
      placeNoData; //Cafe sa Bukid, Must be changed depending on user selection
  Place get destination => _destination;
  CameraPosition _initialCameraPosition = CameraPosition(
    target: const LatLng(8.143548493162127, 125.13147031688014),
    zoom: mapZoom,
  );
  CameraPosition get initialCameraPosition => _initialCameraPosition;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  String _address = "";
  String get address => _address;

  Set<Polyline> polylines = {};
  Directions? info;
  List<LatLng> polylineCoordinates = [];
  List<String> stepsInstructions = [];

  double _distance = 0;
  double get distance => _distance;
  double _liters = 0;
  double get liters => _liters;
  double _fuelPrice = 0;
  double get fuelPrice => _fuelPrice;

  setDestination(Place place) {
    _destination = place;
    _initialCameraPosition = CameraPosition(
      target: place.coordinates,
      zoom: mapZoom,
    );
    notifyListeners();
  }

  calculateGasFuelPrice({required double distanceByMeters}) {
    _distance = distanceByMeters / 1000;
    _liters = _distance / 12.5;
    _fuelPrice = _liters * 74.20;
  }

  resetMarkers() {
    markers = <MarkerId, Marker>{};
    notifyListeners();
  }

  setMarker(String markerName, LatLng coordinates) {
    MarkerId markerId = MarkerId(markerName);
    Marker destinationMarker = Marker(
      markerId: markerId,
      position: coordinates,
      infoWindow: InfoWindow(title: markerName, snippet: '*'),
      onTap: () {},
    );
    markers[markerId] = destinationMarker;
    notifyListeners();
  }

  // Current location of user
  setCoordinates(LatLng coordinates, String address) {
    _coordinates = coordinates;
    _address = address;

    MarkerId locationMarkerId = const MarkerId("location");
    Marker locationMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(.5),
      markerId: locationMarkerId,
      position: coordinates,
      infoWindow: const InfoWindow(title: "location", snippet: '*'),
      onTap: () {},
    );
    markers[locationMarkerId] = locationMarker;
    notifyListeners();
    _getPolyline();
  }

  _getPolyline() async {
    LatLng origin = _coordinates;
    LatLng dest = _destination.coordinates;
    Directions? direction = await DirectionsRepository.getDirections(
        location: origin, destination: dest);
    if (direction != null) {
      info = direction;
      calculateGasFuelPrice(distanceByMeters: direction.routes[0].distance);
      polylineCoordinates.clear();
      direction.routes[0].geometry.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
      notifyListeners();

      _addPolyLine();
    }
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        width: 5,
        color: Colors.red,
        points: polylineCoordinates);
    polylines.add(polyline);

    stepsInstructions = [];
    // for (int i = 0; i <= info.totalSteps.length; i++) {
    //   stepsInstructions.add(removeAllHtmlTags(
    //       info.totalSteps[i]['html_instructions'].toString()));
    // }
  }

  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlText.replaceAll(exp, ' ');
  }
}
