import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:knaw_news/mixin/data.dart';
import 'package:knaw_news/model/signup_model.dart';
import 'package:knaw_news/services/dio_service.dart';
import 'package:knaw_news/util/app_constants.dart';
import 'package:knaw_news/util/dimensions.dart';
import 'package:knaw_news/util/images.dart';
import 'package:knaw_news/util/styles.dart';
import 'package:knaw_news/view/base/custom-navigator.dart';
import 'package:knaw_news/view/base/custom_image.dart';
import 'package:knaw_news/view/base/custom_snackbar.dart';
import 'package:knaw_news/view/base/loading_dialog.dart';
import 'package:knaw_news/view/base/report_user_dialog.dart';
import 'package:knaw_news/view/base/web_menu_bar.dart';
import 'package:knaw_news/view/screens/dashboard/widget/bottom_nav_item.dart';
import 'package:knaw_news/view/screens/home/home.dart';
import 'package:knaw_news/view/screens/menu/app_bar.dart';
import 'package:knaw_news/view/screens/menu/drawer.dart';
import 'package:knaw_news/view/screens/messeges/messageDetailsPage.dart';
import 'package:knaw_news/view/screens/post/create_post_screen.dart';
import 'package:knaw_news/view/screens/profile/profile_screen.dart';
import 'package:knaw_news/view/screens/profile/show_my_post.dart';
import 'package:knaw_news/view/screens/profile/stats.dart';
import 'package:knaw_news/view/screens/profile/web/web_profile.dart';
import 'package:knaw_news/view/screens/profile/web/web_stats.dart';
import 'package:knaw_news/view/screens/search/search_screen.dart';
import 'package:knaw_news/view/screens/setting/setting.dart';

import '../../home/web_initial_screen.dart';
import '../../web/widget/help.dart';
import '../../web/widget/web_sidebar.dart';

class WebFollowProfile extends StatefulWidget {
  int? userId;
  WebFollowProfile({Key? key,this.userId}) : super(key: key);

  @override
  _WebFollowProfileState createState() => _WebFollowProfileState();
}

