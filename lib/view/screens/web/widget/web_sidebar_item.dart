
import 'package:flutter_svg/flutter_svg.dart';
import 'package:knaw_news/mixin/auth_mixin.dart';
import 'package:knaw_news/util/dimensions.dart';
import 'package:knaw_news/util/styles.dart';
import 'package:flutter/material.dart';



class WebSideBarItem extends StatelessWidget {

  String icon;
  String title;
  bool isLogout;
  void Function() onTap;

  WebSideBarItem({required this.icon,required this.title,this.isLogout=false,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SvgPicture.asset(
            icon,
            width: 20,
            color: Colors.black
        ),
      ),
      title: Text(
        title,
        style: openSansBold.copyWith(fontSize:Dimensions.fontSizeSmall,color: Colors.black),
      ),
      onTap: onTap,
    );
  }
}

