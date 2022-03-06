import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';


class FirebaseService extends GetxService {
  void initService() async {
    await Firebase.initializeApp();
    Logger().d("<<==== Firebase App Start ====>>");
  }

  //로그인 체크
  loginCheck() {
    FirebaseAuth
  }

  //
}
