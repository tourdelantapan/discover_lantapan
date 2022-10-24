import 'dart:convert';
import 'package:app/models/philippines_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show rootBundle;

class AppProvider extends ChangeNotifier {
  String _sample = "Hello World";
  String get sample => _sample;
  List<Philippines> philippines = [];

  setSample(String sample) {
    _sample = sample;
    notifyListeners();
  }

  Future<String> getPhilippinesJson() {
    return rootBundle.loadString('assets/json/philippines.json');
  }

  getPhilippines() async {
    var _philippines = json.decode(await getPhilippinesJson());
    philippines = List<Philippines>.from(
        _philippines.map((x) => Philippines.fromJson(x)));
  }
}
