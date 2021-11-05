import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kakao_flutter_sdk/all.dart';
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

  //온라인 작업 완료 여부 : 기본 값은 true
  RxBool isDone = true.obs;

  //카카오 설치 여부 확인
  RxBool isKakaoInstalled = false.obs;
  RxBool isLogin = false.obs;


  void manualAdd(){
    manualList.add(ManualItem(index: manualList.length-1));
  }

  void manualSub(){
    manualList.removeLast();
  }

  void generateRecipe() => this.recipe = new Recipe().obs;


  ///레시피 키워드로 검색하기
  void getRecipeByKeyword(String keyword) async {
    isDone.value = false;

    recipeList.clear();

    //먼저 공공데이터에서 결과를 가져온다.
    await getRecipeByOpenData(keyword);

    //데이터베이스에서 결과를 가져온다.
    getRecipeByDatabase(keyword: keyword);

    Logger().d("${recipeList[0].name}");
    isDone.value = true;
  }


  Future<void> getRecipeByOpenData(String str) async {
    //먼저 공공데이터에서 결과를 가져온다.
    dynamic result = await api.getRecipeByKeyword(str);

    if(int.parse(result['total_count']) != 0){
      for(int i = 0; i < result['row'].length; i++){
        dynamic item = result['row'][i];

        //레시피 메뉴얼 설명을 리스트로 변환
        List<String> tmpManualList = [];
        for(int i = 1; i <= 20; i++){
          String str = item['MANUAL${sprintf("%02d", [i])}'];
          if(str == ""){continue;}
          tmpManualList.add(str);
        }

        //레시피 매뉴얼 이미지를 리스트로 변환
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
  }


  void getRecipeByDatabase({String keyword="SHOW_MY_RECIPE"}) async {
    List<dynamic> result;
    if(keyword == "SHOW_MY_RECIPE"){
      result = await api.getRecipeByDatabase(keyword: keyword, author: "admin");
    }
    else{
      result = await api.getRecipeByDatabase(keyword: keyword);
    }

    if(result.length > 0){
      for(int i = 0; i < result.length; i++){
        Recipe item = result[i] as Recipe;

        List<String> tmpManualList = [];

        int j = 0;
        while(item.manualList.isNotEmpty && j < 20){
          String str = item.manualList[i];
          if(str == ""){continue;}
          tmpManualList.add(str);

          j++;
        }

        List<String> tmpImgList = [];
        int k = 0;
        while(item.imageList.isNotEmpty && k < 20){
          String str = item.imageList[i];
          if(str == ""){continue;}
          tmpImgList.add(str);

          k++;
        }

        item.manualList = tmpManualList;
        item.imageList = tmpImgList;

        recipeList.add(item);
      }
    }
  }


  ///레시피 삭제
  Future<bool> deleteRecipe() async {
    isDone.value = false;

    List<Recipe> deleteList = [];
    int count = 0;

    for(int i = 0; i < recipeList.value.length; i++){
      if(recipeList.value[i].isDelete){
        deleteList.add(recipeList.value[i]);
        count++;
      }
    }

    RecipeListJson json = new RecipeListJson();
    json.setRecipeList(deleteList);
    json.setCount(count);

    bool isComplete = await api.deleteRecipe(json);

    isDone.value = true;

    return isComplete;
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
    isDone.value = false;

    await recipePackaging();
    recipe.value.recipeImg = await imageToBase64();

    bool isComplete = await api.insertRecipe(recipe.value);

    isDone.value = true;
    return isComplete;
  }

  ///레시피 정보 패키징
  Future<void> recipePackaging() async {
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


  Future<void> onClickFavorite(Recipe recipe) async {
    if(recipe.isFavorite == 1){
      recipe.isFavorite = 2;
      return;
    }
    else if(recipe.isFavorite == 2){
      recipe.isFavorite = 1;
    }
    return;
  }


//#region 카카오 계정 연동

  Future<void> checkLogin() async {
    OAuthToken token = await TokenManager.instance.getToken();
    if(token.refreshToken == null){
      await kakaoLogin();
    }
    else{
      isLogin.value = true;
    }
  }


  Future<void> kakaoLogin() async {
    await initKakaoInstalled();
    if(isKakaoInstalled.value){
      isLogin.value = await loginWithTalk();
    }
    else{
      isLogin.value = await loginWithKakao();
    }
  }



  Future<void> initKakaoInstalled() async {
    final installed = await isKakaoTalkInstalled();
    Logger().d("Kakao Install : ${installed.toString()}");

    isKakaoInstalled.value = installed;
  }

  Future<void> _issueAccessToken(String authCode) async {
    try{
      AccessTokenResponse token = await AuthApi.instance.issueAccessToken(authCode);
      TokenManager.instance.setToken(token);
      Logger().d(token);
    }
    catch(e){
      Logger().d(e.toString());
    }
  }

  Future<bool> loginWithKakao() async {
    try{
      var code = await UserApi.instance.loginWithKakaoAccount();
      //await _issueAccessToken(code);
      return true;
    }
    catch(e){
      Logger().d(e.toString());
      return false;
    }
  }


  Future<bool> loginWithTalk() async {
    try{
      var code = await UserApi.instance.loginWithKakaoTalk();
      //await _issueAccessToken(code);
      return true;
    }
    catch(e){
      Logger().d(e.toString());
      return false;
    }
  }

//#endregion


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
  String author = '';

  List<dynamic> imageList = [];
  List<dynamic> manualList = [];

  //0 : 공공데이터 -> 좋아요 없음
  //1 : 좋아요 눌림
  //2 : 좋아요 안눌림
  int isFavorite;
  bool isDelete;

  Recipe({this.name='', this.recipeImg='', this.parts='',
    this.energy='', this.carbohydrate='', this.protein='', this.fat='', this.natrium='',
    this.author='', this.isFavorite=0, this.isDelete=false});

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

  factory Recipe.fromJson(dynamic json){
    String imagePath = "http://10.0.2.2:8080/image/view?filePath=";
    return Recipe(
      name: json["recipe_name"] as String,
      recipeImg: imagePath + json['recipe_image'] as String,
      parts: "",
      energy: json['recipe_eng'].toString(),
      carbohydrate: json['recipe_cal'].toString(),
      protein: json['recipe_pro'].toString(),
      fat: json['recipe_fat'].toString(),
      natrium: json['recipe_nat'].toString(),
      author: json['recipe_author'] as String,
    );
  }
}

class RecipeListJson {
  int count = 0;
  void setCount(int value){this.count = value;}

  List<Recipe> recipeList = [];
  void setRecipeList(List<Recipe> recipeList){this.recipeList = recipeList;}

  Map<String, dynamic> toJson(){
    List<dynamic> jsonList = [];

    for(int i = 0; i < recipeList.length; i++){
      Recipe recipe = recipeList[i];
      Map<String, dynamic> json = recipe.toJson("admin");

      jsonList.add(json);
    }

    return {
      "count" : count,
      "recipeList" : jsonList,
    };
  }
}