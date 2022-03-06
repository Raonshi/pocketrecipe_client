import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sprintf/sprintf.dart';

class FirebaseService extends GetxService {
  final _isLogin = false.obs;
  set isLogin(val) => _isLogin.value = val;
  get isLogin => _isLogin.value;

  late final user;

  void initService() async {
    await Firebase.initializeApp();
    Logger().d("<<==== Firebase App Start ====>>");

    loginCheck();
  }

  //로그인 체크
  loginCheck() {
    final auth = FirebaseAuth.instance;

    //사용자 인증 상태 체크
    auth.authStateChanges().listen((User? user) {
      if (user == null && !isLogin) {
        Logger().d("User Sign-out");
      } else {
        isLogin = true;
        Logger().d("User Sign-in");
      }
    });

    if (!isLogin) {
      login();
      user = FirebaseAuth.instance.currentUser;
      Logger().d("<<==== Sign in Success ====>>");
    }
  }

  login() async {
    try {
      final GoogleSignIn googleSignIn = GetPlatform.isAndroid
          ? GoogleSignIn(scopes: ['profile', 'email'])
          : GoogleSignIn();

      final GoogleSignInAccount? account = await googleSignIn.signIn();
      final GoogleSignInAuthentication? authentication =
          await account?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: authentication?.accessToken,
        idToken: authentication?.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      Logger().d("<<==== GoogleSignIn Error ====>>");
      Logger().d(e);
    }
  }

  logout() async {
    try {
      await FirebaseAuth.instance.currentUser!.delete();
      // await FirebaseAuth.instance.signOut();
      isLogin = false;
      Logger().d("<<==== Sign out Success ====>>");
    } catch (e) {
      Logger().d("<<==== Sign out Fail ====>>");
      Logger().d(e);
    }
  }

  imageUpload(String base64, String path, int index) async {
    try {
      String dataUrl = 'data:image/png;base64,$base64';

      await FirebaseStorage.instance
          .ref("/recipe")
          .child(path)
          .child('MANUAL_IMG${sprintf("%02d", [index])}.png')
          .putString(dataUrl, format: PutStringFormat.dataUrl);
      Logger().d("<<==== Image Upload Done ====>>");
      return true;
    } catch (e) {
      Logger().d("<<==== Image Upload Error ====>>");
      Logger().d(e);
      return false;
    }
  }
}
