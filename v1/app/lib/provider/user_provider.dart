import 'package:app/models/user_modal.dart';
import 'package:app/services/api_services.dart';
import 'package:app/services/api_status.dart';
import 'package:app/utilities/shared_preferences.dart';
import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier {
  String _loading = "stop";
  String get loading => _loading;

  User? _currentUser;
  User? get currentUser => _currentUser;

  setLoading(String loading) async {
    _loading = loading;
    notifyListeners();
  }

  setCurrentUser(User currentUser) {
    _currentUser = currentUser;
    notifyListeners();
  }

  profile({required Function callback}) async {
    var response = await APIServices.get(endpoint: "/profile");

    if (response is Success) {
      if (response.response["data"]["profile"] != null) {
        setCurrentUser(User.fromJson(response.response["data"]["profile"]));
      }
      callback(response.code, response.response["message"] ?? "Success.");
      setLoading("stop");
    }
    if (response is Failure) {
      callback(response.code, response.response["message"] ?? "Failed.");
      setLoading("stop");
    }
  }

  login(
      {required Map<String, dynamic> payload,
      required Function callback}) async {
    setLoading("login");
    var response = await APIServices.post(endpoint: "/login", payload: payload);
    if (response is Success) {
      setLoading("stop");
      setToken(response.response["data"]["accessToken"]);
      setCurrentUser(User.fromJson(response.response["data"]));
      callback(response.code, response.response["message"] ?? "Success.");
    }
    if (response is Failure) {
      setLoading("stop");
      callback(response.code, response.response["message"] ?? "Failed.");
    }
  }

  signOut() {
    setToken("");
    _currentUser = null;
    notifyListeners();
  }

  signup(
      {required Map<String, dynamic> payload,
      required Function callback}) async {
    setLoading("signup");
    var response =
        await APIServices.post(endpoint: "/signup", payload: payload);
    if (response is Success) {
      setLoading("stop");
      callback(response.code, response.response["message"] ?? "Success.");
    }
    if (response is Failure) {
      setLoading("stop");
      callback(response.code, response.response["message"] ?? "Failed.");
    }
  }
}
