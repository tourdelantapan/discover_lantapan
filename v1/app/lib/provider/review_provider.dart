// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:app/models/review_model.dart';
import 'package:app/services/api_services.dart';
import 'package:app/services/api_status.dart';
import 'package:flutter/cupertino.dart';

class ReviewProvider extends ChangeNotifier {
  List<String> _loading = [];
  List<String> get loading => _loading;

  List<Review> _review = [];
  List<Review> get review => _review;

  addLoading(String loading) {
    _loading.add(loading);
    notifyListeners();
  }

  removeLoading(String loading) {
    _loading.removeWhere((e) => e == loading);
    notifyListeners();
  }

  getReviews({required String placeId, required Function callback}) async {
    addLoading("reviews-list");
    var response = await APIServices.get(endpoint: "/places/reviews/$placeId");
    if (response is Success) {
      _review = List<Review>.from(
          response.response["data"]["reviews"].map((x) => Review.fromJson(x)));
      removeLoading("reviews-list");
      callback(response.code, response.response["message"] ?? "Success.");
    }
    if (response is Failure) {
      callback(response.code, response.response["message"] ?? "Failed.");
      removeLoading("reviews-list");
    }
  }

  postReview(
      {required Map<String, dynamic> payload,
      required List<File> files,
      required Function callback}) async {
    addLoading("post-review");
    await Future.delayed(const Duration(seconds: 1));
    var response = await APIServices.post(
        endpoint: "/places/review/add/${payload['placeId']}",
        payload: payload,
        files: files);
    if (response is Success) {
      removeLoading("post-review");
      notifyListeners();
      callback(response.code, response.response["message"] ?? "Success.");
    }
    if (response is Failure) {
      callback(response.code, response.response["message"] ?? "Failed.");
      removeLoading("post-review");
    }
  }
}
