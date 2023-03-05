import 'dart:convert';

Recipe RecipeFromJson(String str) => Recipe.fromJson(json.decode(str));

String RecipeToJson(Recipe data) => json.encode(data.toJson());
class Recipe {
  Recipe({
    required this.id,
    required this.recipeName,
    required this.description,
    required this.ingredients

  });
  String id;
  String recipeName;
  String description;
  String ingredients;


  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
    id: json["id"] ?? "",
    recipeName: json["recipeName"] ?? "",
    description: json["description"] ?? "",
    ingredients: json["ingredients"]?? "",

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "recipeName": recipeName,
    "description": description,
    "ingredients": ingredients,

  };
}
