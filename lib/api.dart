import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class API{

  final _endpoint = 'openapi.foodsafetykorea.go.kr';
  final _key = '26ad987100ed4b05baf0';
  final _service = 'COOKRCP01';
  final _type = 'json';
  final _start = '1';
  final _end = '5';

  void test() async{
    var result = await getRecipeByName('된장국');
    print("결과 : ${result['row']}");
  }


  Future<dynamic> getRecipeByName(String recipeName) async{
    final option = '/api/' + _key + '/' + _service + '/' + _type + '/' + _start + '/' + _end + '/RCP_NM=' + recipeName;
    Uri uri = Uri.http(_endpoint, option);

    var response = await http.get(uri);

    if(response.statusCode != 200){
      print("Http Get Failed : ${response.statusCode}");
    }

    var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;

    return jsonResponse['COOKRCP01'];
  }

}