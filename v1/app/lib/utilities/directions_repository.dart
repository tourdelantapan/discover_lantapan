import 'package:app/models/directions_model.dart';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DirectionsRepository {
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';

  Future<Directions> getDirections({
    required LatLng origin,
    required LatLng dest,
  }) async {
    final response = await Dio().get(_baseUrl, queryParameters: {
      'origin': '${origin.latitude},${origin.longitude}',
      'destination': '${dest.latitude},${dest.longitude}',
      'key': "AIzaSyDTWLi_4rcmbPblZxSV9VETfoPvwI4tTHM"
    });

    if (response.statusCode == 200) {
      return Directions.fromMap(response.data);
    }
    return Future.error("An error occurred");
  }
}
