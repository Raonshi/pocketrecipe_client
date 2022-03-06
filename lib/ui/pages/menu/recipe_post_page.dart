import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pocketrecipe_client/controllers/recipe_post.ctrl.dart';
import 'package:pocketrecipe_client/etc/style.dart';

class RecipePostPage extends StatelessWidget {
  RecipePostPage({Key? key}) : super(key: key);
  final controller = Get.put(RecipePostCtrl());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("recipe_post".tr)),
      body: SafeArea(
        child: Obx(
          () => GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: PageView(
              controller: controller.postpageController,
              onPageChanged: (value) => controller.postPageIndex = value,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                RecipePost1(),
                RecipePost2(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RecipePost1 extends StatelessWidget {
  final controller = Get.find<RecipePostCtrl>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          //레시피 이름
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              RecipeInfoInputWidget(
                hint: 'recipe_name'.tr,
                onChanged: (str) {
                  controller.recipe.value.setName(str);
                },
              ),
            ],
          ),

          //완성 이미지 업로드
          // -> 이미지 업로드시 아이콘이 변경되야함(현재 안됨)
          Column(
            children: [
              IconButton(
                constraints: BoxConstraints(),
                padding: EdgeInsets.zero,
                onPressed: () {
                  // getImageDialog(context);
                  Get.defaultDialog(
                    title: "이미지 가져오기",
                    content: IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () async {
                              //await controller.encodeImageFromCamera(99);
                              await controller.encodeRecipeImage(true);
                              // setState(() {
                              //   if (widget.controller.recipe.value.recipeImg !=
                              //       'Unknown') {
                              //     icon = Icon(
                              //       Icons.image_rounded,
                              //     );
                              //   }
                              // });
                              Navigator.pop(context);
                            },
                            iconSize: 100.0,
                            icon: Icon(Icons.camera_alt_rounded),
                          ),
                          VerticalDivider(
                            color: Colors.black45,
                          ),
                          IconButton(
                            onPressed: () async {
                              //controller.encodeImageFromGallery(99);
                              await controller.encodeRecipeImage(true);
                              // setState(() {
                              //   if (widget.controller.recipe.value.recipeImg !=
                              //       'Unknown') {
                              //     icon = Icon(
                              //       Icons.image_rounded,
                              //     );
                              //   }
                              // });
                              Navigator.pop(context);
                            },
                            iconSize: 100.0,
                            icon: Icon(Icons.image_rounded),
                          ),
                        ],
                      ),
                    ),
                    cancelTextColor: Colors.lightGreen,
                    actions: [
                      ElevatedButton(
                        style: buttonStyle,
                        onPressed: () => Navigator.pop(context),
                        child: Text("닫기"),
                      ),
                    ],
                  );
                },
                iconSize: 150.0,
                icon: Icon(Icons.image_outlined),
              ),
              Text('recipe_img'.tr),
            ],
          ),

          //레시피 칼로리, 나트륨
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              RecipeInfoInputWidget(
                hint: 'recipe_cal'.tr,
                onChanged: (str) {
                  controller.recipe.value.setEnergy(str);
                },
              ),
              RecipeInfoInputWidget(
                hint: 'recipe_nat'.tr,
                onChanged: (str) {
                  controller.recipe.value.setNat(str);
                },
              ),
            ],
          ),

          //탄수화물
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              RecipeInfoInputWidget(
                hint: 'recipe_car'.tr,
                onChanged: (str) {
                  controller.recipe.value.setCar(str);
                },
              ),
            ],
          ),

          //지방
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              RecipeInfoInputWidget(
                hint: 'recipe_fat'.tr,
                onChanged: (str) {
                  controller.recipe.value.setFat(str);
                },
              ),
            ],
          ),

          //단백질
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              RecipeInfoInputWidget(
                hint: 'recipe_pro'.tr,
                onChanged: (str) {
                  controller.recipe.value.setPro(str);
                },
              ),
            ],
          ),

          //다음 버튼
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: buttonStyle,
                  onPressed: () => controller.postpageController.jumpToPage(1),
                  child: Text('next'.tr),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RecipeInfoInputWidget extends StatelessWidget {
  const RecipeInfoInputWidget({Key? key, this.hint, required this.onChanged})
      : super(key: key);
  final hint;
  final void Function(String str) onChanged;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: TextField(
          cursorColor: Colors.lightGreen,
          decoration: InputDecoration(
            hintText: hint,
            border: outLineInputBorder,
            focusedBorder: outLineInputBorder,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 5.0,
              horizontal: 10.0,
            ),
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class RecipePost2 extends StatelessWidget {
  final controller = Get.find<RecipePostCtrl>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          flex: 10,
          child: Obx(
            () => ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: controller.recipe.manualList.length,
              itemBuilder: (BuildContext context, int index) {
                return ManualItemWidget(index: index);
              },
            ),
          ),
        ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: buttonStyle,
                onPressed: () {
                  if (controller.recipe.manualList.length < 20) {
                    controller.manualAdd();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("manual_full".tr),
                      duration: Duration(milliseconds: 1500),
                    ));
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    "manual_add".tr,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: buttonStyle,
                onPressed: () {
                  if (controller.recipe.manualList.length > 1) {
                    controller.manualSub();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("manual_empty".tr),
                      duration: Duration(milliseconds: 1500),
                    ));
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    "manual_sub".tr,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
            Spacer(),
          ],
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: buttonStyle,
                onPressed: () => controller.postpageController.jumpToPage(0),
                child: Text('prev'.tr),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: buttonStyle,
                onPressed: () async {
                  //레시피 등록 절차 수행
                  // bool isComplete = await controller.recipePosting();
                  bool goToHome = false;

                  // if (isComplete) {
                  //   goToHome = await showDialog(
                  //       context: context,
                  //       builder: (BuildContext context) {
                  //         return AlertDialog(
                  //           title: Text("알림"),
                  //           content: Text("레시피 등록이 완료되었습니다."),
                  //           actions: [
                  //             ElevatedButton(
                  //               onPressed: () => Get.back(result: true),
                  //               child: Text("닫기"),
                  //             ),
                  //           ],
                  //         );
                  //       });
                  // } else {
                  //   goToHome = await showDialog(
                  //       context: context,
                  //       builder: (BuildContext context) {
                  //         return AlertDialog(
                  //           title: Text("알림"),
                  //           content: Text("레시피 등록이 실패하였습니다.\n 관리자에게 문의해주세요."),
                  //           actions: [
                  //             ElevatedButton(
                  //               onPressed: () => Get.back(result: true),
                  //               //onPressed: () => Navigator.pop(context, true),
                  //               child: Text("닫기"),
                  //             ),
                  //           ],
                  //         );
                  //       });
                  // }

                  if (goToHome) {
                    controller.manualItemList.clear();
                    Get.back(result: true);
                  }
                },
                child: Text('post'.tr),
              ),
            ),
          ],
        ),
        Spacer(flex: 2),
      ],
    );
  }
}

