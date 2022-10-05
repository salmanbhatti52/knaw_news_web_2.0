import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:knaw_news/util/dimensions.dart';
import 'package:knaw_news/util/images.dart';
import 'package:knaw_news/util/styles.dart';
import 'package:knaw_news/view/screens/dashboard/dashboard_screen.dart';

class AppBarWithBack extends StatelessWidget implements PreferredSizeWidget {

  String title;
  String? suffix;
  bool isTitle;
  bool isSuffix;
  void Function()? suffixTap;
  AppBarWithBack({required this.title,this.suffix,this.isTitle=false,this.isSuffix=true,this.suffixTap});

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    double mediaWidth =size.width<1000?size.width:size.width*0.5;
    const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarColor: Colors.white
    );
    return Center(
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        color: Colors.white,
        width: mediaWidth,
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back,size: 20,)
            ),
            Text(title,style: TextStyle(fontSize: 24,color: Colors.black,fontWeight: FontWeight.bold),),
            SizedBox(),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(Dimensions.WEB_MAX_WIDTH,  60);
}
