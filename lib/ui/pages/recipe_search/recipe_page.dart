import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocketrecipe_client/getx/controller.dart';
import 'package:pocketrecipe_client/ui/widgets/recipe_item.dart';

import '../home.dart';


class RecipeSearch extends StatelessWidget {
  final controller = Get.put(Controller());
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            flex:1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                    child: TextField(
                      controller: textEditingController,
                      maxLines: 1,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "요리명 / 요리재료"
                      ),
                      onSubmitted: (str) {
                        controller.getRecipeByKeyword(textEditingController.text);
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton(
                      onPressed: () {
                        controller.getRecipeByKeyword(textEditingController.text);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Text("검색"),
                      )),
                ),
              ],
            ),
          ),

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
        ],
      ),
    );
  }
}




class RecipePage extends StatelessWidget {

  Recipe recipe;

  RecipePage(this.recipe);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            //완성 이미지
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Image.network("${recipe.recipeImg}"),
              ],
            ),
            SizedBox(height: 30,),

            //재료
            Text("필요한 재료", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                    child: Text(
                      recipe.parts,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 5,
                    )
                ),
              ],
            ),
            SizedBox(height: 30,),

            //요리 열량
            Text("열량", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                    child: Text(
                      "열량 : ${recipe.energy}",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 5,
                    )
                ),
                Expanded(
                    child: Text(
                      "나트륨 : ${recipe.natrium}",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 5,
                    )
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                    child: Text(
                      "탄수화물 : ${recipe.carbohydrate}",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 5,
                    )
                ),
                Expanded(
                    child: Text(
                      "단백질 : ${recipe.protein}",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 5,
                    )
                ),
                Expanded(
                    child: Text(
                      "지방 : ${recipe.fat}",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 5,
                    )
                ),
              ],
            ),
            SizedBox(height: 30,),

            //요리 과정
            //리스트뷰로 만들어야할듯
          ],
        ),
      ),
    );
  }
}

