// To parse this JSON data, do
//
//     final place = placeFromJson(jsonString);

import 'package:app/models/dashboard/dashboard_like.dart';
import 'package:app/models/photo_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

Place placeFromJson(String str) => Place.fromJson(json.decode(str));

String placeToJson(Place data) => json.encode(data.toJson());

class Place {
  Place({
    required this.id,
    required this.name,
    required this.address,
    required this.coordinates,
    required this.categoryId,
    required this.photos,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.isLiked,
    required this.status,
    required this.reviewsStat,
    required this.favorites,
  });

  String id;
  String name;
  String address;
  String description;
  LatLng coordinates;
  Category categoryId;
  List<Photo> photos;
  DateTime createdAt;
  DateTime updatedAt;
  bool isLiked;
  String status;
  ReviewsStat reviewsStat;
  Favorites favorites;

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json["_id"],
      name: json["name"],
      address: json["address"],
      coordinates: LatLng(
          double.parse(json["coordinates"]["latitude"].toString()),
          double.parse(json["coordinates"]["longitude"].toString())),
      categoryId: Category.fromJson(json["categoryId"]),
      description: json["description"],
      status: json["status"],
      isLiked: json["isLiked"] == null ||
              json["isLiked"] == false ||
              json["isLiked"].toString() == "[]"
          ? false
          : true,
      photos: json["photos"] != null
          ? List<Photo>.from(json["photos"].map((x) => Photo.fromJson(x)))
          : [],
      createdAt: json["createdAt"] != null
          ? DateTime.parse(json["createdAt"])
          : DateTime.now(),
      updatedAt: json["updatedAt"] != null
          ? DateTime.parse(json["updatedAt"])
          : DateTime.now(),
      reviewsStat: !["[]", "null"].contains(json["reviewsStat"].toString())
          ? json["reviewsStat"].runtimeType == List
              ? ReviewsStat.fromJson(json["reviewsStat"][0])
              : ReviewsStat.fromJson(json["reviewsStat"])
          : ReviewsStat(average: 0, reviewerCount: 0),
      favorites: json["favorites"] != null
          ? Favorites.fromJson(json["favorites"])
          : Favorites(id: 0, count: 0),
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "address": address,
        "description": description,
        "isLiked": isLiked,
        "coordinates": coordinates.toJson(),
        "categoryId": categoryId,
        "status": status,
        "photos": List<dynamic>.from(photos.map((x) => x.toJson())),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}

class Category {
  Category({
    required this.id,
    required this.name,
  });

  String id;
  String name;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
      };
}

class Coordinates {
  Coordinates({
    required this.latitude,
    required this.longitude,
  });

  double latitude;
  double longitude;

  factory Coordinates.fromJson(Map<String, dynamic> json) => Coordinates(
        latitude: json["latitude"],
        longitude: json["longitude"],
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
      };
}

ReviewsStat reviewsStatFromJson(String str) =>
    ReviewsStat.fromJson(json.decode(str));

String reviewsStatToJson(ReviewsStat data) => json.encode(data.toJson());

class ReviewsStat {
  ReviewsStat({
    required this.average,
    required this.reviewerCount,
  });

  double average;
  int reviewerCount;

  factory ReviewsStat.fromJson(Map<String, dynamic> json) => ReviewsStat(
        average: json["average"].toDouble(),
        reviewerCount: json["reviewerCount"],
      );

  Map<String, dynamic> toJson() => {
        "average": average,
        "reviewerCount": reviewerCount,
      };
}

Place placeNoData = Place(
    id: "1",
    name: "No data",
    address: "No data",
    description: "No data",
    coordinates: const LatLng(10.3, 12.3),
    categoryId: Category(id: "48", name: "No data"),
    photos: [],
    isLiked: false,
    status: "OPEN",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    reviewsStat: ReviewsStat(average: 0, reviewerCount: 0),
    favorites: Favorites(id: 0, count: 0));
