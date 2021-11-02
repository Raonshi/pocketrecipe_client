import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pocketrecipe_client/getx/controller.dart';


class RecipeDelete extends StatefulWidget {
  const RecipeDelete({Key? key}) : super(key: key);

  @override
  _RecipeDeleteState createState() => _RecipeDeleteState();
}

class _RecipeDeleteState extends State<RecipeDelete> {
  final controller = Get.put(Controller());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.recipeList.value.clear();
    controller.getRecipeByDatabase(keyword: "SHOW_MY_RECIPE");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onBackButtonPressed(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text("레시피 등록"),
        ),
        resizeToAvoidBottomInset: false,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Spacer(),

            //레시피 게시글 피드
            Expanded(
              flex:12,
              child: Obx(() => ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: controller.recipeList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: Checkbox(
                        value: controller.recipeList.value[index].isDelete,
                        onChanged: (check){
                          setState(() {
                            controller.recipeList.value[index].isDelete = check!;
                          });
                        },
                      ),
                      title: Text(controller.recipeList.value[index].name),
                    );
                  }),),
            ),

            Spacer(),

            //다음 버튼
            Expanded(
              flex: 1,
              child: ElevatedButton(
                onPressed: () async {
                  bool isComplete = await controller.deleteRecipe();
                  bool goToHome = false;
                  if(isComplete){
                    goToHome = await showDialog(context: context, builder: (BuildContext context){
                      return AlertDialog(
                        title: Text("알림"),
                        content: Text("레시피 삭제가 완료되었습니다."),
                        actions: [
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: Text("닫기"),
                          ),
                        ],
                      );
                    });
                  }
                  else{
                    goToHome = await showDialog(context: context, builder: (BuildContext context){
                      return AlertDialog(
                        title: Text("알림"),
                        content: Text("레시피 삭제가 실패하였습니다.\n 관리자에게 문의해주세요."),
                        actions: [
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: Text("닫기"),
                          ),
                        ],
                      );
                    });
                  }

                  if(goToHome){Get.back(result: true);}

                },
                child: Text("삭제", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              ),
            ),

            Spacer(),

          ],
        ),
      ),
    );
  }

  void getImageDialog(BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text("이미지 가져오기"),
          content: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: IconButton(
                  onPressed: () async {
                    controller.encodeImageFromCamera();
                    Navigator.pop(context);
                  },
                  iconSize: 100.0,
                  icon: Icon(Icons.camera_alt_rounded),),
                ),

                VerticalDivider(color: Colors.black45,),

                Expanded(child: IconButton(
                  onPressed: () async {
                    controller.encodeImageFromGallery();
                    Navigator.pop(context);
                  },
                  iconSize: 100.0,
                  icon: Icon(Icons.image_rounded),),
                ),
              ],
            ),
          ),

          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text("닫기"),
            ),
          ],
        );
      },
    );
  }

  Future<bool> onBackButtonPressed(BuildContext context) async {
    Navigator.pop(context);
    return true;
  }
}
