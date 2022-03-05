import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pocketrecipe_client/etc/data_define.dart';
import 'package:pocketrecipe_client/services/api_service.dart';
import 'package:pocketrecipe_client/ui/widgets/manual_add_item.dart';

class RecipePostCtrl extends GetxController {
  final api = Get.find<ApiService>();
  final _postPageController = PageController(initialPage: 0).obs;
  get postpageController => _postPageController.value;

  final _postPageIndex = 0.obs;
  set postPageIndex(val) => _postPageIndex.value = val;
  get postPageIndex => _postPageIndex.value;

  final _recipe = Recipe().obs;
  get recipe => _recipe.value;

  final _manualItemList = [].obs;
  get manualItemList => _manualItemList.value;

  ///매뉴얼 항목 추가
  void manualAdd() {
    recipe.manualList.add('');
    recipe.imageList.add('Unknown');
    _recipe.refresh();
  }

  ///매뉴얼 항목 삭제
  void manualSub() {
    recipe.manualList.removeLast();
    recipe.imageList.removeLast();
    _recipe.refresh();
  }

  ///메뉴얼 이미지 바이트 코드 생성: 테스트 function
  ///isCam == true : 카메라 촬영
  ///isCam == false : 갤러리 참조
  Future<String> encodeManualImage(bool isCam) async {
    ImagePicker picker = ImagePicker();
    final xFile = isCam
        ? await picker.pickImage(source: ImageSource.camera) as XFile
        : await picker.pickImage(source: ImageSource.gallery) as XFile;
    String base64 = await imageToBase64(xFile: xFile);
    return base64;
  }

  ///레시피 완성 이미지 바이트 코드 생성: 테스트 function
  ///isCam == true : 카메라 촬영
  ///isCam == false : 갤러리 참조
  Future<void> encodeRecipeImage(bool isCam) async {
    ImagePicker picker = ImagePicker();
    final xFile = isCam
        ? await picker.pickImage(source: ImageSource.camera) as XFile
        : await picker.pickImage(source: ImageSource.gallery) as XFile;
    String base64 = await imageToBase64(xFile: xFile);
    recipe.recipeImg = base64;
  }

  ///이미지 파일을 base64코드로 변환
  Future<String> imageToBase64({XFile? xFile}) async {
    //이미지가 없을 경우
    if (xFile == null) {
      return "Unknown";
    }
    //이미지가 있을 경우
    else {
      File file = new File(xFile.path);
      return base64.encode(file.readAsBytesSync());
    }
  }

  Future<bool> recipePosting() async =>
      await api.backendPut('/insertRecipe', recipe);
}
