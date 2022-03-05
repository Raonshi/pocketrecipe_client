import 'package:get/get.dart';
import 'package:pocketrecipe_client/services/api_service.dart';
import 'package:pocketrecipe_client/services/firebase_service.dart';

class InitBindingCtrl extends GetxController {
  createService() {
    //external plugin services
    Get.put(FirebaseService());

    //self-made services
    Get.put(ApiService());
  }
}
