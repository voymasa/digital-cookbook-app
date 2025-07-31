/*
Aaron Voymas
Lab 3
This screen shows details about the recipes from mealdb
 */

import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lab_3/data/meal_models.dart';
import '../helpers/db_service.dart';
import '../helpers/http_service.dart';

class RecipeDetailsScreen extends StatelessWidget {
  final SemDbService dbService = SemDbService();
  final HttpService httpService = HttpService();
  // this url is a pasta plate from mealdb; I'll use it as a default bc I know it's there and it works
  final String defaultThumbnail = 'https://www.themealdb.com/images/media/meals/llcbn01574260722.jpg/preview';

  final MealDetailModel meal;
  RecipeDetailsScreen({ required this.meal,
    super.key});

  @override
  Widget build(BuildContext context) {
    String imagePath = meal.thumbnailUrl.isNotEmpty ? meal.thumbnailUrl : defaultThumbnail;
    double height = MediaQuery.of(context).size.height;
    TextStyle bodyStyle = TextStyle(
      fontSize: 16
    );
    TextStyle headerStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold
    );

    NetworkImage image = NetworkImage(imagePath) ?? NetworkImage(defaultThumbnail);

    return Scaffold(
      appBar: AppBar(
        title: Text(meal.name),
        backgroundColor: Colors.amber,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            tooltip: 'Save recipe to device',
            onPressed: () async {
              // save if not saved
              var checkMeal = await dbService.getMeal(meal.mealId);
              if (checkMeal != null) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Recipe already saved', style: TextStyle(
                      color: Colors.red
                  )),
                ));
                return;
              }
              // use snackbar to notify the user
              int numInserted = await dbService.insertMeal(meal);
              if (numInserted != 0) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Recipe saved to device', style: TextStyle(
                    color: Colors.green
                  )),
                ));
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            tooltip: 'Delete recipe from device (you can still find it from the search)',
            onPressed: () async {
              // delete if not deleted
              var checkMeal = await dbService.getMeal(meal.mealId);
              if (checkMeal == null) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Recipe already deleted from device', style: TextStyle(
                      color: Colors.red
                  )),
                ));
                return;
              }
              // use snackbar to notify the user
              int numDeleted = await dbService.deleteMeal(meal);
              if (numDeleted != 0) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Recipe deleted from device', style: TextStyle(
                      color: Colors.green
                  )),
                ));
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                height: height / 2.25,
                child: Image.network(imagePath)
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Text('Recipe Name: ', style: headerStyle),
                    Text(meal.name.isNotEmpty ? meal.name : meal.altName!, style: bodyStyle),
                    Padding(padding: EdgeInsets.only(bottom: 16)),
                    if (meal.sourceUrl.isNotEmpty) ...[
                      Text('Source Website: ', style: headerStyle),
                      Linkify(
                        text: meal.sourceUrl,
                        onOpen: (link) async {
                          await launchUrl(Uri.parse(link.url));
                        }
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 16)),
                    ],
                    Text('Category: ', style: headerStyle),
                    Text(meal.category, style: bodyStyle),
                    Text('Region: ', style: headerStyle),
                    Text(meal.country, style: bodyStyle),
                    Padding(padding: EdgeInsets.only(bottom: 16)),
                    Text('Ingredients: ', style: headerStyle),
                    for (var key in meal.ingredients.keys) Wrap(
                      children: [
                        Text(key.toString(), style: headerStyle),
                        Padding(padding: EdgeInsets.only(right: 16)),
                        Text(meal.ingredients[key].toString(), style: bodyStyle)
                      ],
                    ),
                    Text('Instructions: ', style: headerStyle),
                    Wrap(
                      children: [
                        Text(meal.instructions, style: bodyStyle)
                      ],
                    ),
                  ],
                )
              )
            ],
          )
        )
      )
    );
  }
}