class _WebFollowProfileState extends State<WebFollowProfile> with TickerProviderStateMixin {
  UserDetail userDetail =UserDetail();
  late TabController _tabController;
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      getProfileDetail();
    });
  }
  void showCustomDialog(context) {
    double w =MediaQuery.of(context).size.width*0.5;
    showDialog(
      context: context,
      builder: (ctx) =>
          Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              width: w*0.5,
              margin: EdgeInsets.zero,
              height: 165,
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Block ",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                        Text("${userDetail.userName.toString()} ?",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold))
                      ],
                    ),
                    SizedBox(height: 8),
                    Text('They will not be able to send your messages,see your posts,or find your profile.'
                        ' They will not be notify that you blocked them.',
                      style: TextStyle(fontSize: 14  ),
                      textAlign: TextAlign.center,),
                    SizedBox(height: 15),
                    Container(height: 0.5,color: Colors.grey.shade400,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          onPressed: (){Navigator.pop(context);},
                          child: Text('Cancel',style: TextStyle(color: Colors.black,fontSize: 16),),
                        ),
                        Container(height: 45,width: 0.5,color: Colors.grey.shade400,),
                        TextButton(
                          onPressed: (){
                            blockUser();
                            reloadProfileDetail();
                          },
                          child: Text('Block',style: TextStyle(color: Colors.red,fontSize: 16),),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            ),
          ),
    );
  }
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    double mediaWidth=size.width;
    mediaWidth/=2;
    return Scaffold(
      appBar: WebMenuBar(context: context,isSearch: false,isAuthenticated: true,),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              padding: EdgeInsets.only(top: mediaWidth*0.01,),
              color: Colors.white,
              width: mediaWidth*0.4,
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
              )
          ),
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              width: mediaWidth,
              height: MediaQuery.of(context).size.height*1.2,
              child: Column(
                children: [
                  Container(
                     width: mediaWidth,
                    color: Colors.white,
                    alignment: Alignment.topCenter,
                    child: Container(
                       width: mediaWidth*0.7,
                      margin: EdgeInsets.only(top: 20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.amber,
                                      width: 2,
                                    ),
                                    shape: BoxShape.circle
                                ),

                                child: Stack(
                                  children: [
                                    ClipOval(
                                      child: userDetail.profilePicture == null || userDetail.profilePicture == "" ?CustomImage(
                                        image: Images.placeholder,
                                        height: 120,
                                        width: 120,
                                        fit: BoxFit.cover,
                                      ):Image.network(
                                        AppConstants.proxyUrl+userDetail.profilePicture!,
                                        width: 120,height: 120,fit: BoxFit.cover,
                                      ),
                                    ),
                                    userDetail.userVerified==null?SizedBox():userDetail.userVerified?Positioned(
                                      bottom: 5, right: 5,
                                      child: SvgPicture.asset(Images.badge,),
                                    ):SizedBox(),
                                  ],
                                ),

                              ),
                              SizedBox(width: 20,),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(userDetail.userName??"Name",style: openSansBold.copyWith(color:Colors.black,fontSize: Dimensions.fontSizeSmall),),

                                  Text("${AppData().language!.joined} "+userDetail.joinedSince.toString(),style: openSansRegular.copyWith(color:textColor,fontSize: Dimensions.fontSizeExtraSmall),),

                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                                        child: SvgPicture.asset(Images.followers,color: Colors.black,),
                                      ),
                                      SizedBox(width: 5,),
                                      Text(AppData().language!.followers,style: openSansRegular.copyWith(color:Colors.black,fontSize: Dimensions.fontSizeExtraSmall),),
                                      SizedBox(width: 5,),
                                      Text(userDetail.totalFollowers.toString(),style: openSansRegular.copyWith(color:Colors.black,fontSize: Dimensions.fontSizeExtraSmall),),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: followUser,
                                        child: Container(
                                          height: 30,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              color: userDetail.isFollowed?Colors.amber:Colors.black
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                child: SvgPicture.asset(Images.user,color: Colors.white,),
                                              ),
                                              Text(userDetail.isFollowed?AppData().language!.unfollow:AppData().language!.follow,style: openSansRegular.copyWith(color:Colors.white,fontSize: Dimensions.fontSizeSmall),)

                                            ],),
                                        ),
                                      ),
                                      SizedBox(width: 20,),
                                      GestureDetector(
                                        onTap: (){
                                          CustomNavigator.navigateTo(context, MessageDetailsPage(
                                            userName: userDetail.userName.toString(),
                                            profilePic: userDetail.profilePicture!,
                                            otherUserChatId: userDetail.usersId,
                                          ));
                                        },
                                        child: MouseRegion(
                                          cursor: SystemMouseCursors.click,
                                          child: Container(
                                            height: 33,
                                            padding: EdgeInsets.symmetric(horizontal: 15),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                color: Colors.amber
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [

                                                Text('Message',style: openSansRegular.copyWith(color:Colors.white),)

                                              ],),
                                          ),
                                        ),
                                      ),
                                      // InkWell(
                                      //   onTap: userDetail.isMuted?unMuteMember:muteMember,
                                      //   child: Container(
                                      //     height: 30,
                                      //     width: 80,
                                      //     decoration: BoxDecoration(
                                      //         borderRadius: BorderRadius.circular(5),
                                      //         color: Colors.red
                                      //     ),
                                      //     child: Center(child: Text(userDetail.isMuted?AppData().language!.unmute:AppData().language!.mute,style: openSansRegular.copyWith(color:Colors.white,fontSize: Dimensions.fontSizeSmall),))
                                      //
                                      //   ),
                                      // ),
                                    ],
                                  ),

                                ],
                              ),
                            ],
                          ),
                          Container(
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text(userDetail.description??'',style: openSansRegular.copyWith(color:Colors.black,fontSize: Dimensions.fontSizeExtraSmall),)
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: (){
                                  userDetail.isMuted?SizedBox():muteMember();
                                },
                                child: Container(
                                height: 27,
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.black
                                ),
                                child: Center(child: Text(userDetail.isMuted?'Muted':AppData().language!.mute,style: openSansRegular.copyWith(color:Colors.white),),)
                    ),
                              ),
                            ),
                            SizedBox(width: MediaQuery.of(context).size.width*0.01),
                            GestureDetector(
                              onTap: (){
                                userDetail.isBlocked?SizedBox():showCustomDialog(context);
                              },
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: Container(
                                height: 27,
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.red
                                ),
                                child: Center(child: Text(userDetail.isBlocked?"Blocked":'Block',style: openSansRegular.copyWith(color:Colors.white),)),
                    ),
                              ),
                            ),
                            SizedBox(width: MediaQuery.of(context).size.width*0.01),
                            GestureDetector(
                              onTap: (){
                                userDetail.isReported?SizedBox():Get.dialog(ReportUserDialog(onUserReport: (val){reportUser(val);},));
                                // reloadProfileDetail();
                              },
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: Container(
                                height: 27,
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.amber
                                ),
                                child:Center(child: Text(userDetail.isReported?"Reported":"Report",style: openSansRegular.copyWith(color:Colors.white),))

                                ),
                              ),
                            ),
                            ],
                          ),
                          SizedBox(height: 20,),
                        ],
                      ),
                    ),
                  ),

                  Container(
                    //padding: EdgeInsets.all(2),
                    margin: EdgeInsets.only(top: 10),

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: Container(
                      height: 35,
                      padding: EdgeInsets.all(3),
                      width: mediaWidth<500?mediaWidth:mediaWidth*0.7,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: TabBar(
                        labelPadding: EdgeInsets.all(2),
                        controller: _tabController,
                        indicator: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadiusDirectional.circular(20),
                        ),
                        indicatorColor:Theme.of(context).primaryColor,
                        indicatorWeight: 3,
                        labelColor:Colors.black,
                        unselectedLabelColor:Colors.black,
                        unselectedLabelStyle: openSansBold.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
                        labelStyle: openSansBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                        tabs: [
                          Tab(text: AppData().language!.posts),
                          Tab(text: AppData().language!.stats),
                        ],
                      ),
                    ),
                  ),

                  widget.userId==AppData().userdetail!.usersId?const SizedBox():
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        ShowPost(userId: widget.userId,),
                        WebStats(userId: widget.userId),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Future<void> getProfileDetail() async {
      var response;
      openLoadingDialog(context, "Loading");
      response = await DioService.post('get_other_profile_details', {
        "usersId" : AppData().userdetail!.usersId,
        "otherUserId" : widget.userId
      });
      if(response['status']=='success'){
        var jsonData= response['data'];
        userDetail  =  UserDetail.fromJson(jsonData);
        print(userDetail.toJson());
        Get.back();
        if(widget.userId==AppData().userdetail!.usersId){
          Get.to(() => WebProfile());
          return;
        }
        setState(() {});
        // showCustomSnackBar(response['status'],isError: false);
      }
      else{
        Get.back();
        if(widget.userId==AppData().userdetail!.usersId){
          Get.to(() => WebProfile());
          return;
        }
        setState(() {

        });
        showCustomSnackBar(response['status']);
      }
    }
  Future<void> followUser() async {
    openLoadingDialog(context, "Loading");
    var response;
    response = await DioService.post('follow_user', {
      "followingToUser" : userDetail.usersId,
      "followedByUser" : AppData().userdetail!.usersId
    });
    if(response['status']=='success'){
      //print(postDetail![0].toJson());
      Navigator.pop(context);
      userDetail.isFollowed=!userDetail.isFollowed;
      setState(() {

      });
      showCustomSnackBar(response['data'],isError: false);
      //print(followDetail[2].toJson());
    }
    else{
      Navigator.pop(context);
      showCustomSnackBar(response['message']);

    }
  }
  void muteMember() async{
    openLoadingDialog(context, "Loading");
    var response;
    response = await DioService.post('mute_member', {
      "muteUsersId": userDetail.usersId,
      "usersId": AppData().userdetail!.usersId
    });
    if(response['status']=='success'){
      userDetail.isMuted=true;
      setState(() {

      });
      Navigator.pop(context);
      showCustomSnackBar(response['data'],isError: false);
    }
    else{
      setState(() {

      });
      Navigator.pop(context);
      showCustomSnackBar(response['message']);
    }

  }
  void unMuteMember() async{
    openLoadingDialog(context, "Loading");
    var response;
    response = await DioService.post('unmute_member', {
      "muteUsersId": userDetail.usersId,
      "usersId": AppData().userdetail!.usersId
    });
    if(response['status']=='success'){
      userDetail.isMuted=false;
      setState(() {

      });
      Navigator.pop(context);
      showCustomSnackBar(response['data'],isError: false);
    }
    else{
      setState(() {

      });
      Navigator.pop(context);
      showCustomSnackBar(response['message']);
    }

  }
  Future<void> reloadProfileDetail() async {
    var response;
    response = await DioService.post('get_other_profile_details', {
      "usersId" : AppData().userdetail!.usersId,
      "otherUserId" : widget.userId
    });
    if(response['status']=='success'){
      var jsonData= response['data'];
      userDetail  =  UserDetail.fromJson(jsonData);
      print(userDetail.toJson());
      if(widget.userId==AppData().userdetail!.usersId){
        Get.to(() => ProfileScreen());
        return;
      }
      setState(() {});
      // showCustomSnackBar(response['status'],isError: false);
    }
    else{
      if(widget.userId==AppData().userdetail!.usersId){
        Get.to(() => ProfileScreen());
        return;
      }
      setState(() {

      });
      //showCustomSnackBar(response['status']);
    }
  }
  void blockUser() async {
    openLoadingDialog(context, "Loading");
    var response;
    var data = {
      "blockedByUserId":AppData().userdetail!.usersId.toString(),
      "blockedUserId":widget.userId.toString()
    };
    print(data);
    response = await DioService.post('block_user', data);
    print(response);
    if(response['status']=='success'){
      showCustomSnackBar("Blocked successfully");
      Navigator.pop(context);
      Navigator.pop(context);
    }
    else{
      Navigator.pop(context);
      print(response['message']);
      showCustomSnackBar(response['message']);
      Navigator.pop(context);

    }
  }
  void reportUser(String reason) async {
    openLoadingDialog(context, "Loading");
    var response;
    var data = {
      "reportedByUserId":AppData().userdetail!.usersId.toString(),
      "reportedToUserId":widget.userId.toString(),
      "reason":reason
    };
    print(data);
    response = await DioService.post('report_user', data);
    print(response);
    if(response['status']=='success'){
      showCustomSnackBar(response['message']);
      Navigator.pop(context);
      Navigator.pop(context);
    }
    else{
      Navigator.pop(context);
      Navigator.pop(context);
      print(response['message']);
      showCustomSnackBar(response['message']);
    }
  }


}
