import 'package:flutter/material.dart';
import 'package:pocketrecipe_client/getx/controller.dart';

import 'package:get/get.dart';


class RecipeItem extends StatelessWidget {
  Recipe recipe;
  RecipeItem(this.recipe);

  final controller = Get.put(APIController());

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      child: Obx(()=> Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Image.network("${recipe.recipeImg}"),
            ],
          ),
          Row(
            children: [
              Text("${recipe.name}"),
            ],
          ),
        ],
      ),),
    );
  }
}
