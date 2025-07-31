/*
Aaron Voymas
Lab 3
This dart file contains models related to areas/regions, i.e. Canada, US, etc
 */

class AreaListResult {
  List<AreaModel> list = [];
  int numAreas = 0;
  String errorMessage = '';
}

class AreaModel {
  late String country;

  AreaModel(
      this.country
      );

  AreaModel.fromJson(Map<String, dynamic> json) {
    this.country = json["strArea"];
  }
}