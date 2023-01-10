import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:knaw_news/mixin/data.dart';
import 'package:knaw_news/util/app_constants.dart';
import 'package:knaw_news/util/dimensions.dart';
import 'package:knaw_news/util/images.dart';
import 'package:knaw_news/util/styles.dart';
import 'package:knaw_news/view/base/custom_image.dart';
import 'package:knaw_news/view/screens/auth/sign_in_screen.dart';
import 'package:knaw_news/view/screens/auth/web/web_sign_in.dart';
import 'package:knaw_news/view/screens/post/create_post_on_web.dart';
import 'package:knaw_news/view/screens/profile/web/web_profile.dart';
import 'package:knaw_news/view/screens/search/web_search.dart';
import 'package:knaw_news/view/screens/search/widget/search_field.dart';
import 'package:knaw_news/view/screens/web/web_home.dart';

import '../../model/signup_model.dart';
import '../../services/dio_service.dart';
import 'loading_dialog.dart';

class WebMenuBar extends StatefulWidget implements PreferredSizeWidget {
  int index;
  BuildContext context;
  bool isAuthScreen;
  bool isAuthenticated;
  bool isSearch;
  bool searchText;
  bool isHalf;
  Function(String title)? onTap;
  WebMenuBar({this.onTap,this.index=5,required this.context,this.isAuthScreen=false,
    this.isAuthenticated=false,this.isSearch=true,this.searchText=false,this.isHalf=false});
  @override
  State<WebMenuBar> createState() => _WebMenuBarState();

  @override
  Size get preferredSize => Size(MediaQuery.of(context).size.width<1000?MediaQuery.of(context).size.width:MediaQuery.of(context).size.width*0.7, 100);
}
class _WebMenuBarState extends State<WebMenuBar> {

