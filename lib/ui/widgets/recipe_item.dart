import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:pocketrecipe_client/getx/controller.dart';

class RecipeItem extends StatelessWidget {
  Recipe recipe;
  RecipeItem(this.recipe);

  @override
  Widget build(BuildContext context) {

    Logger().d("아이템 이름 : ${recipe.name}");

    return Container(
      width: 150,
      height: 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Image.network("${recipe.recipeImg}", width: 150, height: 120,),
            ],
          ),
          Row(
            children: [
              Text("요리 이름 : ${recipe.name}"),
            ],
          ),
        ],
      ),
    );
  }
}
