import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:logger/logger.dart';

class API{
  final _endpoint = 'openapi.foodsafetykorea.go.kr';
  final _key = '26ad987100ed4b05baf0';
  final _service = 'COOKRCP01';

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
    
    final option = '/api/' + _key + '/' + _service + '/' + _type + '/' + _start + '/' + _end + '/RCP_NM=' + recipeName;
    Uri uri = Uri.http(_endpoint, option);

    Logger().d("LINK : $uri");

    var response = await http.get(uri);

    if(response.statusCode != 200){
      print("Http Get Failed : ${response.statusCode}");
      return;
    }

    var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;

    return jsonResponse['COOKRCP01'];
  }

  ///서버의 데이터베이스에서 결과를 조회한다.
  Future<dynamic> getRecipeByDatabase(String keyword) async {
    String server = "127.0.0.1:8080";
    String service = "/searchRecipe";
    dynamic params = {
      "keyword" : keyword
    };

    Uri uri = Uri.http(server,service, params);

    Logger().d("LINK : $uri");

    var response = await http.get(uri);

    if(response.statusCode != 200){
      print("Http Get Failed : ${response.statusCode}");
      return;
    }

    Logger().d(response.body);

    var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;

    return jsonResponse['COOKRCP01'];
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