import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:logger/logger.dart';
import 'package:pocketrecipe_client/api.dart';
import 'package:pocketrecipe_client/ui/widgets/manual_add_item.dart';
import 'package:sprintf/sprintf.dart';
import 'package:pocketrecipe_client/data_define.dart';

class Controller extends GetxController{

  ///Restful API 사용을 위한 인터넷 접속 객체
  API api = new API();

  ///레시피 객체
  var recipeList = <Recipe>[].obs;
  Rx<Recipe> recipe = Recipe().obs;

  ///앱 화면 전환 카운트
  RxInt centerPageSelect = 1.obs;

  ///레시피 등록 시 사용되는 매뉴얼 항목
  RxList manualList = <ManualItem>[].obs;

  ///온라인 작업 완료 여부 : 기본 값은 true
  RxBool isDone = true.obs;

  ///카카오 설치 여부 확인
  RxBool isKakaoInstalled = false.obs;
  RxBool isLogin = false.obs;

  ///매뉴얼 항목 추가
  void manualAdd(){
    ManualItem item = new ManualItem(index: (manualList.length == 0) ? 0 : manualList.length);
    item.manual = '';
    item.imageBase64 = 'Unknown';
    manualList.add(item);
  }

  ///매뉴얼 항목 삭제
  void manualSub(){
    manualList.removeLast();
  }

  ///신규 레시피 데이터 생성
  void generateRecipe() => this.recipe = new Recipe().obs;


//#region 레시피 검색/등록/삭제/수정
  ///<h2>레시피 키워드로 검색하기</h2>
  ///<p>매개변수 [keyword]가 포함된 레시피 정보를 조회한다.</p>
  ///<p>param: String keyword</p>
  ///<p>return: void</p>
  void getRecipeByKeyword(String keyword) async {
    isDone.value = false;
    recipeList.clear();

    //먼저 공공데이터에서 결과를 가져온다.
    await getRecipeByOpenData(keyword);
    //데이터베이스에서 결과를 가져온다.
    getRecipeByDatabase(keyword: keyword);

    isDone.value = true;
  }


