import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:pocketrecipe_client/getx/controller.dart';
import 'package:get/get.dart';
import 'package:pocketrecipe_client/ui/pages/recipe_page.dart';

class RecipeItem extends StatelessWidget {
  Recipe recipe;
  RecipeItem(this.recipe);

  @override
  Widget build(BuildContext context) {

    Logger().d("아이템 이름 : ${recipe.name}");

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      width: 150,
      height: 160,
      child: ElevatedButton(
        onPressed: (){
          Get.to(RecipePage(recipe));
        },
        style: ElevatedButton.styleFrom(
          primary: Color.fromARGB(0, 255, 255, 255)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network("${recipe.recipeImg}", width: 150, height: 120,),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                  child: Text(recipe.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
