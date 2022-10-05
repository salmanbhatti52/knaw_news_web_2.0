
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EventCommentTextField extends StatelessWidget {
 final TextEditingController? controller;
 final void Function(String)? onChanged;
 final void Function(String)? onSubmitted;
 final  void Function()? onTapIcon;
 final  void Function()? onTapEmoji;
 final  void Function()? onTap;
 bool isReply;
 final  bool autoFocus;
  FocusNode? focusNode;
   EventCommentTextField({Key? key,this.isReply=false,this.onTap,this.autoFocus=false,this.controller,this.onChanged,this.onSubmitted,this.focusNode,this.onTapIcon,this.onTapEmoji,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 90,
        padding: EdgeInsets.only(top:13,bottom: 10),
        decoration: BoxDecoration(
          color: Color(0xfff6f6f6),
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10.0,left: 15,right: 15),
          child: Row(
            children: [
              // Container(
              //     padding: EdgeInsets.all(12),
              //     height:48,
              //     width: 50,
              //     decoration: BoxDecoration(
              //         color: Colors.grey.withOpacity(0.2),
              //         borderRadius: BorderRadius.circular(10)
              //     ),
              //     child: SvgPicture.asset('assets/image/attachment.svg')
              // ),
              // SizedBox(width: 8,),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: TextFormField(
                    onFieldSubmitted: onSubmitted,
                    textCapitalization: TextCapitalization.sentences,
                    autofocus: autoFocus,
                    controller: controller,
                    focusNode: focusNode,
                    onChanged: onChanged,
                    onTap: onTap,
                    style: TextStyle(color: Colors.black, fontSize: 12, height: 2),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.2),
                      hintText:isReply ?'Type your Reply here....' :  'Type Message here',
                      hintStyle: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 12, height: 2,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8,),
              InkWell(
                onTap: onTapIcon,
                child: Container(
                  padding: EdgeInsets.all(12),
                  height:48,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.amber,
                  borderRadius: BorderRadius.circular(10)
                  ),
                  child: SvgPicture.asset('assets/image/sendicon.svg')
                  ),
              ),
              
            ],
          ),
        ),
      ),

      ],
    );
  }


}
