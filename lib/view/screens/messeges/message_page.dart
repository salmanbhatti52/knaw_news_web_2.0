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

import '../../../util/dimensions.dart';
import '../home/web_initial_screen.dart';
import '../web/widget/help.dart';
import '../web/widget/web_sidebar.dart';

class MessagePage extends StatefulWidget {
  final  String? profilePic;
  final int? otherUserChatId;
  final String? userName;
  const MessagePage({Key? key,this.userName,this.otherUserChatId,this.profilePic}) : super(key: key);

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {

  List<GetAllChats> chatsDetail=[];
  Timer? timer;
  bool isSelected=false;
  int? userId;
  String? username;
  String? userImage;

  ScrollController _controller= ScrollController();
  List _selectedIndexs=[];


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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding: EdgeInsets.only(top: mediaWidth*0.01,),
                  color: Colors.white,
                  width: mediaWidth*0.2,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        WebSideBar(isLogin: true,),
                        SizedBox(height: 20,),
                        Container(
                          height: 30,
                          padding: EdgeInsets.only(left: mediaWidth*0.02,right: mediaWidth*0.01),
                          margin: EdgeInsets.only(top: 10,bottom: 20),
                          child: TextButton(
                            onPressed: () {
                              AppData().signOut();
                              Get.offAll(() => WebInitialScreen());
                            },
                            style: webFlatButtonStyle,
                            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                              Text(AppData().language!.logout.toUpperCase(), textAlign: TextAlign.center, style: openSansBold.copyWith(
                                color: textBtnColor,
                                fontSize: Dimensions.fontSizeExtraSmall,
                              )),
                            ]),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: mediaWidth*0.02),
                          child: Help(),
                        ),
                      ],
                    ),
                  )
              ),
              SingleChildScrollView(
                // physics: NeverScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Container(
                      width: mediaWidth*0.3,
                      child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: chatsDetail.length,
                          shrinkWrap: true,
                          controller: _controller,

                          itemBuilder: (context,index){
                            GetAllChats chat=chatsDetail[index];
                            print('Here is the details of the ');
                            print('-----------------------------------------------------------------------');
                            print(chat.profile_pic!);
                            return InkWell(
                              onTap: () {
                                CustomNavigator.navigateTo(context, MessageDetailsPage(
                                  otherUserChatId: chat.user_id,
                                  userName: chat.name!,
                                  profilePic: chat.profile_pic!,
                                ));
                              },
                              // onTap: () {
                              //   userId = chat.user_id;
                              //   username = chat.name;
                              //   userImage= chat.profile_pic;
                              //   setState(() {});
                              // },
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 45,
                                        height: 45,
                                        child: ProfileImagePicker(
                                          onImagePicked: (value){},
                                          previousImage: chat.profile_pic?? "",
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Container(
                                         // color: isSelected?Colors.amber:Colors.white,
                                          padding: EdgeInsets.symmetric(vertical:10),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(chat.name!, style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold,)),
                                              // SizedBox(height: 10),
                                              Text(chat.message!, style: TextStyle(color:  Colors.black, fontSize: 10, fontWeight: FontWeight.w400, height: 1.5,
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
                            );
                          }),
                    )
                  ],
                ),
              ),
              isSelected?Container(
                width: mediaWidth*0.5,
                child: MessageDetailsPage(otherUserChatId: userId,userName: username,profilePic: userImage),):SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
// otherUserChatId: chat.user_id,
// userName: chat.name!,
// profilePic: chat.profile_pic!,