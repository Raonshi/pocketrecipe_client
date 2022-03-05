import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocketrecipe_client/controllers/init_binding_ctrl.dart';
import 'package:pocketrecipe_client/ui/pages/home_page.dart';

void main() {
  final initBinding = Get.put(InitBindingCtrl());
  initBinding.createService();

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
