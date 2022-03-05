import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pocketrecipe_client/etc/data_define.dart';

class RecipePage extends StatelessWidget {
  RecipePage();
  Recipe recipe = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name, style: TextStyle(fontSize: 25)),
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: ListView(
          children: [
            //완성 이미지
            ClipRRect(
              child: recipe.recipeImg == "Unknown"
                  ? Image.asset(
                      "data/warning.jpeg",
                      fit: BoxFit.fill,
                    )
                  : Image.network(
                      "${recipe.recipeImg}",
                      fit: BoxFit.fill,
                    ),
            ),

            Row(
              children: [
                IconButton(
                  constraints: BoxConstraints(),
                  splashRadius: 20,
                  icon: Icon(
                    Icons.favorite,
                    color: Colors.redAccent,
                  ),
                  onPressed: () {},
                ),
                Text(
                  "+120k likes",
                  style: TextStyle(fontSize: 14),
                ),
                Spacer(),
                Text(
                  "superCheif",
                  maxLines: 1,
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),

            Divider(),

            //재료
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                "필요한 재료",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                    child: Text(
                  recipe.parts,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                )),
              ],
            ),

            Divider(),

            //요리 열량
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                "열량",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                    child: Text(
                  "열량 : ${recipe.energy}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                )),
                Expanded(
                    child: Text(
                  "나트륨 : ${recipe.natrium}",
                  style: TextStyle(
                    fontSize: 16,
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
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                )),
                Expanded(
                    child: Text(
                  "단백질 : ${recipe.protein}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                )),
                Expanded(
                    child: Text(
                  "지방 : ${recipe.fat}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                )),
              ],
            ),

            Divider(),

            //요리 과정
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                "요리 과정",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            Column(
              children: List.generate(
                recipe.manualList.isEmpty ? 20 : recipe.manualList.length,
                (index) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Divider(),
                    recipe.imageList.length > index
                        ? (recipe.imageList[index] == ""
                            ? Container(
                                width: 350,
                                height: 200,
                                color: Colors.grey,
                                child: Center(
                                    child: Text(
                                  "이미지가 없습니다",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )),
                              )
                            : Image.network(
                                recipe.imageList[index],
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(child: Text("No Image")),
                                fit: BoxFit.fill,
                                scale: 0.5,
                                filterQuality: FilterQuality.high,
                              ))
                        : Container(
                            width: 350,
                            height: 200,
                            color: Colors.grey,
                            child: Center(
                                child: Text(
                              "이미지가 없습니다",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )),
                          ),
                    recipe.manualList.length > index
                        ? (recipe.manualList[index] == ""
                            ? Text(
                                "설명이 없습니다",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              )
                            : Text(
                                recipe.manualList[index],
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ))
                        : Text(
                            "설명이 없습니다",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                    Divider(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
