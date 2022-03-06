import 'package:get/get.dart';

class ManualCtrl extends GetxController {
  final _manualIndex = 0.obs;
  set manualIndex(val) => _manualIndex.value = val;
  get manualIndex => _manualIndex.value;
}
