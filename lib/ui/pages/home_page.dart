import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocketrecipe_client/controllers/home_ctrl.dart';
import 'package:pocketrecipe_client/ui/pages/menu/menu_page.dart';
import 'package:pocketrecipe_client/ui/pages/menu/recipe_post_page.dart';
import 'package:pocketrecipe_client/ui/pages/recipe/recipe_search_page.dart';
import 'package:pocketrecipe_client/ui/pages/setting/setting_page.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final controller = Get.put(HomeCtrl());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("pocket_recipe".tr)),
      body: PageView(
        controller: controller.pageController,
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (value) => controller.bottomIndex = value,
        children: <Widget>[
          RecipeSearchPage(),
          MenuPage(),
          SettingPage(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Obx(
        () => Visibility(
          visible: controller.bottomIndex == 0 ? true : false,
          child: FloatingActionButton(
            backgroundColor: Colors.lightGreen,
            child: Icon(Icons.add, size: 35),
            onPressed: () => Get.to(RecipePostPage()),
          ),
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          selectedItemColor: Colors.lightGreen,
          onTap: (value) {
            controller.bottomIndex = value;
            controller.pageController.jumpToPage(value);
          },
          currentIndex: controller.bottomIndex,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.search), label: "recipe_search".tr),
            BottomNavigationBarItem(
                icon: Icon(Icons.dashboard), label: "menu".tr),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: "setting".tr),
          ],
        ),
      ),
    );
  }
}
