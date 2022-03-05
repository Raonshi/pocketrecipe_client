import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocketrecipe_client/controllers/home_ctrl.dart';
import 'package:pocketrecipe_client/ui/pages/community/community_page.dart';
import 'package:pocketrecipe_client/ui/pages/recipe/recipe_search_page.dart';
import 'package:pocketrecipe_client/ui/pages/setting/setting_page.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final controller = Get.put(HomeCtrl());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text(controller.appBarTitle[controller.bottomIndex])),
      body: PageView(
        controller: controller.pageController,
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (value) => controller.bottomIndex = value,
        children: <Widget>[
          RecipeSearchPage(),
          CommunityPage(),
          SettingPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) => controller.bottomIndex = value,
        currentIndex: controller.bottomIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
          ),
        ],
      ),
    );
  }
}
