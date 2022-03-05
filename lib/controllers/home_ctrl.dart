import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeCtrl extends GetxController {
  final _pageController = PageController().obs;
  get pageController => _pageController.value;

  final _bottomIndex = 0.obs;
  set bottomIndex(val) => _bottomIndex.value = val;
  get bottomIndex => _bottomIndex.value;

  final _appBarTitle = ["레시피 검색", "커뮤니티", "설정"].obs;
  get appBarTitle => _appBarTitle;
}
