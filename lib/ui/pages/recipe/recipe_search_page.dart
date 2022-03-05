import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocketrecipe_client/controllers/recipe_search_ctrl.dart';
import 'package:pocketrecipe_client/data_define.dart';
import 'package:pocketrecipe_client/getx/controller.dart';
import 'package:pocketrecipe_client/ui/pages/recipe/recipe_page.dart';

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
            child: _SearchWidget(),
          ),
          Expanded(
            flex: 8,
            child: Obx(
              () => ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: controller.searchResult.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 10.0,
                      ),
                      child: InkWell(
                        child: _RecipeItemWidget(
                          recipe: controller.searchResult[index],
                        ),
                        onTap: () => Get.to(() => RecipePage(),
                            arguments: controller.searchResult[index]),
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchWidget extends StatelessWidget {
  _SearchWidget({Key? key}) : super(key: key);
  final controller = Get.find<RecipeSearchCtrl>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: TextField(
                controller: controller.searchController,
                maxLines: 1,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
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
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.resolveWith(
                  (states) => RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              onPressed: () {
                controller.getRecipeByKeyword();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0),
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
    );
  }
}

class _RecipeItemWidget extends StatelessWidget {
  _RecipeItemWidget({Key? key, required this.recipe}) : super(key: key);
  final controller = Get.find<RecipeSearchCtrl>();
  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.lightBlue,
          width: 2.0,
          style: BorderStyle.solid,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //레시피 이미지
          Expanded(
            flex: 4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: recipe.recipeImg == "Unknown"
                  ? Image.asset(
                      "data/warning.jpeg",
                    )
                  : Image.network("${recipe.recipeImg}"),
            ),
          ),

          Spacer(),

          //레시피 이름
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe.name,
                  maxLines: 1,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Divider(color: Color.fromARGB(0, 0, 0, 0)),
                Text(
                  "열량 : ${recipe.energy}kcal",
                  maxLines: 1,
                  style: TextStyle(fontSize: 16),
                ),
                Divider(color: Color.fromARGB(0, 0, 0, 0)),
                Text(
                  "superCheif",
                  maxLines: 1,
                  style: TextStyle(fontSize: 16),
                ),
                Divider(color: Color.fromARGB(0, 0, 0, 0)),
                Row(
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      splashRadius: 8,
                      onPressed: () {},
                      icon: Icon(
                        Icons.favorite,
                        color: Colors.redAccent,
                      ),
                    ),
                    Divider(
                      color: Color.fromARGB(0, 0, 0, 0),
                    ),
                    Text(
                      "+120k likes",
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                    Offstage(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
