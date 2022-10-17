// To parse this JSON data, do
//
//     final philippines = philippinesFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<Philippines> philippinesFromJson(String str) => List<Philippines>.from(
    json.decode(str).map((x) => Philippines.fromJson(x)));

String philippinesToJson(List<Philippines> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Philippines {
  Philippines({
    required this.id,
    required this.name,
    required this.provinces,
  });

  String id;
  String name;
  List<Province> provinces;

  factory Philippines.fromJson(Map<String, dynamic> json) => Philippines(
        id: json["_id"],
        name: json["name"],
        provinces: List<Province>.from(
            json["provinces"].map((x) => Province.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "provinces": List<dynamic>.from(provinces.map((x) => x.toJson())),
      };
}

class Province {
  Province({
    required this.id,
    required this.name,
    required this.citymunicipalities,
  });

  String id;
  String name;
  List<Citymunicipality> citymunicipalities;

  factory Province.fromJson(Map<String, dynamic> json) => Province(
        id: json["_id"],
        name: json["name"],
        citymunicipalities: List<Citymunicipality>.from(
            json["citymunicipalities"]
                .map((x) => Citymunicipality.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "citymunicipalities":
            List<dynamic>.from(citymunicipalities.map((x) => x.toJson())),
      };
}

class Citymunicipality {
  Citymunicipality({
    required this.id,
    required this.name,
  });

  String id;
  String name;

  factory Citymunicipality.fromJson(Map<String, dynamic> json) =>
      Citymunicipality(
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
      };
}
