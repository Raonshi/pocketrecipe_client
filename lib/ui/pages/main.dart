import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocketrecipe_client/getx/controller.dart';

import '../../api.dart';
import 'home.dart';

void main() => runApp(PocketRecipe(false));


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
      ),
    );
  }
}
