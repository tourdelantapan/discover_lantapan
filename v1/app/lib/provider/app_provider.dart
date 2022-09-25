// ignore_for_file: non_constant_identifier_names

import 'package:flutter/cupertino.dart';

class AppProvider extends ChangeNotifier {
  String _sample = "Hello World";
  String get sample => _sample;

  setSample(String sample) {
    _sample = sample;
    notifyListeners();
  }

  // login(
  //     {required Map<String, dynamic> credentials,
  //     required Function callback}) async {
  //   setLoading("login");
  //   var response =
  //       await APIServices.post(endpoint: "/login", payload: credentials);
  //   if (response is Success) {
  //     setLoading("stop");
  //     setToken(response.response["data"]["accessToken"]);
  //     setCurrentUser(User.fromJson(response.response["data"]));
  //     callback(response.code, response.response["message"] ?? "Success.");
  //   }
  //   if (response is Failure) {
  //     setLoading("stop");
  //     callback(response.code, response.response["message"] ?? "Failed.");
  //   }
  // }

  // signup(
  //     {required Map<String, dynamic> credentials,
  //     required Function callback}) async {
  //   setLoading("signup");
  //   var response =
  //       await APIServices.post(endpoint: "/signup", payload: credentials);
  //   if (response is Success) {
  //     setLoading("stop");
  //     callback(response.code, response.response["message"] ?? "Success.");
  //   }
  //   if (response is Failure) {
  //     setLoading("stop");
  //     callback(response.code, response.response["message"] ?? "Failed.");
  //   }
  // }
}
