/*
Aaron Voymas
Lab 3
This class contains routes for navigation
 */

import 'package:flutter/material.dart';
import 'package:lab_3/data/meal_models.dart';
import 'package:lab_3/ui/recipe_details_screen.dart';
import 'package:lab_3/ui/recipe_list_screen.dart';
import 'package:lab_3/ui/recipe_search_screen.dart';

class Routes {
  static final Routes _routes = Routes._internal();
  Routes._internal();

  factory Routes() {
    return _routes;
  }

  static MaterialPageRoute searchPage = MaterialPageRoute(builder: (context) => SearchScreen());
  static MaterialPageRoute getRecipeListPage(List<MealDetailModel> meals) {
    return MaterialPageRoute(builder: (context) => RecipeListScreen(meals: meals));
  }
  static MaterialPageRoute getRecipeDetailsPage(MealDetailModel meal) {
    return MaterialPageRoute(builder: (context) => RecipeDetailsScreen(meal: meal));
  }
}