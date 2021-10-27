import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
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
          Get.to(() => RecipePost());
        })
      ],
    );
  }
}


class RecipePost extends StatelessWidget {
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
                      onChanged: (str){
                        controller.recipe.value.setName(str);
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
                onPressed: (){
                  getImageDialog(context);
                },
                iconSize: 150.0,
                icon: (controller.recipe.value.recipeImg == null) ? Icon(Icons.image_outlined) : Icon(Icons.image_rounded),
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
                        controller.recipe.value.setEnergy(str);
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
                        controller.recipe.value.setNa(str);
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
                        controller.recipe.value.setCal(str);
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
                        controller.recipe.value.setFat(str);
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
                        controller.recipe.value.setPro(str);
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
                  Logger().d("Name : ${controller.recipe.value.name}");
                  Logger().d("Energy : ${controller.recipe.value.energy}");

                  Get.to(() => RecipePost2());
                },
                child: Text("다음"),
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
                    ImagePicker picker = ImagePicker();
                    controller.recipe.value.recipeImg = await picker.pickImage(source: ImageSource.camera);
                    Navigator.pop(context);
                  },
                  iconSize: 100.0,
                  icon: Icon(Icons.camera_alt_rounded),),
                ),

                VerticalDivider(color: Colors.black45,),

                Expanded(child: IconButton(
                  onPressed: () async {
                    ImagePicker picker = ImagePicker();
                    controller.recipe.value.recipeImg = await picker.pickImage(source: ImageSource.gallery);
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


/*
class RecipePost extends StatefulWidget {

  @override
  _RecipePostState createState() => _RecipePostState();
}

class _RecipePostState extends State<RecipePost> {
  final controller = Get.put(APIController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller.recipe.value = new Recipe();
  }

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
                      controller.recipe.value.setName(str);
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
                onPressed: (){},
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
                    onChanged: (str){
                      controller.recipe.value.setEnergy(str);
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
                      controller.recipe.value.setNa(str);
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
                      controller.recipe.value.setCal(str);
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
                      controller.recipe.value.setFat(str);
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
                      controller.recipe.value.setPro(str);
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
                  Logger().d("Name : ${controller.recipe.value.name}");
                  Logger().d("Energy : ${controller.recipe.value.energy}");

                  Get.to(() => RecipePost2());
                },
                child: Text("다음"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /*
  void getRecipeFailDialog(){
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text("경고"),
        content: Text("레시피 정보가 올바르지 않습니다."),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text("닫기"),
          )
        ],
      );
    });
  }
   */
}
*/

class RecipePost2 extends StatefulWidget {
  @override
  _RecipePost2State createState() => _RecipePost2State();
}

class _RecipePost2State extends State<RecipePost2> {
  final controller = Get.put(APIController());

  List<ManualItem> manualList = [];
  List<XFile> imageList = [];

  _RecipePost2State();

  @override
  Widget build(BuildContext context) {
    manualList.add(ManualItem(index: 0, manual: controller.recipe.value.manualList![0], image: controller.recipe.value.imageList![0]));
    manualList.add(ManualItem(index: 1, manual: controller.recipe.value.manualList![1], image: controller.recipe.value.imageList![1]));

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
                          manualList.add(ManualItem(index: manualList.length, manual: controller.recipe.value.manualList![manualList.length], image: controller.recipe.value.imageList![manualList.length]));
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

                //레시피 등록 절차 수행
                controller.recipePosting(controller.recipe.value, manualList);
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
