// To parse this JSON data, do
//
//     final brand = brandFromJson(jsonString);

import 'dart:convert';

Brand brandFromJson(String str) => Brand.fromJson(json.decode(str));

String brandToJson(Brand data) => json.encode(data.toJson());

class Brand {
  List<BrandElement> brands;

  Brand({
    required this.brands,
  });

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
        brands: List<BrandElement>.from(
            json["brands"].map((x) => BrandElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "brands": List<dynamic>.from(brands.map((x) => x.toJson())),
      };
}

class BrandElement {
  int id;
  String name;
  String website;
  String description;
  String image;

  BrandElement({
    required this.id,
    required this.name,
    required this.website,
    required this.description,
    required this.image,
  });

  factory BrandElement.fromJson(Map<String, dynamic> json) => BrandElement(
        id: json["id"],
        name: json["name"],
        website: json["website"],
        description: json["description"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "website": website,
        "description": description,
        "image": image,
      };
}
