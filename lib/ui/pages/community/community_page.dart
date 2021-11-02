import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:pocketrecipe_client/getx/controller.dart';
import 'package:pocketrecipe_client/ui/pages/community/recipe_delete.dart';
import 'package:pocketrecipe_client/ui/pages/community/recipe_post.dart';
import 'package:pocketrecipe_client/ui/pages/home.dart';
import 'package:pocketrecipe_client/ui/pages/main.dart';
import 'package:pocketrecipe_client/ui/widgets/recipe_item.dart';


class CommunityPage extends StatelessWidget {
  final controller = Get.put(Controller());

  @override
  Widget build(BuildContext context) {
    controller.recipeList.clear();
    controller.getRecipeByDatabase(keyword: "SHOW_MY_RECIPE");

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //레시피 게시글 피드
        Expanded(
          flex:8,
          child: Obx(() => ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: controller.recipeList.length,
              itemBuilder: (BuildContext context, int index) {
                return RecipeItem(controller.recipeList[index]);
              }),),
        ),

        //글쓰기 버튼
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),

            Expanded(
              flex: 3,
              child: ElevatedButton(
                onPressed: (){
                  controller.recipe.value = new Recipe();
                  Get.to(() => RecipePost());
                },
                child: Icon(Icons.add_rounded),
              ),
            ),

            Spacer(),

            Expanded(
              flex: 3,
              child: ElevatedButton(
                onPressed: () {
                  Get.to(() => RecipeDelete());
                },
                child: Icon(Icons.delete_rounded),
              ),
            ),

            Spacer(),
          ],
        ),
      ],
    );
  }
}