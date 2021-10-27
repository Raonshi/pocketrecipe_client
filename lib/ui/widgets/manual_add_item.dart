import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:pocketrecipe_client/getx/controller.dart';
import 'package:get/get.dart';


/*
class ManualItem extends StatefulWidget {
  int index = 0;
  ManualItem({Key? key, required index}) : super(key: key);

  @override
  _ManualItemState createState() => _ManualItemState(index: index);
}

class _ManualItemState extends State<ManualItem> {
  TextEditingController controller = TextEditingController();
  final getController = Get.put(APIController());

  dynamic uploadImage;
  Icon icon = Icon(Icons.image_outlined, size: 50.0,);

  _ManualItemState({required index});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: TextField(
                decoration: InputDecoration(
                    hintText: "메뉴얼 설명(100자 이내)",
                    border: OutlineInputBorder()
                ),
                controller: controller,
                onChanged: (str){
                  controller..text = str
                    ..selection = TextSelection.collapsed(offset: controller.text.length);
                }
            ),
          ),
        ),

        Expanded(
          flex: 1,
          child: IconButton(
            onPressed: (){
              Logger().d("이미지 업로드");
              getImageDialog(context, getController);
            },
            icon: icon,
          ),
        ),
      ],
    );
  }

  void getImageDialog(BuildContext context, APIController controller){
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
                    uploadImage = await picker.pickImage(source: ImageSource.camera);

                    setState(() {
                      if(uploadImage != null){
                        icon = Icon(Icons.image_rounded, size: 50.0,);
                      }
                      else{
                        icon = Icon(Icons.image_outlined, size: 50.0,);
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
                    ImagePicker picker = ImagePicker();
                    uploadImage = await picker.pickImage(source: ImageSource.gallery);

                    setState(() {
                      if(uploadImage != null){
                        icon = Icon(Icons.image_rounded, size: 50.0,);
                      }
                      else{
                        icon = Icon(Icons.image_outlined, size: 50.0,);
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
*/




class ManualItem extends StatelessWidget {
  int index = 0;
  TextEditingController controller = TextEditingController();
  final getController = Get.put(APIController());
  String manual = "";
  XFile? image;

  dynamic uploadImage;

  ManualItem({Key? key, required index, manual, image}) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: TextField(
                decoration: InputDecoration(
                    hintText: "메뉴얼 설명(100자 이내)",
                    border: OutlineInputBorder()
                ),
                controller: controller,
                onChanged: (str){
                  controller..text = str
                    ..selection = TextSelection.collapsed(offset: controller.text.length);

                  manual = controller.text;
                }
            ),
          ),
        ),

        InkWell(
          onTap: (){
            Logger().d("이미지 업로드");
            getImageDialog(context, getController);
          },
          child: imageButtonIcon(),
        ),
      ],
    );
  }

  Widget imageButtonIcon(){
    if(uploadImage != null){
      return Image(image: uploadImage);
    }
    else{
      return Icon(Icons.image_rounded, size: 75.0,);
    }
  }

  void getImageDialog(BuildContext context, APIController controller){
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
                    uploadImage = await picker.pickImage(source: ImageSource.camera);

                    image = uploadImage;

                    Navigator.pop(context);
                  },
                  iconSize: 100.0,
                  icon: Icon(Icons.camera_alt_rounded),),
                ),

                VerticalDivider(color: Colors.black45,),

                Expanded(child: IconButton(
                  onPressed: () async {
                    ImagePicker picker = ImagePicker();
                    uploadImage = await picker.pickImage(source: ImageSource.gallery);

                    image = uploadImage;

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
