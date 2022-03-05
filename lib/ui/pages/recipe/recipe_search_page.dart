import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocketrecipe_client/controllers/recipe_search_ctrl.dart';
import 'package:pocketrecipe_client/getx/controller.dart';
import 'package:pocketrecipe_client/ui/widgets/recipe_item.dart';
import 'package:pocketrecipe_client/data_define.dart';

class RecipeSearchPage extends StatelessWidget {
  RecipeSearchPage({Key? key}) : super(key: key);
  final controller = Get.put(RecipeSearchCtrl());

  @override
  Widget build(BuildContext context) {
    controller.searchResult.clear();

    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 8.0),
                    child: TextField(
                      controller: controller.searchController,
                      maxLines: 1,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "요리명 / 요리재료",
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 10.0),
                      ),
                      onSubmitted: (str) {
                        controller.getRecipeByKeyword();
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      controller.getRecipeByKeyword();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Text(
                        "검색",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 8,
            child: Obx(
              () => ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: controller.searchResult.length,
                  itemBuilder: (BuildContext context, int index) {
                    return RecipeItem(controller.searchResult[index]);
                  }),
            ),
          ),
        ],
      ),
    );
  }
}

// class RecipeSearch extends StatelessWidget {
//   final controller = Get.put(Controller());
//   TextEditingController textEditingController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     controller.recipeList.clear();

//     return Container(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Expanded(
//             flex: 1,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               mainAxisSize: MainAxisSize.max,
//               children: [
//                 Flexible(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 8.0, vertical: 8.0),
//                     child: TextField(
//                       controller: textEditingController,
//                       maxLines: 1,
//                       decoration: InputDecoration(
//                           border: OutlineInputBorder(), hintText: "요리명 / 요리재료"),
//                       onSubmitted: (str) {
//                         controller
//                             .getRecipeByKeyword(textEditingController.text);
//                       },
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                   child: ElevatedButton(
//                       onPressed: () {
//                         controller
//                             .getRecipeByKeyword(textEditingController.text);
//                       },
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 20.0),
//                         child: Text("검색"),
//                       )),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             flex: 8,
//             child: Obx(
//               () => ListView.builder(
//                   shrinkWrap: true,
//                   scrollDirection: Axis.vertical,
//                   itemCount: controller.recipeList.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     return RecipeItem(controller.recipeList[index]);
//                   }),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }