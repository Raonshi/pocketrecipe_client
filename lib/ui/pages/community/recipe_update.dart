import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocketrecipe_client/getx/controller.dart';
import 'package:pocketrecipe_client/ui/widgets/manual_add_item.dart';
import 'package:pocketrecipe_client/data_define.dart';

class RecipeUpdate extends StatefulWidget {
  const RecipeUpdate({Key? key}) : super(key: key);

  @override
  _RecipeUpdateState createState() => _RecipeUpdateState();
}


class _RecipeUpdateState extends State<RecipeUpdate> {
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
          title: Text("레시피 수정"),
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
                    return Card(
                      shadowColor: Colors.black87,
                      child: ListTile(
                        leading: Checkbox(
                          value: controller.recipeList.value[index].isUpdate,
                          onChanged: (check){
                            setState(() {
                              //먼저 전부 초기화
                              for(int i = 0; i < controller.recipeList.length; i++){
                                controller.recipeList.value[i].isUpdate = false;
                              }
                              //선택한 레시피만 체크표시
                              controller.recipeList.value[index].isUpdate = check!;
                              controller.recipe.value = controller.recipeList.value[index];
                            });
                          },
                        ),
                        title: Text(controller.recipeList.value[index].name),
                      ),
                    );
                  }),),
            ),

            Spacer(),

            //수정 버튼
            Expanded(
              flex: 1,
              child: ElevatedButton(
                onPressed: () async {
                  bool isComplete = await Get.to(RecipeUpdate1());

                  bool goToHome = false;
                  if(isComplete){
                    goToHome = await showDialog(context: context, builder: (BuildContext context){
                      return AlertDialog(
                        title: Text("알림"),
                        content: Text("레시피 수정이 완료되었습니다."),
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
                        content: Text("레시피 수정이 실패하였습니다.\n 관리자에게 문의해주세요."),
                        actions: [
                          ElevatedButton(
                            onPressed: () => Get.back(result: true),
                            child: Text("닫기"),
                          ),
                        ],
                      );
                    });
                  }

                  if(goToHome){Get.back(result: true);}

                },
                child: Text("수정", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              ),
            ),

            Spacer(),

          ],
        ),
      ),
    );
  }


  Future<bool> onBackButtonPressed(BuildContext context) async {
    Navigator.pop(context);
    return true;
  }
}


class RecipeUpdate1 extends StatefulWidget {
  final controller = Get.put(Controller());

  @override
  _RecipeUpdate1State createState() => _RecipeUpdate1State();
}

class _RecipeUpdate1State extends State<RecipeUpdate1> {
  Icon icon = Icon(Icons.image_rounded,);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("레시피 수"),
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
                  child: TextFormField(
                    initialValue: widget.controller.recipe.value.name,
                    decoration: InputDecoration(
                        hintText: "레시피 이름",
                        border: OutlineInputBorder()
                    ),
                    onChanged: (str){
                      widget.controller.recipe.value.setName(str);
                    },
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
                  child: TextFormField(
                      initialValue: widget.controller.recipe.value.energy,
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
                  child: TextFormField(
                      initialValue: widget.controller.recipe.value.natrium,
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
                  child: TextFormField(
                      initialValue: widget.controller.recipe.value.carbohydrate,
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
                  child: TextFormField(
                      initialValue: widget.controller.recipe.value.fat,
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
                  child: TextFormField(
                      initialValue: widget.controller.recipe.value.protein,
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
                    bool goToHome = await Get.to(() => RecipeUpdate2());
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


class RecipeUpdate2 extends StatelessWidget {
  final controller = Get.put(Controller());

  @override
  Widget build(BuildContext context) {
    Recipe recipe = controller.recipe.value;
    List<ManualItem> list = [];
    for(int i = 0; i < recipe.manualList.length; i++){
      ManualItem item = ManualItem();
      item.manual = recipe.manualList[i];
      item.imageBase64 = 'Unknown';
      list.add(item);
    }
    controller.manualList.value = list;


    return Scaffold(
      appBar: AppBar(title: Text("레시피 수정"),),
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

                if(goToHome){Get.back(result: true);}
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



