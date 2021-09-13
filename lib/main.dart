import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'api.dart';
import 'home.dart';

void main() => runApp(PocketRecipe());


class PocketRecipe extends StatelessWidget {
  const PocketRecipe({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    API api = new API();
    api.test();

    return GetMaterialApp(
      title: "Pocket Recipe",
      home: Scaffold(
        appBar: AppBar(title: Text("포켓레시피", style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),),
        body: Home(),
      ),
    );
  }
}
