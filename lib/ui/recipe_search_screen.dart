/*
Aaron Voymas
Lab 3
This screen provides functionality to search mealdb for recipes, or get a random recipe
 */

import 'package:flutter/material.dart';
import 'package:lab_3/data/meal_models.dart';
import 'package:lab_3/helpers/db_service.dart';
import 'package:lab_3/helpers/http_service.dart';
import '../helpers/routes.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final SemDbService dbService = SemDbService();
  final HttpService httpService = HttpService();
  final Icon visibleIcon = Icon(Icons.search);
  final Color bgColor = Colors.amber;
  final double marginSize = 20.0;

  // text controllers
  final TextEditingController txtKeywords = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search for Recipes'),
        backgroundColor: bgColor,
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            tooltip: 'View saved recipes',
            onPressed: () async {
              var meals = await dbService.getMeals();
              Navigator.push(context, Routes.getRecipeListPage(meals));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(padding: EdgeInsets.symmetric(horizontal: marginSize)),
          Text('Search: '),
          TextField(
            controller: txtKeywords,
            decoration: InputDecoration(
              hintText: 'Enter search keywords'
            ),
          ),
          Padding(padding: EdgeInsets.symmetric(horizontal: marginSize)),
          ElevatedButton(
            child: Text('Search'),
            onPressed: () async {
              var meals = await getMeals();
              if (meals.errorMessage.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(meals.errorMessage),
                ));
              } else {
                Navigator.push(context, Routes.getRecipeListPage(meals.list));
              }
            },
          ),
          Padding(padding: EdgeInsets.symmetric(horizontal: marginSize)),
          ElevatedButton(
            child: Text('Feeling Lucky (Random Recipe)'),
            onPressed: () async {
              var meals = await getRandomMeal();
              if (meals.errorMessage.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(meals.errorMessage),
                ));
              } else {
                Navigator.push(context, Routes.getRecipeListPage(meals.list));
              }
            },
          ),
          Padding(padding: EdgeInsets.symmetric(horizontal: marginSize)),
        ],
      ),
    );
  }

  Future<MealListResult> getMeals() async {
    var searchTerm = txtKeywords.text;
    searchTerm = searchTerm.replaceAll(' ', '_');
    String query = 's=' + searchTerm;
    return await httpService.getRecipes(httpService.searchUrl, query);
  }

  Future<MealListResult> getRandomMeal() async {
    String query = '';
    return await httpService.getRecipes(httpService.randomUrl, query);
  }
}
