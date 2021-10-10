import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pocketrecipe_client/api.dart';
import 'package:sprintf/sprintf.dart';

class APIController extends GetxController{
  API api = new API();
  var recipeList = <Recipe>[].obs;

  void getRecipeByName(String str) async {
    recipeList.clear();

    dynamic result = await api.getRecipeByName(str);

    if(result.length > 0){
      for(int i = 0; i < result['row'].length; i++){
        dynamic item = result['row'][i];

        List<String> tmpManualList = [];
        for(int i = 1; i <= 20; i++){
          String str = item['MANUAL${sprintf("%02d", [i])}'];
          if(str == ""){continue;}
          tmpManualList.add(str);
        }

        List<String> tmpImgList = [];
        for(int i = 1; i <= 20; i++){
          String str = item['MANUAL_IMG${sprintf("%02d", [i])}'];
          if(str == ""){continue;}
          tmpImgList.add(str);
        }

        Recipe recipe = Recipe(
          item['RCP_NM'], item['ATT_FILE_NO_MAIN'], item['RCP_PARTS_DTLS'],
          item['INFO_ENG'], item['INFO_CAR'], item['INFO_PRO'], item['INFO_FAT'], item['INFO_NA'],
          tmpManualList, tmpImgList);

        recipeList.add(recipe);
      }
    }

    Logger().d("${recipeList[0].name}");
  }
}

class Controller extends GetxController{
  RxInt centerPageSelect = 1.obs;

}



class Recipe{
  String name = '';
  String recipeImg = '';
  String parts = '';

  String energy = '';
  String natrium = '';
  String carbohydrate = '';
  String fat = '';
  String protein = '';

  List<String> imageList = [];
  List<String> manuaList = [];

  Recipe(
      this.name, this.recipeImg, this.parts,
      this.energy, this.carbohydrate, this.protein, this.fat, this.natrium,
      this.manuaList, this.imageList
      );
}