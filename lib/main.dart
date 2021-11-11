import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocketrecipe_client/ui/pages/home.dart';
import 'package:kakao_flutter_sdk/all.dart';

void main() {
  KakaoContext.clientId = "44254f2da86dd52e9554e98faa55664d";
  KakaoContext.javascriptClientId = "755748289fa0f2202428ea0b2797f778";

  runApp(PocketRecipe(false));
}


class PocketRecipe extends StatelessWidget {
  final isTest;
  PocketRecipe(this.isTest);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Pocket Recipe",
      home: Scaffold(
        appBar: AppBar(title: Text("포켓레시피", style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),),
        body: Home(),
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}
