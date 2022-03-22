import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pocketrecipe_client/controllers/recipe_delete_ctrl.dart';
import 'package:pocketrecipe_client/etc/data_define.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class RecipeDeletePage extends StatelessWidget {
  RecipeDeletePage({Key? key}) : super(key: key);
  final controller = Get.put(RecipeDeleteCtrl());

  @override
  Widget build(BuildContext context) {
    controller.myRecipe.clear();
    controller.getFirebaseRecipe();

    return Scaffold(
      appBar: AppBar(
        title: Text('my_recipe'.tr),
      ),
      body: SafeArea(
        child: Obx(
          () => ListView.builder(
            itemCount: controller.myRecipe.length,
            itemBuilder: (context, index) {
              final Recipe recipe = controller.myRecipe[index];
              return Slidable(
                key: ValueKey(recipe),
                endActionPane: ActionPane(
                  extentRatio: 0.3,
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) {},
                      icon: Icons.delete,
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    SlidableAction(
                      onPressed: (context) {},
                      icon: Icons.edit,
                      backgroundColor: Colors.lightGreen,
                      foregroundColor: Colors.white,
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(recipe.name),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
