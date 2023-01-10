import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:knaw_news/mixin/data.dart';
import 'package:knaw_news/model/emojis_model.dart';
import 'package:knaw_news/model/follow_model.dart';
import 'package:knaw_news/model/post_model.dart';
import 'package:knaw_news/model/signup_model.dart';
import 'package:knaw_news/services/dio_service.dart';
import 'package:knaw_news/util/app_constants.dart';
import 'package:knaw_news/util/dimensions.dart';
import 'package:knaw_news/util/styles.dart';
import 'package:knaw_news/view/base/custom_snackbar.dart';
import 'package:knaw_news/view/base/no_data_screen.dart';
import 'package:knaw_news/view/base/web_menu_bar.dart';
import 'package:knaw_news/view/screens/home/full_transition_app.dart';
import 'package:knaw_news/view/screens/profile/follow_profile.dart';
import 'package:knaw_news/view/screens/profile/profile_screen.dart';
import 'package:knaw_news/view/screens/profile/web/web_follow_profile.dart';
import 'package:knaw_news/view/screens/web/initial_screen.dart';
import 'package:knaw_news/view/screens/web/widget/follow_card.dart';
import 'package:knaw_news/view/screens/web/widget/help.dart';
import 'package:knaw_news/view/screens/web/widget/user_info.dart';
import 'package:knaw_news/view/screens/web/widget/web_sidebar.dart';
import 'package:knaw_news/view/screens/home/tabbar_item.dart';

import '../home/widget/user_info.dart';


class WebHome extends StatefulWidget  {

  WebHome({Key? key,}) : super(key: key);

  @override
  State<WebHome> createState() => _WebHomeState();
}

class _WebHomeState extends State<WebHome> with TickerProviderStateMixin {
  // PostDetail? postDetail;
  ScrollController scrollController=ScrollController();
  List<GetEmojis>? emojies;
  List<Widget> tabs = [];
  List<Widget> tabsItems = [];
  TabController? _tabController;
  List <Placemark>? plackmark;
  String address="";
  String country="";
  Position position=Position(longitude: 0, latitude: 0, timestamp: DateTime.now(),
      accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1);
  int selected=1;
  String categoryTag="";
  String category="Most Popular";
  String offset="0";
  bool isLoading=true;
  List<PostDetail>? postDetail;
  List<PostDetail>? recentPostDetail=[PostDetail()];
  List<FollowDetail>? followDetail;
  List<UserDetail>? suggestedDetail;
  int totalFollowers=0;
  int totalPost=-1;
  int totalSuggested=0;
  int totalRecentPost=0;
  bool dataLoaded = false;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getEmojis();
    _tabController = TabController(length: 16, initialIndex: 0, vsync: this,);
    getLocation();
    recentPost();
    myFollowingList();
    getSuggestedUser();

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    double mediaWidth=size.width<1000?size.width*0.7:size.width*0.7;

