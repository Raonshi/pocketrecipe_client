import 'package:get/get.dart';
import 'package:pocketrecipe_client/services/api_service.dart';
import 'package:pocketrecipe_client/services/firebase_service.dart';

class InitBindingCtrl extends GetxController {
  final _isLoad = false.obs;
  set isLoad(val) => _isLoad.value = val;
  get isLoad => _isLoad.value;

  createService() {
    //external plugin services
    Get.put(FirebaseService());

    //self-made services
    Get.put(ApiService());
  }

  initService() {
    Get.find<FirebaseService>().initService();

    isLoad = true;
  }
}
