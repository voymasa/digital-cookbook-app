/*
Aaron Voymas
Lab 3
This dart file contains model classes related to each of the meal models,
such as list, meal details, etc
 */

class MealListResult {
  List<MealDetailModel> list = [];
  int numMeals = 0;
  String errorMessage = ''; // for error checking and handling
}

class MealDetailModel {
  int? id;
  late String mealId;
  late String name;
  late String? altName;
  late String category;
  late String country;
  late String instructions;
  late String thumbnailUrl;
  late Map<String, dynamic> ingredients; // combine the ingredients and measures into a key-value pair
  late String sourceUrl; // this is where the recipe was imported from into the mealdb
  bool savedToDb = false; // this will be used to tell the ui whether the specific recipe is saved to the local db and should be used in coordination with the functions to save and delete from the db

  final int maxCount = 20; // this is the maximum number of ingredients and measurements that are passed from the api; could pair the indices if necessary;

  MealDetailModel(this.mealId,
      this.name,
      this.altName,
      this.category,
      this.country,
      this.instructions,
      this.thumbnailUrl,
      this.sourceUrl,
      this.ingredients);

  MealDetailModel.fromJson(Map<String, dynamic> json) {
    this.mealId = json["idMeal"];
    this.name = json["strMeal"];
    this.altName = json["strMealAlternate"] ?? '';
    this.category = json["strCategory"];
    this.country = json["strArea"];
    this.instructions = json["strInstructions"];
    this.thumbnailUrl = json["strMealThumb"];
    // iterate list of 20 ingredients and their corresponding measure; set the ingredient as the key and the measure as the value
    ingredients = Map.identity();
    for (int i = 1; i <= maxCount; i++) {
      String ingKey = json["strIngredient" + i.toString()] ?? ''; // ingredient as key
      String measValue = json["strMeasure" + i.toString()] ?? ''; // measurement as value
      this.ingredients[ingKey] = measValue;
    }
    this.sourceUrl = json["strSource"] ?? '';
  }

  Map<String, dynamic> toMap() {
    return {
      'mealId': mealId,
      'name': name,
      'altName': altName,
      'category': category,
      'country': country,
      'instructions': instructions,
      'thumbNailUrl': thumbnailUrl,
      'sourceUrl': sourceUrl,
      'ingredients': ingredients
    };
  }

  static MealDetailModel fromMap(Map<String, dynamic> map) {
    return MealDetailModel(
      map['mealId'],
      map['name'],
      map['altName'],
      map['category'],
      map['country'],
      map['instructions'],
      map['thumbNailUrl'],
      map['sourceUrl'],
      map['ingredients']
      // _mapFromIngredients(map)
    );
  }

  // this method is to convert from a map that is structured like the data from mealdb, but I would rather have a data structure with iteration capability and pairing the measurements to the ingredients
  static Map<String, dynamic> _mapFromIngredients(Map<String, dynamic> ingMap) {
    final int maxCount = 20; // there are 20 fields for ingredient and measure from mealdb
    Map<String, dynamic> map = Map.identity();
    for (int i = 1; i <= maxCount; i++) {
      String key = ingMap['strIngredient' + i.toString()] ?? '';
      String val = ingMap['strMeasure' + i.toString()] ?? '';
      map[key] = val;
    }
    return map;
  }
}