    return Scaffold(
      appBar:
      WebMenuBar(context: context,isAuthenticated: true,),

      body: dataLoaded == false
          ? Center(child: CircularProgressIndicator(color: Colors.amber,),) : SafeArea(child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: mediaWidth,
              color: Colors.white,
              padding: EdgeInsets.only(bottom: 5,left: 20,right: 20),
              child: Row(
                children: [
                  InkWell(
                      onTap: (){
                        if(_tabController!.index>0){
                          _tabController!.index--;
                        }
                      },
                      child: Icon(Icons.arrow_back_ios,size: 20,)
                  ),
                  Expanded(
                    child: DefaultTabController(
                        length: emojies!.length,
                        child: SizedBox(
                          height: 60,
                          //width: 200,
                          child: TabBar(
                              controller: _tabController,
                              padding: EdgeInsets.zero,
                              indicatorColor: Colors.amber,
                              indicatorWeight: 4,
                              indicatorSize: TabBarIndicatorSize.label,
                              labelPadding: EdgeInsets.symmetric(horizontal: 5),
                              isScrollable: true,
                              unselectedLabelStyle: openSansBold.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
                              labelStyle: openSansBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                              tabs: tabs
                          ),
                        )
                    ),
                  ),
                  SizedBox(width: 10,),
                  InkWell(
                    onTap: (){
                      if(_tabController!.index<13){
                        _tabController!.index++;
                      }
                    },
                    child: Icon(Icons.arrow_forward_ios,size: 20,),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    child: Container(
                      color: Colors.white,
                      width: mediaWidth>710?mediaWidth*0.2:mediaWidth*0.4,
                      margin: EdgeInsets.only(right: mediaWidth*0.01,top: 10),
                      child: Column(
                        children: [
                          WebSideBar(isLogin: true,),
                          Container(
                            height: 10,
                            width: mediaWidth>710?mediaWidth*0.2:mediaWidth*0.4,
                            color: Color(0xFFF8F8FA),
                          ),
                          Text(AppData().language!.followingAccounts,style: openSansBold.copyWith(color: Colors.black,fontSize: Dimensions.fontSizeSmall),),
                          totalFollowers>0?Container(
                            width: mediaWidth>710?mediaWidth*0.2:mediaWidth*0.4,
                            child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                //padding: EdgeInsetsGeometry.infinity,
                                itemCount: followDetail!.length,
                                itemBuilder: (context,index){
                                  return Column(
                                    children: [
                                      FollowCard(
                                        width: mediaWidth>710?mediaWidth*0.2:mediaWidth*0.4,
                                        icon: followDetail![index].followProfilePicture??'',
                                        title: followDetail![index].followUserName??'',
                                        isVerified: followDetail![index].userVerified,
                                        onTap: () => Get.to(() => WebFollowProfile(userId: followDetail![index].followingToUserId,)),
                                      ),
                                    ],
                                  );
                                }
                            ),
                          ):Center(child: NoDataScreen(text: "No Following Found",)),
                          Container(
                            height: 10,
                            width: mediaWidth>710?mediaWidth*0.2:mediaWidth*0.4,
                            color: Color(0xFFF8F8FA),
                          ),
                          Text(AppData().language!.suggestedAccounts,style: openSansBold.copyWith(color: Colors.black,fontSize: Dimensions.fontSizeSmall),),
                          totalSuggested>0?Container(
                            width: mediaWidth>710?mediaWidth*0.2:mediaWidth*0.4,
                            child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                //padding: EdgeInsetsGeometry.infinity,
                                itemCount: suggestedDetail!.length,
                                itemBuilder: (context,index){
                                  return Column(
                                    children: [
                                      FollowCard(
                                        width: mediaWidth>710?mediaWidth*0.2:mediaWidth*0.4,
                                        icon: suggestedDetail![index].profilePicture??'',
                                        title: suggestedDetail![index].userName??'',
                                        isVerified: suggestedDetail![index].userVerified,
                                        onTap: () => Get.to(() => WebFollowProfile(userId: suggestedDetail![index].usersId,)),
                                      ),
                                    ],
                                  );
                                }
                            ),
                          ):Center(child: NoDataScreen(text: "No Suggested Found",)),
                          Container(
                            height: 30,
                            padding: EdgeInsets.only(left: mediaWidth*0.02,right: mediaWidth*0.01),
                            margin: EdgeInsets.only(top: 10,bottom: 10),
                            child: TextButton(
                              onPressed: () {
                                AppData().signOut();
                                Get.offAll(() => InitialScreen());
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
                            height: 10,
                            width: mediaWidth>710?mediaWidth*0.2:mediaWidth*0.4,
                            color: Color(0xFFF8F8FA),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: mediaWidth*0.02),
                            child: Help(),
                          ),

                          Container(
                            height: 5,
                            width: mediaWidth*0.4,
                            color: Color(0xFFF8F8FA),
                          ),
                          mediaWidth<710?Container(
                              color: Color(0xFFF8F8FA),
                              width: mediaWidth*0.4,
                              child: ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  //padding: EdgeInsetsGeometry.infinity,
                                  itemCount: recentPostDetail!.length,
                                  itemBuilder: (context,index){
                                    return Container(
                                      color: Colors.white,
                                      margin: EdgeInsets.only(top: 5),
                                      padding: EdgeInsets.symmetric(vertical: 5),
                                      child: Column(
                                        children: [
                                          index==0?Container(
                                            margin: EdgeInsets.symmetric(vertical: 5),
                                            child: Text(
                                              AppData().language!.recentPosts,
                                              maxLines: 1,
                                              style: openSansBold.copyWith(fontSize: Dimensions.fontSizeExtraSmall,color: Colors.black,overflow: TextOverflow.ellipsis),
                                            ),
                                          ):SizedBox(),
                                          WebUserInfo(postDetail: recentPostDetail![index]),
                                          Align(
                                            alignment:Alignment.topLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                              child: Text(
                                                recentPostDetail![index].title??'',
                                                maxLines: 2,
                                                style: openSansRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall,color: Colors.black,overflow: TextOverflow.ellipsis),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                              )
                            //child: postDetail!=null?UserInfo(postDetail: postDetail!.first):SizedBox(),
                          ):SizedBox(),
                        ],
                      ),
                    ),
                  ),
                  //SizedBox(width: MediaQuery.of(context).size.width*0.01,),
                  Container(
                    width: mediaWidth*0.58,
                    child: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: _tabController,
                      children: tabsItems,
                    ),
                  ),
                  //SizedBox(width: MediaQuery.of(context).size.width*0.01,),
                  mediaWidth>710?SingleChildScrollView(
                    child: Container(
                        width: mediaWidth*0.2,
                        margin: EdgeInsets.only(left: mediaWidth*0.01),
                        child: totalRecentPost>0?
                        ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            //padding: EdgeInsetsGeometry.infinity,
                            itemCount: recentPostDetail!.length,
                            itemBuilder: (context,index){
                              return Container(
                                color: Colors.white,
                                margin: EdgeInsets.only(top: 5),
                                padding: index==0?EdgeInsets.only(bottom: 5):EdgeInsets.symmetric(vertical: 5),
                                child: Column(
                                  children: [
                                    index==0?Container(
                                      height: 5,
                                      width: mediaWidth*0.2,
                                      color: Color(0xFFF8F8FA),
                                    ):SizedBox(),
                                    index==0?Container(
                                      margin: EdgeInsets.symmetric(vertical: 5),
                                      child: Text(
                                        AppData().language!.recentPosts,
                                        maxLines: 1,
                                        style: openSansBold.copyWith(fontSize: Dimensions.fontSizeExtraSmall,color: Colors.black,overflow: TextOverflow.ellipsis),
                                      ),
                                    ):SizedBox(),
                                     UserInfo(postDetail: recentPostDetail![index]),
                                    // InkWell(
                                    //   onTap: (){
                                    //     if(GetPlatform.isDesktop){
                                    //       if(AppData().isAuthenticated){
                                    //         AppData().userdetail!.usersId==postDetail!.first.usersId?Get.toNamed("/WebProfile"):Get.to(() => WebFollowProfile(userId: postDetail!.first.usersId,));
                                    //       }
                                    //       else{
                                    //         Get.toNamed("/WebSignIn");
                                    //       }
                                    //     }
                                    //     else{
                                    //       Get.to(() => AppData().userdetail!.usersId==postDetail!.first.usersId?ProfileScreen():FollowProfile(userId: postDetail!.first.usersId,));
                                    //     }
                                    //   },
                                    //   child: Align(
                                    //     alignment:Alignment.topLeft,
                                    //     child: Padding(
                                    //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    //       child: Text(
                                    //         recentPostDetail![index].title??'',
                                    //         maxLines: 2,
                                    //         style: openSansRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall,color: Colors.black,overflow: TextOverflow.ellipsis),
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text(recentPostDetail![index].description.toString(),
                                      textAlign: TextAlign.start,
                                        maxLines: 2,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                        ):
                        Center(child: NoDataScreen(text: "No Recent Post Found",))
                      //child: postDetail!=null?UserInfo(postDetail: postDetail!.first):SizedBox(),
                    ),
                  ):SizedBox(),
                ],
              ),
            ),
          ],
        ),
      ),),
    );
  }


  Future<void> recentPost() async {
    var response;
    response = await DioService.post('get_recent_posts_web', {
      "usersId" : AppData().userdetail!.usersId
    });
    if(response['status']=='success'){
      var jsonData= response['data'] as List;
      recentPostDetail=  jsonData.map<PostDetail>((e) => PostDetail.fromJson(e)).toList();
      totalRecentPost=recentPostDetail!.length;
      setState(() {

      });
    }
    else{
      totalRecentPost=0;
      setState(() {

      });

    }
    isLoading=false;
  }

  Future<void> myFollowingList() async {
    var response;
    response = await DioService.post('get_all_following_web', {
      "usersId" : AppData().userdetail!.usersId,
      "offset": "0"
    });
    if(response['status']=='success'){
      var jsonData= response['data'] as List;
      followDetail=  jsonData.map<FollowDetail>((e) => FollowDetail.fromJson(e)).toList();
      totalFollowers=followDetail!.length;
      setState(() {

      });
    }
    else{
      totalFollowers=-1;
    }
  }

  Future<void> getSuggestedUser() async {
    var response;
    response = await DioService.post('get_suggested_accounts', {
      "usersId" : AppData().userdetail!.usersId,
    });
    if(response['status']=='success'){
      var jsonData= response['data'] as List;
      suggestedDetail=  jsonData.map<UserDetail>((e) => UserDetail.fromJson(e)).toList();
      totalSuggested=suggestedDetail!.length;
      setState(() {

      });
    }
    else{
      totalSuggested=-1;
    }
  }


  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<void> getLocation() async {

    //   position=await _determinePosition();
    //   await convertToAddress(position.latitude, position.longitude, AppConstants.apiKey);
    // if(AppData().userdetail!.address.isEmpty){
    //   AppData().userdetail!.address=address;
    //   AppData().userdetail!.country=country;
    //   AppData().userdetail!.latitude=position.latitude;
    //   AppData().userdetail!.longitude=position.longitude;
    //   //loadOtherPosts(isTap: false);
    // }
    // else{
    //   AppData().userdetail!.address=address;
    //   AppData().userdetail!.country=country;
    //   AppData().userdetail!.latitude=position.latitude;
    //   AppData().userdetail!.longitude=position.longitude;
    // }
    // AppData().update();

  }
  convertToAddress(double lat, double long, String apikey) async {
    Dio dio = Dio();  //initilize dio package
    String apiurl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=$apikey";

    var response = await dio.get(apiurl); //send get request to API URL

    //print(response.data);

    if(response.statusCode == 200){ //if connection is successful
      Map data = response.data; //get response data
      if(data["status"] == "OK"){ //if status is "OK" returned from REST API
        if(data["results"].length > 0){ //if there is atleast one address
          Map firstresult = data["results"][0]; //select the first address

          address = firstresult["formatted_address"];
          List<String> list=address.split(',');
          print("this is country name");
          print(list.last);
          country = list.last.trim();
          print(firstresult["geometry"]["location"]);



          //showCustomSnackBar(address,isError: false);//get the address

          //you can use the JSON data to get address in your own format

          setState(() {
            //refresh UI
          });
        }
      }else{
        print(data["error_message"]);
      }
    }else{
      print("error while fetching geoconding data");
    }
  }

  void getEmojis() async {
    var response;
    response = await DioService.get('get_all_emoji');
    if(response['status']=='success'){
      var jsonData= response['data'] as List;
      emojies= jsonData.map<GetEmojis>((e) => GetEmojis.fromJson(e)).toList();
      for(int i= 0; i<emojies!.length; i++)
      {
        tabs.add(
          TabBarItem(
              isSelected: selected ==emojies![i].id?true:false,
              icon: 'assets/emojis/${emojies![i].path}',
              onTap: (){
                print("seleteeee ${selected}");
                print("emojies![i].id ${emojies![i].id}");
                _tabController!.index = emojies![i].id!;
                setState(() {
                });
              }),
        );

        tabsItems.add(
            FullTransitionApp(cateID: emojies![i].id!)
        );
      }

      dataLoaded = true;
      setState(() {

      });


    }
    else{
      print(response['message']);
      showCustomSnackBar(response['message']);
    }
  }
}
