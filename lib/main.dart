/*
Aaron Voymas
Lab 3
This lab is a recipe search app to search for recipes online, save recipes you want to keep, and view recipe details
 */

import 'package:flutter/material.dart';
import 'package:lab_3/ui/recipe_search_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: SearchScreen(),
        ),
      ),
    );
  }
}