  bool isActiveHome=false;
  bool isActiveOrder=false;
  bool isActiveFav=false;
  bool isActiveContact=false;
  bool isAuthScreen=false;
  bool isAuthenticated=false;
  bool isSearch=true;
  bool searchText=false;
  final TextEditingController _searchController = TextEditingController();
  UserDetail userDetail =UserDetail();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.index==1)
       isActiveHome=true;
    else if(widget.index==2)
      isActiveOrder=true;
    else if(widget.index==3)
      isActiveFav=true;
    else if(widget.index==4)
      isActiveContact=true;

    isAuthScreen=widget.isAuthScreen;
    isAuthenticated=widget.isAuthenticated;
    isSearch=widget.isSearch;
    searchText=widget.searchText;
    getProfileDetail();
  }
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    double mediaWidth=size.width<1000?size.width:widget.isHalf?size.width*1:size.width*1;
    return Container(
      color: Colors.white,
      width: mediaWidth,
      height: 70,
      padding: EdgeInsets.symmetric(
          horizontal:mediaWidth*0.05,
          vertical: Dimensions.PADDING_SIZE_SMALL
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment:MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () => AppData().isAuthenticated?Get.toNamed("/"):Get.toNamed("/WebSignIn"),
                  child: Image.asset(Images.logo,),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                    onTap: () => AppData().isAuthenticated?Get.toNamed("/"):Get.toNamed("/WebSignIn"),
                    child: Text('Knaw News',style: openSansExtraBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Colors.black,fontWeight: FontWeight.bold),))
              ],
            ),
            isAuthScreen?SizedBox():isSearch?Center(
              child: SizedBox(
                height: 35,
                width: mediaWidth*0.4,
                child: InkWell(
                  onTap: () => searchText? null :Get.toNamed("/WebSearch"),
                  child: Row(children: [
                    Expanded(
                      child: SearchField(
                        onTap: () => searchText? null :isAuthenticated? Get.toNamed("/WebSearch"):Get.toNamed("/WebSignIn"),
                        controller: _searchController,
                        onChanged: (val){
                          widget.onTap!(_searchController.text);
                        },
                      ),
                    ),
                    Container(
                      width: 50,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.only(topRight: Radius.circular(10),bottomRight: Radius.circular(10))
                      ),
                      padding: const EdgeInsets.all(10.0),
                      child: SvgPicture.asset(Images.search,color: textColor,height: 50,width: 50,),
                    ),
                  ],
                  ),
                ),
              ),
            ):SizedBox(),
            isAuthScreen?SizedBox():Row(
              children: [
              InkWell(
                  child: SvgPicture.asset(Images.add,color: textColor),
                onTap: () => isAuthenticated?Get.toNamed("/WebPostScreen"):Get.toNamed("/WebSignIn"),
              ),
              SizedBox(width: 20,),
              isAuthenticated?InkWell(
                onTap: () => Get.toNamed("/WebProfile"),
                child:
                Stack(
                  children: [
                    ClipOval(
                      child: userDetail.profilePicture == null ||
                          userDetail.profilePicture == ""
                          ? CustomImage(
                        image: Images.placeholder,
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                      )

                          :
                      Image.network(
                        userDetail.profilePicture ?? '',
                             width: 40,height: 40,fit: BoxFit.cover,
                           ),
                    ),
                    userDetail.userVerified == null
                        ? const SizedBox()
                        : userDetail.userVerified
                        ? Positioned(
                            bottom: 0,
                            right: 0,
                            child: SvgPicture.asset(
                              Images.badge,
                              height: 15,
                              width: 15,
                            ),
                        )
                        : const SizedBox(),
                  ],
                ),
                // Stack(
                //   children: [
                //     ClipOval(
                //       child: AppData().userdetail!.profilePicture==null||AppData().userdetail!.profilePicture!.isEmpty?CustomImage(
                //         image: Images.placeholder,
                //         height: 40,
                //         width: 40,
                //         fit: BoxFit.cover,
                //       ):
                //         // Image.network('https://app2.knawnews.com/uploads/profile_images/04-02-22175261knaw_news_user.jpeg',width: 40,height: 40,fit: BoxFit.cover,)
                //       //Image.asset('assets/image/google.png',width: 40,height: 40,fit: BoxFit.cover,color: Colors.black,)
                //       Image.network(
                //         userDetail.profilePicture ?? '',
                //         //AppConstants.proxyUrl+AppData().userdetail!.profilePicture!,
                //         width: 40,height: 40,fit: BoxFit.cover,
                //       ),
                //     ),
                //     AppData().userdetail!.userVerified?Positioned(
                //       bottom: 0, right: 0,
                //       child: SvgPicture.asset(Images.badge,height: 15,width: 15,),
                //     ):SizedBox(),
                //   ],
                // ),
              ):SizedBox(),
              SizedBox(width: 10,),
              isAuthenticated?SizedBox():Container(
                height: 30,
                width: 80,
                child: TextButton(
                  onPressed: () => Get.toNamed("/WebSignIn"),
                  style: webFlatButtonStyle,
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(AppData().isLanguage?AppData().language!.signIn.toUpperCase():"SIGN IN", textAlign: TextAlign.center, style: openSansBold.copyWith(
                      color: textBtnColor,
                      fontSize: Dimensions.fontSizeExtraSmall,
                    )),
                  ]),
                ),
              ),
            ],
            ),


//                  Expanded(child: SizedBox()),

          ]),
    );
  }
  Future<void> getProfileDetail() async {
    var response;
    openLoadingDialog(context, "Loading");
    response = await DioService.post('get_loggedin_profile_details', {
      "usersId" : AppData().userdetail!.usersId
    });
    if(response['status']=='success'){
      var jsonData= response['data'];
      userDetail  =  UserDetail.fromJson(jsonData);
      print(userDetail.toString());
      Navigator.pop(context);
      setState(() {});
      // showCustomSnackBar(response['status'],isError: false);
    }
    else{
      Navigator.pop(context);
      setState(() {

      });
      // showCustomSnackBar(response['message']);

    }
  }

  @override
  Size get preferredSize => Size(MediaQuery.of(context).size.width<1000?MediaQuery.of(context).size.width:MediaQuery.of(context).size.width*0.8, 100);
}



