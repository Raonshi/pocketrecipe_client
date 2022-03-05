import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeCtrl extends GetxController {
  final _pageController = PageController().obs;
  get pageController => _pageController.value;

  final _bottomIndex = 1.obs;
  set bottomIndex(val) => _bottomIndex.value = val;
  get bottomIndex => _bottomIndex.value;

  final _appBarTitle = ["recipe_search", "community", "setting"].obs;
  get appBarTitle => _appBarTitle;
}