  ///<h2>공공데이터 레시피 데이터 조회</h2>
  ///<p>식품안전나라 레시피 공공데이터에서 매개변수 [keyword]이 포함된 레시피 정보를 조회한다.</p>
  ///<p>params: String keyword</p>
  ///<p>return: void</p>
  Future<void> getRecipeByOpenData(String keyword) async {
    dynamic result = await api.getRecipeByKeyword(keyword);

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


  ///<h2>서버 레시피 데이터 조회</h2>
  ///<p>서버 데이터 베이스에서 매개변수 [keyword]이 포함된 레시피 정보를 조회한다.</p>
  ///<p>params: String keyword</p>
  ///<p>return: void</p>
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


  ///<h2>서버 레시피 데이터 삭제</h2>
  ///<p>사용자가 선택한 레시피들이 저장된 [recipeList]를 참조한다.</p>
  ///<p>[recipeList]에 포함된 레시피 데이터를 서버에서 삭제한다.</p>
  ///<p>return: bool</p>
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


  ///<h2>서버 레시피 데이터 수정</h2>
  ///<p>사용자가 선택한 [Recipe]의 정보를 수정한다.</p>
  ///<p>수정된 결과를 서버로 보내 갱신한다.</p>
  ///<p>return: bool</p>
  Future<bool> updateRecipe() async {
    isDone.value = false;
    Recipe recipe = new Recipe();

    bool isComplete = await api.updateRecipe(recipe);
    isDone.value = true;
    return isComplete;
  }


  ///<h2>서버 레시피 데이터 등록</h2>
  ///<p>사용자가 작성한 [Recipe]의 정보를 서버 데이터베이스에 등록한다.</p>
  ///<p>return: bool</p>
  Future<bool> recipePosting() async {
    isDone.value = false;
    //패키징
    await recipePackaging();
    bool isComplete = await api.insertRecipe(recipe.value);
    isDone.value = true;
    return isComplete;
  }


  ///<h2>레시피 정보 직렬화</h2>
  ///<p>사용자가 작성한 레시피 정보를 JSON형식으로 직렬화한다.</p>
  ///<p>return: void</p>
  Future<void> recipePackaging() async {
    //작성자 정보 패키징
    recipe.value.author = await getKakaoEmail();

    //매뉴얼 설명, 매뉴얼 이미지 패키징
    for(int i = 0; i < 20; i++){
      if(i < manualList.length){
        ManualItem item = manualList.value[i];
        Logger().d("MANUAL : ${item.manual}");
        recipe.value.manualList.add(item.manual);
        recipe.value.imageList.add(item.imageBase64);
      }
      else{
        recipe.value.manualList.add('');
        recipe.value.imageList.add('Unknown');
      }
    }
  }
//endregion


//#region 이미지 처리
  ///메뉴얼 이미지 바이트 코드 생성: 테스트 function
  ///isCam == true : 카메라 촬영
  ///isCam == false : 갤러리 참조
  Future<String> encodeManualImage(bool isCam) async {
    ImagePicker picker = ImagePicker();
    final xFile = isCam ? await picker.pickImage(source: ImageSource.camera) as XFile : await picker.pickImage(source: ImageSource.gallery) as XFile;
    String base64 = await imageToBase64(xFile: xFile);
    return base64;
  }


  ///레시피 완성 이미지 바이트 코드 생성: 테스트 function
  ///isCam == true : 카메라 촬영
  ///isCam == false : 갤러리 참조
  Future<void> encodeRecipeImage(bool isCam) async {
    ImagePicker picker = ImagePicker();
    final xFile = isCam ? await picker.pickImage(source: ImageSource.camera) as XFile : await picker.pickImage(source: ImageSource.gallery) as XFile;
    String base64 = await imageToBase64(xFile: xFile);
    recipe.value.recipeImg = base64;
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
//#endregion


//#region 카카오 계정
  ///<h2>연동된 카카오 계정에서 이메일 정보 조회</h2>
  ///<p>레시피 등록시 레시피의 작성자를 확인하기 위한 용도로 사용함</p>
  Future<String> getKakaoEmail() async {
    String email = 'guest';

    await checkLogin();
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


  ///<h2>카카오 로그인 여부 확인</h2>
  ///<p>이미 로그인 되어 있는지 확인한다.</p>
  Future<void> checkLogin() async {
    OAuthToken token = await TokenManager.instance.getToken();

    if(token.refreshToken == null){
      await kakaoLogin();
    }
    else{
      isLogin.value = true;
    }
  }


  ///<h2>카카오 로그인</h2>
  ///<p>로그인 과정을 수행한다.</p>
  Future<void> kakaoLogin() async {
    await initKakaoInstalled();
    if(isKakaoInstalled.value){
      isLogin.value = await loginWithTalk();
    }
    else{
      isLogin.value = await loginWithKakao();
    }
  }


  ///<h2>카카오톡 설치 확인</h2>
  ///<p>클라이언트에 카카오톡 앱이 설치되어 있는지 확인한다.</p>
  Future<void> initKakaoInstalled() async {
    final installed = await isKakaoTalkInstalled();
    isKakaoInstalled.value = installed;
  }


  ///<h2>카카오 웹페이지 로그인</h2>
  ///<p>웹페이지를 통해 카카오 계정으로 로그인한다.</p>
  Future<bool> loginWithKakao() async {
    try{
      await UserApi.instance.loginWithKakaoAccount();
      return true;
    }
    catch(e){
      return false;
    }
  }


  ///<h2>카카오톡 로그인</h2>
  ///<p>클라이언트에 설치되어 있는 카카오톡 앱을 통해 로그인한다.</p>
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
