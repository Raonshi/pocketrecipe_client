import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class RecipeSearchCtrl extends GetxController {
  final _searchController = TextEditingController().obs;
  get searchController => _searchController.value;

  final _searchResult = [].obs;
  get searchResult => _searchResult;

  getRecipeByKeyword() {
    Logger().d("Search Call!");
  }
}
