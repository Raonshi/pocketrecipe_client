import 'dart:convert';
import 'dart:io';
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
    ManualItem item = new ManualItem(index: (manualList.length == 0) ? 0 : manualList.length);
    item.manual = '';
    item.image = null;
    manualList.add(item);
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

    isDone.value = true;
  }


  Future<void> getRecipeByOpenData(String str) async {
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
      String author = await getKakaoEmail();
      result = await api.getRecipeByDatabase(keyword: keyword, author: author);
    }
    else{
      result = await api.getRecipeByDatabase(keyword: keyword);
    }

    if(result.length > 0){
      for(int i = 0; i < result.length; i++){
        Recipe item = result[i] as Recipe;

        //DB 레시피의 메뉴얼 설명을 리스트로 변환
        List<String> tmpManualList = [];
        for(int i = 0; i < item.manualList.length; i++){
          String str = item.manualList[i] == null ? "NULL" : item.manualList[i];
          tmpManualList.add(str);
        }


        //DB 레시피의 메뉴얼 이미지를 리스트로 변환
        List<String> tmpImgList = [];
        for(int i = 0; i < item.imageList.length; i++){
          String str = item.imageList[i] == null ? "NULL" : item.imageList[i];
          tmpImgList.add(str);
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
    String author = await getKakaoEmail();

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

    bool isComplete = await api.deleteRecipe(json, author);

    isDone.value = true;
    return isComplete;
  }


  ///레시피 수정
  Future<bool> updateRecipe() async {
    isDone.value = false;

    Recipe recipe = new Recipe();

    bool isComplete = await api.updateRecipe(recipe);

    isDone.value = true;
    return isComplete;
  }


  ///카메라를 통한 이미지 로드
  Future<void> encodeImageFromCamera(int type) async {
    ImagePicker picker = ImagePicker();
    final xFile = await picker.pickImage(source: ImageSource.camera) as XFile;

    //레시피 완성 이미지인 경우
    if(type == 99){
      recipe.value.recipeImg = await imageToBase64(xFile: xFile);
    }
    //레시피 메뉴얼 이미지인 경우
    else{
      if(recipe.value.imageList.length <= 0){
        for(int i = 0; i < 20; i++){
          recipe.value.imageList.add("Unknown");
        }
      }

      recipe.value.imageList[type] = await imageToBase64(xFile: xFile);
      //ManualItem item = manualList.value[type];
      //item.image = xFile;
    }
  }


  ///갤러리를 통한 이미지 로드
  Future<void> encodeImageFromGallery(int type) async {
    ImagePicker picker = ImagePicker();
    XFile? xFile = await picker.pickImage(source: ImageSource.gallery);

    //레시피 완성 이미지인 경우
    if(type == 99){
      recipe.value.recipeImg = await imageToBase64(xFile: xFile);
    }
    //레시피 메뉴얼 이미지인 경우
    else{
      if(recipe.value.imageList.isEmpty){
        for(int i = 0; i < 20; i++){
          recipe.value.imageList.add("Unknown");
        }
      }

      recipe.value.imageList[type] = await imageToBase64(xFile: xFile);
      //ManualItem item = manualList.value[type];
      //item.image = xFile;
    }
  }


  ///레시피 등록
  Future<bool> recipePosting() async {
    isDone.value = false;

    //패키징
    await recipePackaging();

    bool isComplete = await api.insertRecipe(recipe.value);

    isDone.value = true;
    return isComplete;
  }

  ///레시피 정보 패키징
  Future<void> recipePackaging() async {
    //작성자 정보 패키징
    recipe.value.author = await getKakaoEmail();

    //매뉴얼 설명, 매뉴얼 이미지 패키징
    for(int i = 0; i < 20; i++){
      if(i < manualList.length){
        ManualItem item = manualList.value[i];

        Logger().d("MANUAL : ${item.manual}");

        item.manual == '' ? recipe.value.manualList.add('') : recipe.value.manualList.add(item.manual);
        //String base64 = await imageToBase64(xFile: item.image);
        //recipe.value.imageList.add(base64);
      }
      else{
        recipe.value.manualList.add('');
        //String base64 = await imageToBase64(xFile: null);
        //recipe.value.imageList.add(base64);
      }
    }
  }

  ///이미지 파일을 base64코드로 변환
  Future<String> imageToBase64({XFile? xFile}) async {
    //이미지가 없을 경우
    if(xFile == null){
      return "Unknown";
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


//#region 카카오 계정
  Future<String> getKakaoEmail() async {
    String email = 'guest';
    try{
      User user = await UserApi.instance.me();
      if(user.kakaoAccount != null && user.kakaoAccount!.email != null){
        email = user.kakaoAccount!.email!;
      }
    }
    catch(e){
      e.printError();
    }
    return email;
  }

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
    isKakaoInstalled.value = installed;
  }


  Future<bool> loginWithKakao() async {
    try{
      await UserApi.instance.loginWithKakaoAccount();
      return true;
    }
    catch(e){
      return false;
    }
  }


  Future<bool> loginWithTalk() async {
    try{
      await UserApi.instance.loginWithKakaoTalk();
      return true;
    }
    catch(e){
      return false;
    }
  }

//#endregion


}


class Recipe{
  String name = 'Unknown';
  String recipeImg = 'Unknown';
  String parts = 'Unknown';

  String energy = '0';
  String natrium = '0';
  String carbohydrate = '0';
  String fat = '0';
  String protein = '0';
  String author = 'Unknown';

  List<dynamic> imageList = [];
  List<dynamic> manualList = [];

  //0 : 공공데이터 -> 좋아요 없음
  //1 : 좋아요 눌림
  //2 : 좋아요 안눌림
  int isFavorite;
  bool isDelete;
  bool isUpdate;

  Recipe({this.name='Unknown', this.recipeImg='Unknown', this.parts='Unknown',
    this.energy='0', this.carbohydrate='0', this.protein='0', this.fat='0', this.natrium='0',
    this.author='Unknown', this.isFavorite=0, this.isDelete=false, this.isUpdate=false});

  void setName(String value) => this.name = value;
  void setImage(String value) => this.recipeImg = value;
  void setParts(String value) => this.parts = value;
  void setEnergy(String value) => this.energy = value;
  void setCal(String value) => this.carbohydrate = value;
  void setPro(String value) => this.protein = value;
  void setFat(String value) => this.fat = value;
  void setNa(String value) => this.natrium = value;
  void setManualList(List<dynamic> value) => this.manualList = value;
  void setImageList(List<dynamic> value) {

    for(int i = 0; i < value.length; i++){
      if(value[i] == "Unknown"){
        imageList.add(value[i]);
      }
      else{
        imageList.add("http://220.86.224.184:12000/image/view?filePath=" + value[i]);
      }
    }
  }


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
    String imagePath = "http://220.86.224.184:12000/image/view?filePath=";
    return Recipe(
      name: json["recipe_name"] as String,
      recipeImg: json['recipe_image'] == "Unknown" ? "Unknown" : imagePath + json['recipe_image'] as String,
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

  Map<String, dynamic> toJson(String author) {
    List<dynamic> jsonList = [];

    for(int i = 0; i < recipeList.length; i++){
      Recipe recipe = recipeList[i];
      Map<String, dynamic> json = recipe.toJson(author);
      jsonList.add(json);
    }

    return {
      "count" : count,
      "recipeList" : jsonList,
    };
  }
}