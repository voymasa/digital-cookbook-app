/*
Aaron Voymas
Lab 3
This class provides functionality to make web requests
 */

import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../data/meal_models.dart';
import '../data/area_model.dart';
import '../data/category_model.dart';
import '../data/ingredient_model.dart';

class HttpService {
  final String hostUrl = 'www.themealdb.com'; // this contains the api key of 1 for dev key. the specific action is tagged onto the url
  final String apiUrlSegment = 'api/json/v1/1';
  final String searchUrl = '/search.php'; // this is used to search meals by name or first letter; s=name or f=firstletter query
  final String lookupUrl = '/lookup.php'; // this is used to get the full details of a meal. the query will be i=mealid
  final String randomUrl = '/random.php'; // this is used to get a single random meal
  final String categoryUrl = '/categories.php'; // this is used to get the list of meal categories
  final String filterUrl = '/filter.php'; // this is used to filter meals. the query will be i=ingredientname, c=categoryname, or a=areaname
  final String listUrl = '/list.php'; // this is used to get the list of c=list, a=list, or i=list, all categories, areas, or ingredients

  // try a one-size-fits all because the dev api returns the same result map with the same keys regardless, so
  // we really only need to handle the path value for the uri and the query parameters
  /// This method takes in a list of paths and a map of queries, constructs the Uri to send the request
  /// to, and then returns the results of a get request to teh targetUri.
  /// @targetPath: this is a string that represents the endpoint targeted such as search, random, list, etc
  /// @query: this is a string that represents the one query parameter that is required for most endpoints such as c=list; thankfully the api ignores query params for the random.php path (tested)
  Future<MealListResult> getRecipes(String targetPath, String query) {
    final Uri targetUri = Uri(scheme: 'https', host: hostUrl, path: apiUrlSegment + targetPath, query: query);
    return handleGetRequest(targetUri);
  }

  // the api literally will respond the same way, and the only diff is what as passed as the uri
  Future<MealListResult> handleGetRequest(Uri targetUri) async {
    MealListResult meals = MealListResult();
    http.Response result = await http.get(targetUri);
    if (result.statusCode == HttpStatus.ok) {
      final response = json.decode(result.body);
      final mealResults = response["meals"];
      if (mealResults == null) return meals; // if the search results return empty for the keywords then just return the empty list that is already in meals.
      List list = mealResults.map((i) => MealDetailModel.fromJson(i)).toList();
      list.forEach((meal) => meals.list.add(meal));
    } else {
      meals.errorMessage = result.statusCode.toString();
    }
    return meals;
  }

  Future<CategoryListResult> getAllCategories() async {
    CategoryListResult categories = CategoryListResult();
    final Uri targetUri = Uri(scheme: 'https', host: hostUrl, path: apiUrlSegment + listUrl, query:'c=list');

    http.Response result = await http.get(targetUri);
    if (result.statusCode == HttpStatus.ok) {
      final response = json.decode(result.body);
      final categoryResults = response["meals"];
      List list = categoryResults.map((i) => CategoryModel.fromJson(i)).toList();
      list.forEach((cat) => categories.categories.add(cat));
    } else {
      categories.errorMessage = result.statusCode.toString();
    }
    return categories;
  }

  Future<AreaListResult> getAllAreas() async {
    AreaListResult areas = AreaListResult();
    final Uri targetUri = Uri(scheme: 'https', host: hostUrl, path: apiUrlSegment + listUrl, query: 'a=list');

    http.Response result = await http.get(targetUri);
    if (result.statusCode == HttpStatus.ok) {
      final response = json.decode(result.body);
      final areaResults = response["meals"];
      List list = areaResults.map((i) => AreaModel.fromJson(i)).toList();
      list.forEach((area) => areas.list.add(area));
    } else {
      areas.errorMessage = result.statusCode.toString();
    }
    return areas;
  }

  Future<IngredientListResult> getAllIngredients() async {
    IngredientListResult ingredients = IngredientListResult();
    final Uri targetUri = Uri(scheme: 'https', host: hostUrl, path: apiUrlSegment + listUrl, query: 'i=list');

    http.Response result = await http.get(targetUri);
    if (result.statusCode == HttpStatus.ok) {
      final response = json.decode(result.body);
      final ingResults = response["meals"];
      List list = ingResults.map((i) => IngredientModel.fromJson(i)).toList();
      list.forEach((ing) => ingredients.list.add(ing));
    } else {
      ingredients.errorMessage = result.statusCode.toString();
    }
    return ingredients;
  }
}