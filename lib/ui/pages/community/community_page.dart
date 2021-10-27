import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pocketrecipe_client/getx/controller.dart';
import 'package:pocketrecipe_client/ui/widgets/manual_add_item.dart';
import 'package:pocketrecipe_client/ui/widgets/recipe_item.dart';


class CommunityPage extends StatelessWidget {
  final controller = Get.put(APIController());

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //레시피 게시글 피드
        Expanded(
          flex:8,
          child: Obx(() => ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: controller.recipeList.length,
              itemBuilder: (BuildContext context, int index) {
                return RecipeItem(controller.recipeList[index]);
              }),),
        ),

        //글쓰기 버튼
        FloatingActionButton(child: Icon(Icons.add_rounded), onPressed: (){
          Get.to(RecipePost());
        })
      ],
    );
  }
}

class RecipePost extends StatefulWidget {
  const RecipePost({Key? key}) : super(key: key);

  @override
  _RecipePostState createState() => _RecipePostState();
}

class _RecipePostState extends State<RecipePost> {
  List<TextEditingController> controllerList = [TextEditingController(), TextEditingController(), TextEditingController(), TextEditingController(), TextEditingController(), TextEditingController()];

  final controller = Get.put(APIController());

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
                    controller: controllerList[0],
                    onChanged: (str){
                      controllerList[0]..text = str
                          ..selection = TextSelection.collapsed(offset: controllerList[0].text.length);
                    }
                  ),
                ),
              )
            ],
          ),

          //완성 이미지 업로드
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              IconButton(
                onPressed: takePhoto,
                iconSize: 150.0,
                icon: Icon(Icons.image_rounded),
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
                    controller: controllerList[1],
                    onChanged: (str){
                      controllerList[1]..text = str
                        ..selection = TextSelection.collapsed(offset: controllerList[1].text.length);
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
                    controller: controllerList[2],
                    onChanged: (str){
                      controllerList[2]..text = str
                        ..selection = TextSelection.collapsed(offset: controllerList[2].text.length);
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
                    controller: controllerList[3],
                    onChanged: (str){
                      controllerList[3]..text = str
                        ..selection = TextSelection.collapsed(offset: controllerList[3].text.length);
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
                    controller: controllerList[4],
                    onChanged: (str){
                      controllerList[4]..text = str
                        ..selection = TextSelection.collapsed(offset: controllerList[4].text.length);
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
                    controller: controllerList[5],
                    onChanged: (str){
                      controllerList[5]..text = str
                        ..selection = TextSelection.collapsed(offset: controllerList[5].text.length);
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
              ElevatedButton(
                onPressed: (){
                  controller.recipe = Recipe(
                    name: controllerList[0].text,
                    energy: controllerList[1].text,
                    natrium: controllerList[2].text,
                    carbohydrate: controllerList[3].text,
                    protein: controllerList[4].text,
                    fat: controllerList[5].text,
                  ).obs;

                  Get.to(RecipePost2());
                },
                child: Text("다음"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //사진 촬영
  void takePhoto(){
    //다이얼로그 출력
    //1. 사진 촬영
    //2. 앨범에서 가져오기
  }
}


class RecipePost2 extends StatefulWidget {
  const RecipePost2({Key? key}) : super(key: key);

  @override
  _RecipePost2State createState() => _RecipePost2State();
}

class _RecipePost2State extends State<RecipePost2> {
  final controller = Get.put(APIController());
  dynamic recipe = Get.arguments;
  List<ManualItem> manualList = [ManualItem(index: 0,), ManualItem(index: 1)];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("레시피 등록"),),
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [

          //에러 발생함
          //배열 길이가 0으로 인식됨
          Expanded(
            flex: 14,
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: manualList.length,
                itemBuilder: (BuildContext context, int index) {
                  return manualList[index];
                }),
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
                      if(manualList.length < 20){
                        setState(() {
                          manualList.add(new ManualItem(index: manualList.length,));
                        });
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
                      if(manualList.length > 1){
                        setState(() {
                          manualList.removeAt(manualList.length-1);
                        });
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
              onPressed: (){
                Logger().d("등록");

                Logger().d(controller.imageFileList.first);
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
