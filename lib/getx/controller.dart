import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pocketrecipe_client/api.dart';
import 'package:pocketrecipe_client/ui/widgets/manual_add_item.dart';
import 'package:sprintf/sprintf.dart';

class APIController extends GetxController{
  API api = new API();
  var recipeList = <Recipe>[].obs;
  Rx<Recipe> recipe = Recipe().obs;
  RxList imageFileList = [].obs;


  void generateRecipe() => this.recipe = new Recipe().obs;


  ///레시피 키워드로 검색하기
  void getRecipeByKeyword(String str) async {
    recipeList.clear();

    //먼저 공공데이터에서 결과를 가져온다.
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
          name: item['RCP_NM'],
          recipeImg: item['ATT_FILE_NO_MAIN'],
          parts: item['RCP_PARTS_DTLS'],
          energy: item['INFO_ENG'],
          carbohydrate: item['INFO_CAR'],
          protein: item['INFO_PRO'],
          fat: item['INFO_FAT'],
          natrium: item['INFO_NA'],
          manualList: tmpManualList,
          imageList: tmpImgList,
          isFavorite: 0,
        );

        recipeList.add(recipe);
      }
    }


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
            manualList: tmpManualList,
            imageList: tmpImgList,
            isFavorite: 0,
        );

        recipeList.add(recipe);
      }
    }

    Logger().d("${recipeList[0].name}");
  }


  void recipePosting(Recipe recipe, List<ManualItem> manualList) async {
    Logger().d("test");
  }
}



class Controller extends GetxController{
  RxInt centerPageSelect = 1.obs;
}



class Recipe{
  String name = '';
  dynamic recipeImg;
  String parts = '';

  String energy = '';
  String natrium = '';
  String carbohydrate = '';
  String fat = '';
  String protein = '';

  List<dynamic>? imageList = List.generate(20, (index) => dynamic);
  List<String>? manualList = List.generate(20, (index) => '');

  //0 : 공공데이터 -> 좋아요 없음
  //1 : 좋아요 눌림
  //2 : 좋아요 안눌림
  int isFavorite;

  Recipe({this.name='', this.recipeImg, this.parts='',
    this.energy='', this.carbohydrate='', this.protein='', this.fat='', this.natrium='',
    this.manualList, this.imageList, this.isFavorite=0});

  void setName(String value) => this.name = value;
  void setImage(String value) => this.recipeImg = value;
  void setParts(String value) => this.parts = value;
  void setEnergy(String value) => this.energy = value;
  void setCal(String value) => this.carbohydrate = value;
  void setPro(String value) => this.protein = value;
  void setFat(String value) => this.fat = value;
  void setNa(String value) => this.natrium = value;
}