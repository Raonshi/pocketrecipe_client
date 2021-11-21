import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:logger/logger.dart';
import 'package:pocketrecipe_client/data_define.dart';


class API{
  //공공데이터 정보
  final _endpoint = 'openapi.foodsafetykorea.go.kr';
  final _key = '26ad987100ed4b05baf0';
  final _service = 'COOKRCP01';

  //데이터베이스 서버 정보 - 테스트
  final _testDbServer = "10.0.2.2:8080";

  //데이터베이스 서버 정보 - 라이브
  final _dbServer = "220.86.224.184:12000";

  //final _type = 'testing_data.json';
  final _type = 'json';

  final _start = '1';
  final _end = '5';


//#region 공공데이터 API
  ///<h2>공공데이터 조회</h2>
  ///<p>식품안전나라 공공데이터의 레시피 데이터를 가져온다.</p>
  ///<p>params: [String] recipeName</p>
  ///<p>result: [dynamic]</p>
  Future<dynamic> getRecipeByKeyword(String recipeName) async{
    
    if(Platform.environment.containsKey('FLUTTER_TEST')){
      String jsonString = await readTestingData();
      return convert.jsonDecode(jsonString) as Map<String, dynamic>;
    }

    final option = '/api/' + _key + '/' + _service + '/' +
        _type + '/' + _start + '/' + _end + '/RCP_NM=' + recipeName;

    Uri uri = Uri.http(_endpoint, option);
    var utf8Data = await getUri(uri);

    var jsonResponse = convert.jsonDecode(utf8Data) as Map<String, dynamic>;
    return jsonResponse['COOKRCP01'];
  }

//#endregion


//#region 서버DB API
  ///<h2>서버 DB 조회</h2>
  ///<p>서버의 데이터베이스에서 결과를 조회한다.</p>
  ///<p>params: [String] keyword, [String] author
  ///<p>return: dynamic</p>
  Future<dynamic> getRecipeByDatabase({required String keyword, String? author}) async {
    if(Platform.environment.containsKey('FLUTTER_TEST')){
      String jsonString = await readTestingData();
      return convert.jsonDecode(jsonString) as Map<String, dynamic>;
    }

    dynamic params;
    Uri uri;
    if(keyword == "SHOW_MY_RECIPE"){
      params = {
        "keyword" : keyword,
        "author" : author,
      };
      uri = Uri.http(_dbServer,"searchMyRecipe", params);
    }
    else{
      params = {
        "keyword" : keyword,
      };
      uri = Uri.http(_dbServer,"searchRecipe", params);
    }
    var utf8Decode = await getUri(uri);

    var jsonResponse = jsonDecode(utf8Decode) as List;
    List list = [];
    for(int i = 0; i <jsonResponse.length; i++){
      dynamic item = jsonResponse[i];
      Recipe recipe = Recipe.fromJson(item);

      recipe.setManualList(item['recipe_manualList'] as List);
      recipe.setImageList(item['recipe_imageList'] as List);

      list.add(recipe);
    }
    return list;
  }


  ///<h2>레시피 등록</h2>
  ///<p>데이터베이스 서버에 레시피 정보를 저장한다.</p>
  ///<p>params: [Recipe] recipe</p>
  ///<p>return: bool</p>
  Future<bool> insertRecipe(Recipe recipe) async {
    Uri uri = Uri.http(_dbServer, "/insertRecipe");

    String response = await postUri(uri, recipe);
    if(response == "Success"){
      return true;
    }
    else{
      return false;
    }
  }


  ///<h2>레시피 삭제</h2>
  ///<p>사용자가 선택한 레시피 정보를 매개변수로 전달하여 서버의 레시피를 제거한다.</p>
  ///<p>params: [RecipeListJson] deleteList<p>
  ///<p>return: bool</p>
  Future<bool> deleteRecipe(RecipeListJson deleteList, String author) async {
    Uri uri = Uri.http(_dbServer, "/deleteRecipe");
    Logger().d("LINK : $uri");

    var response = await http.delete(
      uri,
      headers: {"Content-Type": "application/json"},
      body: convert.json.encode(deleteList.toJson(author)),
    );

    if(response.statusCode != 200){
      Logger().d("REST API (DELETE) Failed : ${response.statusCode}");
      return false;
    }
    else{
      if(response.body == "Success"){
        return true;
      }
      else{
        return false;
      }
    }
  }


  Future<bool> updateRecipe(Recipe recipe) async {
    Uri uri = Uri.http(_dbServer, "/updateRecipe");
    String response = await postUri(uri, recipe);

    if(response == "Success"){
      return true;
    }
    else{
      return false;
    }
  }

//#endregion
  Future<dynamic> getUri(Uri uri) async {
    var response = await http.get(uri);
    if(response.statusCode != 200){
      Logger().d("Http Get Failed : ${response.statusCode}");
      return;
    }
    return utf8.decode(response.bodyBytes);
  }


  Future<dynamic> postUri(Uri uri, Recipe recipe) async {
    var response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: convert.json.encode(recipe.toJson(recipe.author)),
    );

    if(response.statusCode != 200){
      Logger().d("REST API (UPDATE) FAIL : ${response.statusCode}");
      return false;
    }
    return response.body;
  }



//#region 테스트환경 json코드

  void test() async{
    var result = await getRecipeByKeyword('된장국');
    print("결과 : ${result['row']}");
  }


  Future<File> get _localFile async {
    final path = "data/testing_data.json";
    return File('$path');
  }

  Future<String> readTestingData() async {
    try {
      final file = await _localFile;

      // 파일 읽기.
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      // 에러가 발생할 경우.
      return "nothing";
    }
  }
//#endregion

}