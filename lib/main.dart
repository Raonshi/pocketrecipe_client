import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocketrecipe_client/ui/pages/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Pocket Recipe",
      home: HomePage(),
    );
  }
}
