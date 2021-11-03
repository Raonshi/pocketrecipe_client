import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:logger/logger.dart';
import 'getx/controller.dart';


class API{
  //공공데이터 정보
  final _endpoint = 'openapi.foodsafetykorea.go.kr';
  final _key = '26ad987100ed4b05baf0';
  final _service = 'COOKRCP01';

  //데이터베이스 서버 정보 - 테스트
  final _testDbServer = "10.0.2.2:8080";

  //데이터베이스 서버 정보 - 라이브
  final _dbSever = "220.86.224.184:12010";

  //final _type = 'testing_data.json';
  final _type = 'json';

  final _start = '1';
  final _end = '5';

  void test() async{
    var result = await getRecipeByKeyword('된장국');
    print("결과 : ${result['row']}");
  }


  ///공공데이터포털의 레시피 데이터를 가져온다.
  Future<dynamic> getRecipeByKeyword(String recipeName) async{
    
    if(Platform.environment.containsKey('FLUTTER_TEST')){
      String jsonString = await readTestingData();
      return convert.jsonDecode(jsonString) as Map<String, dynamic>;
    }

    final option = '/api/' + _key + '/' + _service + '/' +
        _type + '/' + _start + '/' + _end + '/RCP_NM=' + recipeName;

    Uri uri = Uri.http(_endpoint, option);
    Logger().d("LINK : $uri");

    var response = await http.get(uri);

    if(response.statusCode != 200){
      Logger().d("Http Get Failed : ${response.statusCode}");
      return;
    }

    var utf8Data = utf8.decode(response.bodyBytes);
    var jsonResponse = convert.jsonDecode(utf8Data) as Map<String, dynamic>;
    return jsonResponse['COOKRCP01'];
  }

  ///서버의 데이터베이스에서 결과를 조회한다.
  Future<dynamic> getRecipeByDatabase({required String keyword, String? author}) async {
    dynamic params;
    Uri uri;
    if(keyword == "SHOW_MY_RECIPE"){
      params = {
        "keyword" : keyword,
        "author" : author,
      };

      uri = Uri.http(_testDbServer,"searchMyRecipe", params);
    }
    else{
      params = {
        "keyword" : keyword,
      };

      uri = Uri.http(_testDbServer,"searchRecipe", params);
    }

    Logger().d("LINK : $uri");

    var response = await http.get(uri);
    if(response.statusCode != 200){
      Logger().d("Http Get Failed : ${response.statusCode}");
      return;
    }

    var utf8Decode = utf8.decode(response.bodyBytes);
    var jsonResponse = jsonDecode(utf8Decode) as List;
    List list = jsonResponse.map((e) => Recipe.fromJson(e)).toList();

    return list;
  }


  ///데이터베이스 서버에 레시피 정보를 저장한다.
  Future<bool> insertRecipe(Recipe recipe) async {
    Uri uri = Uri.http(_testDbServer, "/insertRecipe");
    Logger().d("LINK : $uri");

    var response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: convert.json.encode(recipe.toJson("admin")),
    );

    if(response.statusCode != 200){
      Logger().d("REST API (POST) Failed : ${response.statusCode}");
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


  ///사용자가 선택한 레시피 정보를 매개변수로 전달하여 서버의 레시피를 제거한다.
  Future<bool> deleteRecipe(RecipeListJson deleteList) async {
    Uri uri = Uri.http(_testDbServer, "/deleteRecipe");
    Logger().d("LINK : $uri");

    var response = await http.delete(
      uri,
      headers: {"Content-Type": "application/json"},
      body: convert.json.encode(deleteList.toJson()),
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


//#region 테스트환경 json코드
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