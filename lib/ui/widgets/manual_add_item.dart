import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:pocketrecipe_client/getx/controller.dart';
import 'package:get/get.dart';


class ManualItem extends StatefulWidget {
  int index = 0;
  String manual ='';
  String imageBase64 = 'Unknown';

  final controller = Get.put(Controller());
  ManualItem({this.index=0});

  @override
  _ManualItemState createState() => _ManualItemState();
}

class _ManualItemState extends State<ManualItem> {
  Icon icon = Icon(Icons.image_outlined,);
  //dynamic uploadImage;
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: TextField(
                decoration: InputDecoration(
                    hintText: "메뉴얼 설명(100자 이내)",
                    border: OutlineInputBorder()
                ),
                controller: textController,
                onChanged: (str) {
                  widget.manual = str;
                }
            ),
          ),
        ),

        //사진 등록 시 아이콘이 변경되지 않음.
        //위젯이 새로고침 안됨
        Expanded(
            flex: 2,
            child: IconButton(
              onPressed: () => getImageDialog(context, widget.controller),
              iconSize: 75.0,
              icon: icon,
            )
        ),
      ],
    );
  }

  void getImageDialog(BuildContext context, Controller controller){
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
                    //await controller.encodeImageFromCamera(widget.index);
                    widget.imageBase64 = await widget.controller.encodeManualImage(true);
                    setState(() {
                      icon = Icon(Icons.image_rounded,);
                    });
                    Navigator.pop(context);
                  },
                  iconSize: 100.0,
                  icon: Icon(Icons.camera_alt_rounded),),
                ),

                VerticalDivider(color: Colors.black45,),

                Expanded(child: IconButton(
                  onPressed: () async {
                    //await controller.encodeImageFromGallery(widget.index);
                    widget.imageBase64 = await widget.controller.encodeManualImage(false);
                    setState(() {
                      icon = Icon(Icons.image_rounded,);
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



/*
class ManualItem extends StatelessWidget {
  int index = 0;
  TextEditingController controller = TextEditingController();
  final getController = Get.put(Controller());
  String manual = "";
  XFile? image = null;

  dynamic uploadImage;

  ManualItem({Key? key, required index}) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: TextField(
                decoration: InputDecoration(
                    hintText: "메뉴얼 설명(100자 이내)",
                    border: OutlineInputBorder()
                ),
                controller: controller,
                onChanged: (str) {
                  manual = str;
                }
            ),
          ),
        ),

        //사진 등록 시 아이콘이 변경되지 않음.
        //위젯이 새로고침 안됨
        Expanded(
          flex: 2,
          child: IconButton(
            onPressed: () => getImageDialog(context, getController),
            iconSize: 75.0,
            icon: (image != null) ? Icon(Icons.image_rounded,) : Icon(Icons.image_outlined,),
          )
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

  void getImageDialog(BuildContext context, Controller controller){
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
                    controller.encodeImageFromCamera(index);
                    Navigator.pop(context);
                  },
                  iconSize: 100.0,
                  icon: Icon(Icons.camera_alt_rounded),),
                ),

                VerticalDivider(color: Colors.black45,),

                Expanded(child: IconButton(
                  onPressed: () async {
                    controller.encodeImageFromGallery(index);
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