/*
Aaron Voymas
Lab 3
This class contains models related to categories
 */

class CategoryListResult {
  List<CategoryModel> categories = [];
  int numCategories = 0;
  String errorMessage = '';
}

class CategoryModel {
  late String category;

  CategoryModel(this.category);

  CategoryModel.fromJson(Map<String, dynamic> json) {
    this.category = json['strCategory'];
  }
}