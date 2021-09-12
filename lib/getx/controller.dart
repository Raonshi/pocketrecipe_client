import 'package:get/get.dart';

class TestController extends GetxController{
  RxInt count = 0.obs;

  void addCount(){
    count++;
  }
}