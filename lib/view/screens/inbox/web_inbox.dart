import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:knaw_news/mixin/data.dart';
import 'package:knaw_news/services/dio_service.dart';
import 'package:knaw_news/util/dimensions.dart';
import 'package:knaw_news/util/images.dart';
import 'package:knaw_news/util/styles.dart';
import 'package:knaw_news/view/base/loading_dialog.dart';
import 'package:knaw_news/view/base/no_data_screen.dart';
import 'package:knaw_news/view/screens/home/home.dart';
import 'package:knaw_news/view/screens/inbox/widget/friend_widget.dart';
import 'package:knaw_news/view/screens/inbox/widget/web_friend_widget.dart';
import 'package:knaw_news/view/screens/menu/app_bar.dart';
import 'package:knaw_news/view/screens/menu/drawer.dart';
import 'package:knaw_news/view/screens/dashboard/widget/bottom_nav_item.dart';
import 'package:knaw_news/view/screens/post/create_post_screen.dart';
import 'package:knaw_news/view/screens/profile/profile_screen.dart';
import 'package:knaw_news/view/screens/search/search_screen.dart';

import '../../base/web_menu_bar.dart';
import 'notification_model.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({Key? key}) : super(key: key);

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  NotificationModel? notificationModel;
  int yesterdayTotal=0;
  int thisWeekTotal=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      getAllInboxNotification();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WebMenuBar(context: context,isAuthenticated: true,isHalf: true,isSearch: false,),
      body: SafeArea(child: Scrollbar(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
          child: Center(
            child: yesterdayTotal+thisWeekTotal!=0?Column(
              children: [
                //Yesterday Notification
                yesterdayTotal>0?Container(
                  width: MediaQuery.of(context).size.width*0.5,
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.04),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppData().language!.yesterday,
                    style: openSansRegular.copyWith(color: textColor,fontSize: Dimensions.fontSizeDefault,),
                  ),
                ):SizedBox(),

                yesterdayTotal>0?Container(
                  width: MediaQuery.of(context).size.width*0.5,
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      //padding: EdgeInsetsGeometry.infinity,
                      itemCount: notificationModel!.yesterdayNotifications!.length,
                      itemBuilder: (context,index){
                        return WebFriendCard(notificationDetail: notificationModel!.yesterdayNotifications![index],);

                      }
                  ),
                ):SizedBox(),


                // This week Notification
                thisWeekTotal>0?Container(
                    width: MediaQuery.of(context).size.width*0.5,
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.04),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppData().language!.thisWeek,
                    style: openSansRegular.copyWith(color: textColor,fontSize: Dimensions.fontSizeDefault,),
                  ),
                ):SizedBox(),

                thisWeekTotal>0?Container(
                width: MediaQuery.of(context).size.width*0.5,
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      //padding: EdgeInsetsGeometry.infinity,
                      itemCount: notificationModel!.thisWeekNotifications!.length,
                      itemBuilder: (context,index){
                        return WebFriendCard(notificationDetail: notificationModel!.thisWeekNotifications![index],);

                      }
                  ),
                ):SizedBox(),
                // FriendCard(icon: Images.placeholder, title: "Muhammad Bilal",subTitle: "Started following you . 2d",),
                // SizedBox(height: 5,),
                // FriendCard(icon: Images.placeholder, title: "Hailrey345 and 3 other",subTitle: "Like your comment .1d",),


              ],
            ):Center(child: NoDataScreen(text: "No Notification Found",)),
          ),
        ),
      ),),
    );
  }
  Future<void> getAllInboxNotification() async {
    openLoadingDialog(context, "Loading");
    var response;
    response = await DioService.post('get_all_inbox_notifications', {
      "usersId" : AppData().userdetail!.usersId
    });
    if(response['status']=='success'){
      var jsonData= response['data'];
      print('--------------------------------------ds');
      print(response);
      notificationModel=  NotificationModel.fromJson(jsonData);
      yesterdayTotal=notificationModel!.yesterdayNotifications!.length;
      thisWeekTotal=notificationModel!.thisWeekNotifications!.length;
      Navigator.pop(context);
      setState(() {

      });
    }
    else{
      Navigator.pop(context);
      //showCustomSnackBar(response['message']);

    }
  }
}
