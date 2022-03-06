import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pocketrecipe_client/controllers/init_binding_ctrl.dart';
import 'package:pocketrecipe_client/etc/style.dart';
import 'package:pocketrecipe_client/etc/translate.dart';
import 'package:pocketrecipe_client/services/firebase_service.dart';
import 'package:pocketrecipe_client/ui/pages/home_page.dart';
import 'package:pocketrecipe_client/ui/pages/login_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final initBinding = Get.put(InitBindingCtrl());
  initBinding.createService();
  initBinding.initService();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: mainTheme,
      translations: Language(),
      locale: Locale('ko', 'KR'),
      fallbackLocale: Locale('ko', 'KR'),
      title: "Pocket Recipe",
      home: Obx(() {
        Logger().d(Get.find<FirebaseService>().isLogin);
        return Get.find<FirebaseService>().isLogin ? HomePage() : LoginPage();
      }),
    );
  }
}
