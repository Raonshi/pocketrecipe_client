import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:pocketrecipe_client/etc/data_define.dart';
import 'package:pocketrecipe_client/services/api_service.dart';
import 'package:pocketrecipe_client/services/firebase_service.dart';

class RecipePostCtrl extends GetxController {
  final api = Get.find<ApiService>();
  final fire = Get.find<FirebaseService>();
  final _postPageController = PageController(initialPage: 0).obs;
  get postpageController => _postPageController.value;

  final _postPageIndex = 0.obs;
  set postPageIndex(val) => _postPageIndex.value = val;
  get postPageIndex => _postPageIndex.value;

  final _recipe = Recipe().obs;
  get recipe => _recipe.value;

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
  encodeManualImage(bool isCam, int index) async {
    ImagePicker picker = ImagePicker();
    final xFile = isCam
        ? await picker.pickImage(source: ImageSource.camera) as XFile
        : await picker.pickImage(source: ImageSource.gallery) as XFile;
    String base64 = await imageToBase64(xFile: xFile);
    recipe.imageList[index] = base64;
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

  //레시피 등록
  recipePosting() async {
    bool isUpload = true;
    //먼저 이미지를 저장한다.
    recipe.imageList.asMap().forEach((index, image) async {
      if (image != 'Unknown' && isUpload) {
        isUpload = await fire.imageUpload(image, recipe.name, index);
      }
    });

    //이미지 저장이 완료되면 데이터를 저장한다.
    if (!isUpload) {
      Logger().d("<<==== Manual Image Upload Fail ====>>");
      return;
    }
    await api.backendPut('/insert-recipe', recipe);
  }
}
