
import 'package:flutter/material.dart';

Widget circularImageLoader(BuildContext context, Widget widget, ImageChunkEvent? event){
    if (event != null) {
      return  Center(
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.black),
            value: event.cumulativeBytesLoaded / event.expectedTotalBytes!
        ),
      );
    } else    return widget;
 return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.black),
    );
  }


