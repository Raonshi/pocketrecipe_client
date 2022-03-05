import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pocketrecipe_client/data_define.dart';
import 'package:pocketrecipe_client/services/api_service.dart';

class RecipeSearchCtrl extends GetxController {
  final api = Get.find<ApiService>();
  final _searchController = TextEditingController().obs;
  get searchController => _searchController.value;

  final _searchResult = [].obs;
  get searchResult => _searchResult;

  getRecipeByKeyword() async {
    searchResult.clear();
    String keyword = searchController.text;
    final response =
        await api.backendGet('/search-recipe', {'keyword': keyword});

    Map<String, dynamic> json = jsonDecode(response);
    final List list = json['COOKRCP01']['row'];
    searchResult.addAll(list.map((item) => Recipe.fromJson(item)).toList());
  }
}
