import 'package:flutter/material.dart';
import 'package:pocketrecipe_client/data_define.dart';

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
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  recipe.recipeImg == "Unknown"
                      ? Image.asset("data/warning.jpeg")
                      : Image.network("${recipe.recipeImg}"),
                ],
              ),
            ),

            Divider(),

            //재료
            Expanded(
                flex: 1,
                child: Text(
                  "필요한 재료",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
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
                )),
              ],
            ),

            Divider(),

            //요리 열량
            Text(
              "열량",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

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
                )),
                Expanded(
                    child: Text(
                  "나트륨 : ${recipe.natrium}",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                )),
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
                )),
                Expanded(
                    child: Text(
                  "단백질 : ${recipe.protein}",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                )),
                Expanded(
                    child: Text(
                  "지방 : ${recipe.fat}",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                )),
              ],
            ),

            Divider(),

            //요리 과정
            //리스트뷰로 만들어야할듯
            Expanded(
              flex: 8,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: recipe.manualList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Divider(),
                      recipe.imageList.length > index
                          ? (recipe.imageList[index] == "Unknown"
                              ? Text("<이미지가 없습니다>")
                              : Image.network("${recipe.imageList[index]}"))
                          : Text("<이미지가 없습니다>"),
                      recipe.manualList.length > index
                          ? Text(recipe.manualList[index])
                          : Text("<설명이 없습니다>"),
                      Divider(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
