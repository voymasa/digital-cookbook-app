/*
Aaron Voymas
Lab 3
This dart file contains model classes related to ingredients
 */

class IngredientListResult {
  List<IngredientModel> list = [];
  int numIngredients = 0;
  String errorMessage = '';
}

class IngredientModel {
  late String ingId;
  late String name;
  late String description;
  late String? type;

  IngredientModel(
      this.ingId,
      this.name,
      this.description,
      this.type
      );

  IngredientModel.fromJson(Map<String,dynamic> json) {
    this.ingId = json["idIngredient"];
    this.name = json["strIngredient"];
    this.description = json["strDescription"];
    this.type = json["strType"];
  }
}