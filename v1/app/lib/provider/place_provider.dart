// ignore_for_file: non_constant_identifier_names

import 'package:app/models/place_model.dart';
import 'package:app/services/api_services.dart';
import 'package:app/services/api_status.dart';
import 'package:flutter/cupertino.dart';

class PlaceProvider extends ChangeNotifier {
  List<String> _loading = [];
  List<String> get loading => _loading;

  List<Place> _popularPlaces = [];
  List<Place> get popularPlaces => _popularPlaces;

  List<Place> _newPlaces = [];
  List<Place> get newPlaces => _newPlaces;

  List<Place> _topRatedPlaces = [];
  List<Place> get topRatedPlaces => _topRatedPlaces;

  List<Place> _searchResult = [];
  List<Place> get searchResult => _searchResult;

  Place _placeInfo = placeNoData;
  Place get placeInfo => _placeInfo;

  addLoading(String loading) {
    _loading.add(loading);
    notifyListeners();
  }

  removeLoading(String loading) {
    _loading.removeWhere((e) => e == loading);
    notifyListeners();
  }

  getPlaces(
      {required Map<String, dynamic> query, required Function callback}) async {
    addLoading(query["mode"]);
    var response = await APIServices.get(endpoint: "/places", query: query);
    if (response is Success) {
      List<Place> places = List<Place>.from(
          response.response["data"]["places"].map((x) => Place.fromJson(x)));
      if (query["mode"] == "popular") {
        _popularPlaces = places;
      }
      if (query["mode"] == "new") {
        _newPlaces = places;
      }
      if (query["mode"] == "top_rated") {
        _topRatedPlaces = places;
      }
      if (query["mode"] == "search") {
        _searchResult = places;
      }
      removeLoading(query["mode"]);
      notifyListeners();
      callback(response.code, response.response["message"] ?? "Success.");
    }
    if (response is Failure) {
      callback(response.code, response.response["message"] ?? "Failed.");
      removeLoading(query["mode"]);
    }
  }

  getPlace({required String placeId, required Function callback}) async {
    addLoading("place-info");
    await Future.delayed(const Duration(seconds: 1));
    var response = await APIServices.get(endpoint: "/places/$placeId");
    if (response is Success) {
      _placeInfo = Place.fromJson(response.response["data"]["place"]);
      removeLoading("place-info");
      notifyListeners();
      callback(response.code, response.response["message"] ?? "Success.");
    }
    if (response is Failure) {
      callback(response.code, response.response["message"] ?? "Failed.");
      removeLoading("place-info");
    }
  }

  likePlace(
      {required String mode,
      required int index,
      required String placeId,
      required Function callback}) async {
    executeLike(state) {
      if (mode == "single" && index == -1) {
        _placeInfo.isLiked = state ?? !_placeInfo.isLiked;
      }
      if (mode == "popular") {
        _popularPlaces[index].isLiked = state ?? !_popularPlaces[index].isLiked;
      }
      if (mode == "new") {
        _newPlaces[index].isLiked = state ?? !_newPlaces[index].isLiked;
      }
      if (mode == "top_rated") {
        _topRatedPlaces[index].isLiked =
            state ?? !_topRatedPlaces[index].isLiked;
      }
      if (mode == "search") {
        _searchResult[index].isLiked = state ?? !_searchResult[index].isLiked;
      }
      notifyListeners();
    }

    executeLike(null);
    var response = await APIServices.get(endpoint: "/places/like/$placeId");

    if (response is Success) {
      bool result = response.response["data"]["isLiked"];
      executeLike(result);
      callback(response.code, response.response["message"] ?? "Success.");
    }
    if (response is Failure) {
      executeLike(null);
      callback(response.code, response.response["message"] ?? "Failed.");
    }
  }
}
