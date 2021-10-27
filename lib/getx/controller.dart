import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:pocketrecipe_client/api.dart';
import 'package:sprintf/sprintf.dart';

class APIController extends GetxController{
  API api = new API();
  var recipeList = <Recipe>[].obs;
  Rx<Recipe>? recipe;
  RxList imageFileList = [].obs;


  ///레시피 키워드로 검색하기
  void getRecipeByKeyword(String str) async {
    recipeList.clear();

    //먼저 공공데이터에서 결과를 가져온다.
    /*
    dynamic result = await api.getRecipeByKeyword(str);

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
          tmpManualList, tmpImgList, 0);

        recipeList.add(recipe);
      }
    }
     */

    //데이터베이스데서 결과를 가져온다.
    dynamic dbResult = await api.getRecipeByDatabase(str);

    if(dbResult.length > 0){
      for(int i = 0; i < dbResult['row'].length; i++){
        dynamic item = dbResult['row'][i];

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
            name: item['RCP_NM'],
            recipeImg: item['ATT_FILE_NO_MAIN'],
            parts: item['RCP_PARTS_DTLS'],
            energy: item['INFO_ENG'],
            carbohydrate: item['INFO_CAR'],
            protein: item['INFO_PRO'],
            fat: item['INFO_FAT'],
            natrium: item['INFO_NA'],
            manuaList: tmpManualList,
            imageList: tmpImgList,
            isFavorite: 0,
        );

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

  List<String>? imageList;
  List<String>? manuaList;

  //0 : 공공데이터 -> 좋아요 없음
  //1 : 좋아요 눌림
  //2 : 좋아요 안눌림
  int isFavorite;

  Recipe({required this.name, this.recipeImg='', this.parts='',
    this.energy='', this.carbohydrate='', this.protein='', this.fat='', this.natrium='',
    this.manuaList, this.imageList, this.isFavorite=0});

  setName(String value) => this.name = value;
  setImage(String value) => this.name = value;
  setParts(String value) => this.name = value;
  setEnergy(String value) => this.name = value;
  setCal(String value) => this.name = value;
  setPro(String value) => this.name = value;
  setFat(String value) => this.name = value;
  setNa(String value) => this.name = value;
}