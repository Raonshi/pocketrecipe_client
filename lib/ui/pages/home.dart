import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocketrecipe_client/ui/widgets/recipe_item.dart';

import '../../getx/controller.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomeWidget();
  }
}



class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  final controller = Get.put(APIController());
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
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
                      controller.getRecipeByName(textEditingController.text);
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ElevatedButton(
                    onPressed: () {
                      controller.getRecipeByName(textEditingController.text);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Text("검색!"),
                    )),
              ),
            ],
          ),

          Obx(() => Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: controller.recipeList.length,
                itemBuilder: (BuildContext context, int index) {
                  return RecipeItem(controller.recipeList[index]);
                }),
          ),
          ),
        ],
      ),
    );
  }
}

