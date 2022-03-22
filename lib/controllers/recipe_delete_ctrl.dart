import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pocketrecipe_client/etc/data_define.dart';
import 'package:pocketrecipe_client/services/api_service.dart';
import 'package:pocketrecipe_client/services/firebase_service.dart';

class RecipeDeleteCtrl extends GetxController {
  final api = Get.find<ApiService>();

  final myRecipe = [].obs;

  getFirebaseRecipe() async {
    final response = await api.backendGet(
        '/myrecipe', {'author': Get.find<FirebaseService>().user.displayName});
    myRecipe.addAll(response.map((item) {
      Recipe recipe = Recipe.fromJson(item);
      recipe.setManualList(item['MANUALS']);
      return recipe;
    }).toList());
  }

  deleteRecipe() async {}
}
