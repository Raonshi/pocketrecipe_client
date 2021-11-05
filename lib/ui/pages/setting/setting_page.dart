import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocketrecipe_client/getx/controller.dart';

class SettingPage extends StatelessWidget {
  final controller = Get.put(Controller());


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Divider(),

        ListTile(
          trailing: Icon(Icons.login_rounded, size: 50,),
          title: Obx(() => Text(controller.isLogin.value ? "로그인되었습니다." : "카카오톡 로그인")),
          onTap: () async {
            await controller.kakaoLogin();
            loginPopup(controller, context, controller.isLogin.value);
          },
        ),


        Divider(),

        ListTile(
          title: Text("오픈소스 정보"),
          onTap: (){
            Get.to(OpenSourceInfoPage());
          },
        ),

        Divider(),

        ListTile(
          title: Text("개발자 정보"),
          subtitle: Text("sunwonsw95@gmail.com"),
        ),

        Divider(),

        ListTile(
          title: Text("버전 정보"),
          subtitle: Text("Version 1.0.0"),
        ),

        Divider(),

      ],
    );
  }


  void loginPopup(Controller controller, BuildContext context, bool isLogin){
    showDialog(context: context, builder: (BuildContext context){
      return isLogin ? AlertDialog(
        title: Text("로그인 성공"),
        content: Text("로그인에 성공하였습니다."),
        actions: [
          ElevatedButton(onPressed: () => Navigator.pop(context), child: Text("닫기")),
        ],
      ) : AlertDialog(
          title: Text("로그인 실패"),
          content: Text("로그인에 실패하였습니다."),
          actions: [
            ElevatedButton(onPressed: () => Navigator.pop(context), child: Text("닫기")),
          ]
      );
    });
  }
}


class OpenSourceInfoPage extends StatelessWidget {
  const OpenSourceInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("오픈소스 정보"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Divider(),
          ListTile(
            title: Text("GetX"),
            subtitle: Text("get"),
          ),
          Divider(),
          ListTile(
            title: Text("Kakao Login"),
            subtitle: Column(
              children: [
                Text("kakao_flutter_sdk | dio | json_annotation", textAlign: TextAlign.left,),
                Text("package_info | shared_preferences | platform", textAlign: TextAlign.left),
              ]
            )
          ),
          Divider(),
          ListTile(
            title: Text("HTTP"),
            subtitle: Text("http"),
          ),
          Divider(),
          ListTile(
            title: Text("LOG"),
            subtitle: Text("logger"),
          ),
          Divider(),
          ListTile(
            title: Text("IMAGE"),
            subtitle: Text("image_picker"),
          ),
          Divider(),
        ],
      ),
    );
  }
}

