import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocketrecipe_client/controllers/community_ctrl.dart';

class CommunityPage extends StatelessWidget {
  CommunityPage({Key? key}) : super(key: key);
  final controller = Get.put(CommunityCtrl());

  @override
  Widget build(BuildContext context) {
    // controller.recipeList.clear();
    // controller.getRecipeByDatabase(keyword: "SHOW_MY_RECIPE");

    return Column();
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