class ManualItemWidget extends StatelessWidget {
  ManualItemWidget({Key? key, this.index}) : super(key: key);
  final controller = Get.find<RecipePostCtrl>();
  final index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(
          flex: 5,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: TextField(
              cursorColor: Colors.lightGreen,
              decoration: InputDecoration(
                hintText: "manual_item_hint".tr,
                border: outLineInputBorder,
                focusedBorder: outLineInputBorder,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 5.0,
                  horizontal: 10.0,
                ),
              ),
              onChanged: (str) => controller.recipe.manualList[index] = str,
            ),
          ),
        ),

        //사진 등록 시 아이콘이 변경되지 않음.
        //위젯이 새로고침 안됨
        Expanded(
            flex: 2,
            child: IconButton(
              onPressed: () => Get.defaultDialog(
                title: "이미지 가져오기",
                content: IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () async {
                          await controller.encodeRecipeImage(true);
                          Navigator.pop(context);
                        },
                        iconSize: 100.0,
                        icon: Icon(Icons.camera_alt_rounded),
                      ),
                      VerticalDivider(
                        color: Colors.black45,
                      ),
                      IconButton(
                        onPressed: () async {
                          await controller.encodeRecipeImage(true);
                          Navigator.pop(context);
                        },
                        iconSize: 100.0,
                        icon: Icon(Icons.image_rounded),
                      ),
                    ],
                  ),
                ),
                cancelTextColor: Colors.lightGreen,
                actions: [
                  ElevatedButton(
                    style: buttonStyle,
                    onPressed: () => Navigator.pop(context),
                    child: Text("닫기"),
                  ),
                ],
              ),
              iconSize: 75.0,
              icon: Icon(Icons.image_outlined),
            )),
      ],
    );
  }
}
