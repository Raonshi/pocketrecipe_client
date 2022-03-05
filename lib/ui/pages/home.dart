import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocketrecipe_client/controllers/home_ctrl.dart';
import 'package:pocketrecipe_client/ui/pages/community/community_page.dart';
import 'package:pocketrecipe_client/ui/pages/recipe_search/recipe_page.dart';
import 'package:pocketrecipe_client/ui/pages/setting/setting_page.dart';

import '../../getx/controller.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final controller = Get.put(HomeCtrl());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 5.0),
                      child: ElevatedButton(
                          onPressed: () =>
                              controller.centerPageSelect.value = 1,
                          child: Icon(Icons.home_rounded)),
                    )),
                Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 5.0),
                      child: ElevatedButton(
                          onPressed: () =>
                              controller.centerPageSelect.value = 2,
                          child: Icon(Icons.message_rounded)),
                    )),
                Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 5.0),
                      child: ElevatedButton(
                          onPressed: () =>
                              controller.centerPageSelect.value = 3,
                          child: Icon(Icons.settings_rounded)),
                    )),
              ],
            ),
          ),
          Spacer(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(icon: Icon(Icons.search)),
        BottomNavigationBarItem(icon: Icon(Icons.chat_bubble)),
        BottomNavigationBarItem(icon: Icon(Icons.settings)),
      ]),
    );
  }
}

class Home extends StatelessWidget {
  bool? permissionStatus;
  @override
  Widget build(BuildContext context) {
    return HomeWidget();
  }
}

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  final controller = Get.put(Controller());
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    controller.checkLogin();
    controller.getRecipeByDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            flex: 20,
            child: Obx(() => centerPage()),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 5.0),
                      child: ElevatedButton(
                          onPressed: () =>
                              controller.centerPageSelect.value = 1,
                          child: Icon(Icons.home_rounded)),
                    )),
                Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 5.0),
                      child: ElevatedButton(
                          onPressed: () =>
                              controller.centerPageSelect.value = 2,
                          child: Icon(Icons.message_rounded)),
                    )),
                Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 5.0),
                      child: ElevatedButton(
                          onPressed: () =>
                              controller.centerPageSelect.value = 3,
                          child: Icon(Icons.settings_rounded)),
                    )),
              ],
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }

  Widget centerPage() {
    if (controller.centerPageSelect.value == 1) {
      return RecipeSearch();
    } else if (controller.centerPageSelect.value == 2) {
      return CommunityPage();
    } else if (controller.centerPageSelect.value == 3) {
      return SettingPage();
    } else {
      return RecipeSearch();
    }
  }
}
