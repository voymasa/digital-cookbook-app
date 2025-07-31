/*
Aaron Voymas
Lab 3
This screen provides a list of recipes; consider setting it up to be reusable between the search screen and pre-saved recipes
 */

import 'package:flutter/material.dart';
import 'package:lab_3/data/meal_models.dart';
import 'package:lab_3/helpers/db_service.dart';
import 'package:lab_3/helpers/http_service.dart';
import '../helpers/routes.dart';

class RecipeListScreen extends StatelessWidget {
  final List<MealDetailModel> meals;
  const RecipeListScreen({ required this.meals,
    super.key});

  @override
  Widget build(BuildContext context) {
    return RecipeListWidget(meals: meals);
  }
}

class RecipeListWidget extends StatefulWidget {
  final List<MealDetailModel> meals;
  RecipeListWidget({required this.meals,
    super.key});

  @override
  State<RecipeListWidget> createState() => _RecipeListWidgetState();
}

class _RecipeListWidgetState extends State<RecipeListWidget> {
  final SemDbService dbService = SemDbService();
  final HttpService httpService = HttpService();
  // this url is a pasta plate from mealdb; I'll use it as a default bc I know it's there and it works
  final String defaultThumbnail = 'https://www.themealdb.com/images/media/meals/llcbn01574260722.jpg/preview';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    NetworkImage image;
    final double marginSize = 20.0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Recipes Found'),
        backgroundColor: Colors.amber,
        actions: [
          IconButton(
            icon: Icon(Icons.question_mark),
            tooltip: 'Get random recipe',
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
          IconButton(
            icon: Icon(Icons.search),
            tooltip: 'Return to search page',
            onPressed: () {
              Navigator.pushAndRemoveUntil(context, Routes.searchPage, (Route<dynamic> route) => false);
            },
          )
        ],
      ),
      body: ListView.builder(
          itemCount: widget.meals.length ?? 0,
          itemBuilder: (BuildContext context, int position) {
            if(widget.meals[position].thumbnailUrl != null && widget.meals[position].thumbnailUrl.toString().trim().isNotEmpty) {
              image = NetworkImage(widget.meals[position].thumbnailUrl + '/preview');
            } else {
              image = NetworkImage(defaultThumbnail);
            }

            return Card(
                color: Colors.white60,
                elevation: 2.0,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: image,
                  ),
                  title: Text(widget.meals[position].name, style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Wrap(
                    children: [
                      Text('Category: ', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(widget.meals[position].category),
                      Padding(padding: EdgeInsets.only(right: 16)),
                      Text('Region: ', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(widget.meals[position].country),
                    ],
                  ),
                  onTap: () async {
                    Navigator.push(context, Routes.getRecipeDetailsPage(widget.meals[position]));
                  },
                  trailing: widget.meals[position].savedToDb? IconButton(
                    icon: Icon(Icons.delete),
                    tooltip: 'Delete from device (can still find during search)',
                    onPressed: () async {
                      // delete from db
                      int numDeleted = await dbService.deleteMeal(widget.meals[position]);
                      // mark as not saved
                      if (numDeleted != 0) {
                        setState(() {
                          widget.meals[position].savedToDb = false;
                        });
                      }
                    },
                  ) :
                  IconButton(
                    icon: Icon(Icons.save),
                    tooltip: 'Save to device',
                    onPressed: () async {
                      // save to db
                      int numInserted = await dbService.insertMeal(widget.meals[position]);
                      // mark as saved
                      if (numInserted != 0) {
                        setState(() {
                          widget.meals[position].savedToDb =
                          true; // using explicit rather than negation to avoid edge case of bad "state" of whether saved
                        });
                      }
                    },
                  ),
                )
            );
          }
      ),
    );
  }

  Future<MealListResult> getRandomMeal() async {
    String query = '';
    return await httpService.getRecipes(httpService.randomUrl, query);
  }
}



