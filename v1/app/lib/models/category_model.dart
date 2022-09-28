import 'dart:convert';

Category categoryFromJson(String str) => Category.fromJson(json.decode(str));

String categoryToJson(Category data) => json.encode(data.toJson());

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

List<Category> categories = [
  Category(id: "632eb7089b2aa14a39bc62ed", name: "Cafe"),
  Category(id: "632eb7349b2aa14a39bc7032", name: "Resort"),
  Category(id: "632eb73f9b2aa14a39bc72cd", name: "Restaurant"),
  Category(id: "632eb8eb9b2aa14a39bcdeec", name: "Farm"),
];
