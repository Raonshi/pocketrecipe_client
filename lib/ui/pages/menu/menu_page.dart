import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocketrecipe_client/controllers/menu_ctrl.dart';

class MenuPage extends StatelessWidget {
  MenuPage({Key? key}) : super(key: key);
  final controller = Get.put(MenuCtrl());

  @override
  Widget build(BuildContext context) {
    // controller.recipeList.clear();
    // controller.getRecipeByDatabase(keyword: "SHOW_MY_RECIPE");

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
        child: GridView.count(
          mainAxisSpacing: 5.0,
          crossAxisSpacing: 5.0,
          crossAxisCount: 2,
          children: <Widget>[
            MenuItemWidget(
              menuName: "korean_food".tr,
              color: Colors.deepOrangeAccent,
            ),
            MenuItemWidget(
              menuName: "chinese_food".tr,
              color: Colors.greenAccent,
            ),
            MenuItemWidget(
              menuName: "japanese_food".tr,
              color: Colors.amberAccent,
            ),
            MenuItemWidget(
              menuName: "western_food".tr,
              color: Colors.purpleAccent,
            ),
            MenuItemWidget(
              menuName: "chicken".tr,
              color: Colors.orangeAccent,
            ),
            MenuItemWidget(
              menuName: "pizza".tr,
              color: Colors.redAccent,
            ),
            MenuItemWidget(
              menuName: "dessert".tr,
              color: Colors.lightGreenAccent,
            ),
            MenuItemWidget(
              menuName: "snack".tr,
              color: Colors.blueAccent,
            ),
          ],
        ),
      ),
    );
  }
}

class MenuItemWidget extends StatelessWidget {
  MenuItemWidget({Key? key, this.menuName, this.color}) : super(key: key);
  final menuName;
  final color;

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
          color: color,
        ),
        child: Center(
          child: Text(
            menuName,
            style: TextStyle(fontSize: 30),
          ),
        ),
      ),
    );
  }
}

// class Community extends StatelessWidget {
//   final controller = Get.put(Controller());

//   @override
//   Widget build(BuildContext context) {
//     controller.recipeList.clear();
//     controller.getRecipeByDatabase(keyword: "SHOW_MY_RECIPE");

//     return Column(
//       mainAxisSize: MainAxisSize.max,
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         //레시피 게시글 피드
//         Expanded(
//           flex: 8,
//           child: Obx(
//             () => ListView.builder(
//                 shrinkWrap: true,
//                 scrollDirection: Axis.vertical,
//                 itemCount: controller.recipeList.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return RecipeItem(controller.recipeList[index]);
//                 }),
//           ),
//         ),

//         //글쓰기 버튼
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Spacer(),
//             Expanded(
//               flex: 3,
//               child: ElevatedButton(
//                 onPressed: () async {
//                   controller.recipe.value = new Recipe();
//                   bool goToHome = await Get.to(() => RecipePost1());

//                   //등록, 삭제에서 돌아올 경우
//                   if (goToHome) {
//                     controller.recipeList.clear();
//                     controller.getRecipeByDatabase(keyword: "SHOW_MY_RECIPE");
//                   }
//                 },
//                 child: Icon(Icons.add_rounded),
//               ),
//             ),
//             Spacer(),
//             Expanded(
//               flex: 3,
//               child: ElevatedButton(
//                 onPressed: () async {
//                   bool goToHome = await Get.to(() => RecipeDelete());
//                   if (goToHome) {
//                     controller.recipeList.clear();
//                     controller.getRecipeByDatabase(keyword: "SHOW_MY_RECIPE");
//                   }
//                 },
//                 child: Icon(Icons.delete_rounded),
//               ),
//             ),
//             Spacer(),
//             Expanded(
//               flex: 3,
//               child: ElevatedButton(
//                 onPressed: () async {
//                   bool goToHome = await Get.to(() => RecipeUpdate());
//                   if (goToHome) {
//                     controller.recipeList.clear();
//                     controller.getRecipeByDatabase(keyword: "SHOW_MY_RECIPE");
//                   }
//                 },
//                 child: Icon(Icons.edit_rounded),
//               ),
//             ),
//             Spacer(),
//           ],
//         ),
//       ],
//     );
//   }
// }
