import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
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
}


class OpenSourceInfoPage extends StatelessWidget {
  const OpenSourceInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("오픈소스 정보"),
      ),
      body: Text("오픈소스 정보"),
    );
  }
}

