import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:knaw_news/mixin/data.dart';
import 'package:knaw_news/services/dio_service.dart';
import 'package:knaw_news/util/images.dart';
import 'package:knaw_news/util/styles.dart';
import 'package:knaw_news/view/base/custom-navigator.dart';
import 'package:knaw_news/view/base/loading_dialog.dart';
import 'package:knaw_news/view/base/notification-button.dart';
import 'package:knaw_news/view/base/profile-image-picker.dart';
import 'package:knaw_news/view/base/web_menu_bar.dart';
import 'package:knaw_news/view/screens/dashboard/widget/bottom_nav_item.dart';
import 'package:knaw_news/view/screens/home/home.dart';
import 'package:knaw_news/view/screens/menu/drawer.dart';
import 'package:knaw_news/view/screens/messeges/chat-model.dart';
import 'package:knaw_news/view/screens/messeges/messageDetailsPage.dart';
import 'package:knaw_news/view/screens/post/create_post_screen.dart';
import 'package:knaw_news/view/screens/profile/profile_screen.dart';
import 'package:knaw_news/view/screens/search/search_screen.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {

  List<GetAllChats> chatsDetail=[];
  Timer? timer;

  ScrollController _controller= ScrollController();


  Future getChat() async {
    try{
      var response = await DioService.post('chat', {
        "userId" : AppData().userdetail!.usersId,
        "requestType" : "getChatList"
      });
      var chats= response['data'] as List;
      chatsDetail =    chats.map<GetAllChats>((e) =>  GetAllChats.fromJson(e)).toList();
      print(chatsDetail.toList());
      setState(() {});
    }
    catch(e){
      // Navigator.of(context).pop();
      // showSuccessToast(e.toString());
    }
  }

  Future getChatList() async {
    try{
      var response = await DioService.post('chat', {
        "userId" : AppData().userdetail!.usersId,
        "requestType" : "getChatList"
      });
      var chats= response['data'] as List;
      chatsDetail =    chats.map<GetAllChats>((e) =>  GetAllChats.fromJson(e)).toList();
      // print(chatsDetail.toList());
      print("-----------------------------a");
      print(response);
      Navigator.of(context).pop();
      setState(() {});
    }
    catch(e){
      Navigator.of(context).pop();
      // showSuccessToast(e.toString());
    }
  }



  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) =>  getChat());
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      openLoadingDialog(context, "loading...");
      getChatList();
    });
  }


  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    double mediaWidth=size.width<1000?size.width:size.width*0.7;
    return Scaffold(
      drawer: new MyDrawer(),
      appBar: WebMenuBar(context: context,isAuthenticated: true,),
      body: Center(
        child: Container(
          width: mediaWidth,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(color: Colors.white),
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: chatsDetail.length,
                    shrinkWrap: true,
                    controller: _controller,
                    itemBuilder: (context,index){
                      GetAllChats chat=chatsDetail[index];
                      return InkWell(
                        onTap: () {
                          CustomNavigator.navigateTo(context, MessageDetailsPage(
                            otherUserChatId: chat.user_id,
                            userName: chat.name!,
                            profilePic: chat.profile_pic!,
                          ));
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 55,
                                    height: 55,
                                    child: ProfileImagePicker(
                                      onImagePicked: (value){},
                                      previousImage: chat.profile_pic?? "",
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical:10),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(chat.name!, style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold,)),
                                          // SizedBox(height: 10),
                                          Text(chat.message!, style: TextStyle(color:  Colors.black, fontSize: 12, fontWeight: FontWeight.w400, height: 1.5,
                                          ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Column(
                                    children: [
                                      Text(chat.time!, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                                      SizedBox(height: 20),
                                      if(chat.badge!=0)
                                        notificationButton(chat.badge!)
                                    ],
                                  )
                                ],
                              ),
                              Divider(color:  Colors.grey),
                            ],
                          ),
                        ),
                      );
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
