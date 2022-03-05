import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeCtrl extends GetxController {
  final _searchController = TextEditingController().obs;
  get searchController => _searchController.value;
}
