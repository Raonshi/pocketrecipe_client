import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'getx/controller.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HomeWidget();
  }
}



class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  final controller = Get.put(TestController());

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          ElevatedButton(onPressed: controller.addCount, child: Text("Click!")),
          Obx((){return Text("${controller.count}");}),
        ],
      ),
    );
  }
}

