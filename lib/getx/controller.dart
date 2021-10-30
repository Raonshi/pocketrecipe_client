import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:pocketrecipe_client/api.dart';
import 'package:pocketrecipe_client/ui/widgets/manual_add_item.dart';
import 'package:sprintf/sprintf.dart';

class Controller extends GetxController{
  API api = new API();
  var recipeList = <Recipe>[].obs;
  Rx<Recipe> recipe = Recipe().obs;
  RxInt centerPageSelect = 1.obs;
  RxList manualList = <ManualItem>[].obs;

  void manualAdd(){
    manualList.add(ManualItem(index: manualList.length-1));
  }

  void manualSub(){
    manualList.removeLast();
  }

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
          isFavorite: 0,
        );

        recipe.manualList = tmpManualList;
        recipe.imageList = tmpImgList;

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
            name: item['recipe_name'],
            recipeImg: item['recipe_image'],
            parts: item['RCP_PARTS_DTLS'],
            energy: item['INFO_ENG'],
            carbohydrate: item['INFO_CAR'],
            protein: item['INFO_PRO'],
            fat: item['INFO_FAT'],
            natrium: item['INFO_NA'],
            isFavorite: 0,
        );

        recipe.manualList = tmpManualList;
        recipe.imageList = tmpImgList;

        recipeList.add(recipe);
      }
    }

    Logger().d("${recipeList[0].name}");
  }

  ///카메라를 통한 이미지 로드
  void encodeImageFromCamera() async {
    ImagePicker picker = ImagePicker();
    XFile? xFile = await picker.pickImage(source: ImageSource.camera);
    recipe.value.recipeImg = await imageToBase64(xFile: xFile);
  }

  ///갤러리를 통한 이미지 로드
  void encodeImageFromGallery() async {
    ImagePicker picker = ImagePicker();
    XFile? xFile = await picker.pickImage(source: ImageSource.gallery);
    recipe.value.recipeImg = await imageToBase64(xFile: xFile);
  }


  ///레시피 등록
  Future<bool> recipePosting() async {
    recipePackaging();
    recipe.value.recipeImg = await imageToBase64();

    bool isComplete = await api.insertRecipe(recipe.value);
    return isComplete;
  }

  ///레시피 정보 패키징
  void recipePackaging() async {
    for(int i = 0; i < 20; i++){

      if(i < manualList.length){
        ManualItem item = manualList.value[i];

        item.manual == '' ? recipe.value.manualList.add('') : recipe.value.manualList.add(item.manual);
        recipe.value.imageList.add(await imageToBase64(xFile: item.image));
      }
      else{
        recipe.value.manualList.add('');
        recipe.value.imageList.add(await imageToBase64());
      }

    }
  }

  ///이미지 파일을 base64코드로 변환
  Future<String> imageToBase64({XFile? xFile}) async {
    //이미지가 없을 경우
    if(xFile == null){
      ByteData file = await rootBundle.load("data/warning.jpeg");
      final buffer = file.buffer;
      var list = buffer.asUint8List(file.offsetInBytes, file.lengthInBytes);
      return base64.encode(list);
    }
    //이미지가 있을 경우
    else{
      File file = new File(xFile.path);
      return base64.encode(file.readAsBytesSync());
    }
  }
}


class Recipe{
  String name = '';
  String recipeImg;
  String parts = '';

  String energy = '';
  String natrium = '';
  String carbohydrate = '';
  String fat = '';
  String protein = '';

  List<dynamic> imageList = [];
  List<dynamic> manualList = [];

  //0 : 공공데이터 -> 좋아요 없음
  //1 : 좋아요 눌림
  //2 : 좋아요 안눌림
  int isFavorite;

  Recipe({this.name='', this.recipeImg='', this.parts='',
    this.energy='', this.carbohydrate='', this.protein='', this.fat='', this.natrium='',
    this.isFavorite=0});

  void setName(String value) => this.name = value;
  void setImage(String value) => this.recipeImg = value;
  void setParts(String value) => this.parts = value;
  void setEnergy(String value) => this.energy = value;
  void setCal(String value) => this.carbohydrate = value;
  void setPro(String value) => this.protein = value;
  void setFat(String value) => this.fat = value;
  void setNa(String value) => this.natrium = value;


  Map<String, dynamic> toJson(String author){
    return {
      "recipe_name" : name,
      "recipe_image" : recipeImg,
      "recipe_parts" : parts,
      "recipe_energy" : energy,
      "recipe_cal" : carbohydrate,
      "recipe_pro" : protein,
      "recipe_fat" : fat,
      "recipe_nat" : natrium,
      "recipe_manual" : manualList,
      "recipe_manual_image" : imageList,
      "recipe_author" : author,
    };
  }
}