import 'package:flutter/material.dart';

Widget notificationButton(int badgeCount){

  return SizedBox(
        width: 20,
        height: 20,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.amber,
            padding: EdgeInsets.zero,
          ),
          onPressed: () {},
          child: Text(badgeCount.toString(), style: TextStyle(color: Colors.white, fontSize: 10),
          ),
        ),
      );
}