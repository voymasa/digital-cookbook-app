/*
Aaron Voymas
Lab 3
This class provides services and helpers to interact with the database
 */

import 'dart:async';
import 'package:lab_3/data/meal_models.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast_io.dart';

class SemDbService {
  static final SemDbService _singleton = SemDbService._internal();
  SemDbService._internal();

  factory SemDbService() {
    return _singleton;
  }

  DatabaseFactory dbFactory = databaseFactoryIo;
  final store = intMapStoreFactory.store('meals');

  // this handles the connection to the database object
  Database? _database;
  Future<Database?> get database async {
    if(_database == null) {
      await _openDb().then((db) {
        _database = db;
      });
    }
    return _database;
  }

  // this opens a connection to the file where the sembast database is found
  Future _openDb() async {
    final docsPath = await getApplicationDocumentsDirectory();
    final dbPath = join(docsPath.path, 'meals.db');
    final db = await dbFactory.openDatabase(dbPath);
    return db;
  }

  // create
  Future insertMeal(MealDetailModel meal) async {
    await database;
    int num = await store.add(_database!, meal.toMap());
    meal.savedToDb = true;
    return num;
  }

  // read
  Future<List<MealDetailModel>> getMeals() async {
    await database;
    final finder = Finder(sortOrders: [
      SortOrder('name'),
      SortOrder('id'),
    ]);
    final mealsSnapshot = await store.find(_database!, finder: finder);

    return mealsSnapshot.map((snapshot) {
      final meal = MealDetailModel.fromMap(snapshot.value);
      meal.id = snapshot.key;
      meal.savedToDb = true;
      return meal;
    }).toList();
  }

  Future<MealDetailModel?> getMeal(String mealId) async {
    await database;
    final finder = Finder(filter: Filter.equals('mealId', mealId));
    final mealSnapshot = await store.find(_database!, finder: finder);

    return mealSnapshot.map((snapshot) {
      final meal = MealDetailModel.fromMap(snapshot.value);
      meal.id = snapshot.key;
      meal.savedToDb = true;
      return meal;
    }).firstOrNull;
  }

  // No update method because we are only dealing with saving and deleting similar to a "favorites" system where the favorites can be viewed offline

  // delete
  Future deleteMeal(MealDetailModel meal) async {
    await database;
    final finder = Finder(filter: Filter.equals('mealId', meal.mealId));
    int num = await store.delete(_database!, finder: finder);
    meal.savedToDb = false;
    return num;
  }

}