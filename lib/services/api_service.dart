import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pocketrecipe_client/etc/data_define.dart';

class ApiService extends GetConnect {
  //서버정보
  final _server = GetPlatform.isAndroid ? "10.0.2.2:8080" : "localhost:8080";
  // final _server = "35.224.114.22:8080";

  backendGet(String path, [Map<String, dynamic>? params]) async {
    Uri url = Uri.http(_server, path, params);
    Logger().d(url.toString());
    Response response = await get(url.toString());
    return response.body;
  }

  backendPost(String url, Recipe recipe) {
    return post(url, recipe);
  }

  backendDelete(String url, RecipeListJson recipeList) {}

  backendPut(String path, Map<String, dynamic> body) {
    Uri url = Uri.http(_server, path);
    return put(url.toString(), body);
  }

  openapiGet() {}

  openapiPost() {}

  openapiDelete() {}
}
