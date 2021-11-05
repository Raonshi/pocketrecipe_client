import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:pocketrecipe_client/getx/controller.dart';
import 'package:get/get.dart';
import 'package:pocketrecipe_client/ui/pages/recipe_search/recipe_page.dart';


class RecipeItem extends StatelessWidget {
  Recipe recipe;
  RecipeItem(this.recipe);

  Icon favorite = Icon(Icons.favorite_border_rounded);
  final controller = Get.put(Controller());

  @override
  Widget build(BuildContext context) {

    Logger().d("아이템 이름 : ${recipe.name}");

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      width: 300,
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //레시피 이미지
          Expanded(
            flex: 4,
            child: InkWell(
              onTap: (){
                Get.to(() => RecipePage(recipe));
              },
              child: Image.network("${recipe.recipeImg}"),
            ),
          ),

          //레시피 이름
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                    flex : 1,
                    child: Text(recipe.name, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)
                ),

                Expanded(
                  flex: 1,
                  child: IconButton(
                      onPressed: (){
                        controller.onClickFavorite(recipe);
                      },
                      icon: favorite,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}