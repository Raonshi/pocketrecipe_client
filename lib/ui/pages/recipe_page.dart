import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocketrecipe_client/getx/controller.dart';

import 'home.dart';

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

