import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocketrecipe_client/getx/controller.dart';


class RecipePost1 extends StatefulWidget {
  final controller = Get.put(Controller());

  @override
  _RecipePost1State createState() => _RecipePost1State();
}

class _RecipePost1State extends State<RecipePost1> {
  Icon icon = Icon(Icons.image_outlined,);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("레시피 등록"),
      ),
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          //레시피 이름
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  child: TextField(
                      decoration: InputDecoration(
                          hintText: "레시피 이름",
                          border: OutlineInputBorder()
                      ),
                      onChanged: (str){
                        widget.controller.recipe.value.setName(str);
                      }
                  ),
                ),
              )
            ],
          ),

          //완성 이미지 업로드
          // -> 이미지 업로드시 아이콘이 변경되야함(현재 안됨)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              IconButton(
                onPressed: (){
                  getImageDialog(context);
                },
                iconSize: 150.0,
                icon: icon,
                tooltip: "이미지 업로드",
              ),
            ],
          ),

          //레시피 칼로리, 나트륨
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  child: TextField(
                      decoration: InputDecoration(
                          hintText: "칼로리(kcal)",
                          border: OutlineInputBorder()
                      ),
                      onChanged: (str){
                        widget.controller.recipe.value.setEnergy(str);
                      }
                  ),
                ),
              ),

              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  child: TextField(
                      decoration: InputDecoration(
                          hintText: "나트륨(mg)",
                          border: OutlineInputBorder()
                      ),
                      onChanged: (str){
                        widget.controller.recipe.value.setNa(str);
                      }
                  ),
                ),
              ),
            ],
          ),

          //탄수화물
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  child: TextField(
                      decoration: InputDecoration(
                          hintText: "탄수화물(g)",
                          border: OutlineInputBorder()
                      ),
                      onChanged: (str){
                        widget.controller.recipe.value.setCal(str);
                      }
                  ),
                ),
              )
            ],
          ),

          //지방
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  child: TextField(
                      decoration: InputDecoration(
                          hintText: "지방(g)",
                          border: OutlineInputBorder()
                      ),
                      onChanged: (str){
                        widget.controller.recipe.value.setFat(str);
                      }
                  ),
                ),
              )
            ],
          ),

          //단백질
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  child: TextField(
                      decoration: InputDecoration(
                          hintText: "단백질(g)",
                          border: OutlineInputBorder()
                      ),
                      onChanged: (str){
                        widget.controller.recipe.value.setPro(str);
                      }
                  ),
                ),
              )
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
                  onPressed: () async {
                    bool goToHome = await Get.to(() => RecipePost2());
                    if(goToHome){Get.back(result: true);}
                  },
                  child: Text("다음"),
                ),
              ),
            ],
          ),
        ],
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
                    //await controller.encodeImageFromCamera(99);
                    await widget.controller.encodeRecipeImage(true);
                    setState(() {
                      if(widget.controller.recipe.value.recipeImg != 'Unknown'){
                        icon = Icon(Icons.image_rounded,);
                      }
                    });
                    Navigator.pop(context);
                  },
                  iconSize: 100.0,
                  icon: Icon(Icons.camera_alt_rounded),),
                ),

                VerticalDivider(color: Colors.black45,),

                Expanded(child: IconButton(
                  onPressed: () async {
                    //controller.encodeImageFromGallery(99);
                    await widget.controller.encodeRecipeImage(true);
                    setState(() {
                      if(widget.controller.recipe.value.recipeImg != 'Unknown'){
                        icon = Icon(Icons.image_rounded,);
                      }
                    });
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
}


class RecipePost2 extends StatelessWidget {
  final controller = Get.put(Controller());

  @override
  Widget build(BuildContext context) {
    controller.manualAdd();
    controller.manualAdd();

    return Scaffold(
      appBar: AppBar(title: Text("레시피 등록"),),
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 14,
            child: Obx(() => ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: controller.manualList.length,
                itemBuilder: (BuildContext context, int index) {
                  return controller.manualList[index];
                }),
            ),
          ),

          Divider(),

          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Spacer(),

                Expanded(
                  flex: 4,
                  child: ElevatedButton(
                    onPressed: (){
                      if(controller.manualList.length < 20){
                        controller.manualAdd();
                      }
                      else{
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("더 이상 추가할 수 없습니다."),
                              duration: Duration(milliseconds: 1500),
                            )
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text("메뉴얼 추가", style: TextStyle(fontSize: 20),),
                    ),
                  ),
                ),

                Spacer(),

                Expanded(
                  flex: 4,
                  child: ElevatedButton(
                    onPressed: (){
                      if(controller.manualList.length > 1){
                        controller.manualSub();
                      }
                      else{
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("더 이상 삭제할 수 없습니다."),
                              duration: Duration(milliseconds: 1500),
                            )
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text("메뉴얼 삭제", style: TextStyle(fontSize: 20),),
                    ),
                  ),
                ),

                Spacer(),
              ],
            ),
          ),

          Spacer(),

          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () async{
                //레시피 등록 절차 수행
                bool isComplete = await controller.recipePosting();
                bool goToHome = false;

                if(isComplete){
                  goToHome = await showDialog(context: context, builder: (BuildContext context){
                    return AlertDialog(
                      title: Text("알림"),
                      content: Text("레시피 등록이 완료되었습니다."),
                      actions: [
                        ElevatedButton(
                          onPressed: () => Get.back(result: true),
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
                      content: Text("레시피 등록이 실패하였습니다.\n 관리자에게 문의해주세요."),
                      actions: [
                        ElevatedButton(
                          onPressed: () => Get.back(result: true),
                          //onPressed: () => Navigator.pop(context, true),
                          child: Text("닫기"),
                        ),
                      ],
                    );
                  });
                }

                if(goToHome){
                  controller.manualList.clear();
                  Get.back(result: true);
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
                child: Text("등록", style: TextStyle(fontSize: 20),),
              ),
            ),
          ),

          Spacer(),
        ],
      ),
    );
  }
}

