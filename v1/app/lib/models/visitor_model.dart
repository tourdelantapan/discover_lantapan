// To parse this JSON data, do
//
//     final visitor = visitorFromJson(jsonString);

import 'package:app/models/place_model.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

Visitor visitorFromJson(String str) => Visitor.fromJson(json.decode(str));

String visitorToJson(Visitor data) => json.encode(data.toJson());

class Visitor {
  Visitor({
    required this.id,
    required this.fullName,
    required this.contactNumber,
    required this.dateOfVisit,
    required this.homeAddress,
    required this.numberOfVisitors,
    required this.placeId,
    required this.createdAt,
    required this.updatedAt,
  });

  String id;
  String fullName;
  String contactNumber;
  DateTime dateOfVisit;
  String homeAddress;
  int numberOfVisitors;
  Place placeId;
  DateTime createdAt;
  DateTime updatedAt;

  factory Visitor.fromJson(Map<String, dynamic> json) => Visitor(
        id: json["_id"],
        fullName: json["fullName"],
        contactNumber: json["contactNumber"],
        dateOfVisit: DateTime.parse(json["dateOfVisit"]),
        homeAddress: json["homeAddress"],
        numberOfVisitors: json["numberOfVisitors"],
        placeId: Place.fromJson(json["placeId"]),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "fullName": fullName,
        "contactNumber": contactNumber,
        "dateOfVisit": dateOfVisit.toIso8601String(),
        "homeAddress": homeAddress,
        "numberOfVisitors": numberOfVisitors,
        "placeId": placeId.toJson(),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
