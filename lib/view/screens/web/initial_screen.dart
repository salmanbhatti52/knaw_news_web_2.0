import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_notifier.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:knaw_news/mixin/data.dart';
import 'package:knaw_news/model/emojis_model.dart';
import 'package:knaw_news/model/language_model.dart';
import 'package:knaw_news/model/post_model.dart';
import 'package:knaw_news/model/signup_model.dart';
import 'package:knaw_news/services/dio_service.dart';
import 'package:knaw_news/util/app_constants.dart';
import 'package:knaw_news/util/dimensions.dart';
import 'package:knaw_news/util/images.dart';
import 'package:knaw_news/util/styles.dart';
import 'package:knaw_news/view/base/custom_button.dart';
import 'package:knaw_news/view/base/custom_image.dart';
import 'package:knaw_news/view/base/custom_snackbar.dart';
import 'package:knaw_news/view/base/loading_dialog.dart';
import 'package:knaw_news/view/base/no_data_screen.dart';
import 'package:knaw_news/view/base/web_menu_bar.dart';
import 'package:knaw_news/view/screens/auth/sign_in_screen.dart';
import 'package:knaw_news/view/screens/auth/social_login.dart';
import 'package:knaw_news/view/screens/auth/web/web_sign_in.dart';
import 'package:knaw_news/view/screens/dashboard/widget/bottom_nav_item.dart';
import 'package:knaw_news/view/screens/home/full_transition_app.dart';
import 'package:knaw_news/view/screens/home/tabbar_item.dart';
import 'package:knaw_news/view/screens/home/widget/full_transition.dart';
import 'package:knaw_news/view/screens/home/widget/report_dialog.dart';
import 'package:knaw_news/view/screens/home/small_transition.dart';
import 'package:knaw_news/view/screens/home/widget/vertical_tile.dart';
import 'package:knaw_news/view/screens/menu/app_bar.dart';
import 'package:knaw_news/view/screens/menu/drawer.dart';
import 'package:knaw_news/view/screens/post/create_post_screen.dart';
import 'package:knaw_news/view/screens/post/widget/category_item.dart';
import 'package:knaw_news/view/screens/profile/profile_screen.dart';
import 'package:knaw_news/view/screens/search/search_screen.dart';
import 'package:knaw_news/view/screens/web/widget/help.dart';
import 'package:knaw_news/view/screens/web/widget/user_info.dart';
import 'package:knaw_news/view/screens/web/widget/web_sidebar.dart';
import 'package:knaw_news/view/screens/web/widget/web_sidebar_item.dart';


class InitialScreen extends StatefulWidget  {
  InitialScreen({Key? key,}) : super(key: key);

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> with TickerProviderStateMixin {
  ScrollController scrollController=ScrollController();
  TabController? _tabController;
  List <Placemark>? plackmark;
  String address="";
  String country="";
  Position position=Position(longitude: 0, latitude: 0, timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1);
  int selected=1;
  String categoryTag="";
  String category="Most Popular";
  String offset="0";
  bool isLoading=true;
  List<String> categoryList=["Most Popular","Happy","Sad","Your News Feed","Global News","Events","Business","Opinion","Technology", "Entertainment","Sports","Beauty","Science","Health",];
  List<PostDetail>? postDetail;
  List<PostDetail>? recentPostDetail=[PostDetail()];
  int totalPost=-1;
  int beforeLoginId=1;
  bool isLanguage=AppData().isLanguage;
  List<GetEmojis>? emojies;
  List<Widget> tabs = [];
  List<Widget> tabsItems = [];
  bool dataLoaded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLanguage=AppData().isLanguage;
    getLanguage();
    _tabController = TabController(length: 16, initialIndex: 0, vsync: this,);
    //loadOtherPosts(isTap: false);
    getLocation();
    recentPost();
    getEmojis();

  }
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    double mediaWidth=size.width<1000?size.width:size.width*0.7;

    return Scaffold(
      drawer: new MyDrawer(),
      appBar: WebMenuBar(context: context,isAuthenticated: false,),
      body: dataLoaded == false
          ? Center(child: CircularProgressIndicator(color: Colors.amber,),) : SafeArea(child: Center(
        child: Container(
          child: Column(
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
                          //showCustomSnackBar(AppData().isLanguage.toString());
                          //showCustomSnackBar(AppData().language==null?"No":AppData().language!.currentLanguage);
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
                            WebSideBar(),
                            Container(
                              height: 30,
                              padding: EdgeInsets.only(left: mediaWidth*0.02,right: mediaWidth*0.01),
                              margin: EdgeInsets.only(top: 10,bottom: 100),
                              child: TextButton(
                                //onPressed: () => Get.to(WebSignIn()),
                                onPressed: () => Get.toNamed("/WebSignIn"),
                                style: webFlatButtonStyle,
                                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                  Text(isLanguage?AppData().language!.signIn.toUpperCase():"SIGN IN", textAlign: TextAlign.center, style: openSansBold.copyWith(
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
                                                isLanguage?AppData().language!.recentPosts:"Recent Posts",
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
                      // child: TabBarView(
                      //   physics: NeverScrollableScrollPhysics(),
                      //   controller: _tabController,
                      //   children: tabsItems,
                      // ),
                    ),
                    //SizedBox(width: MediaQuery.of(context).size.width*0.01,),
                    mediaWidth>710?Container(
                      width: mediaWidth*0.2,
                      margin: EdgeInsets.only(left: mediaWidth*0.01),
                      child: ListView.builder(
                          physics: BouncingScrollPhysics(),
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
                                      isLanguage?AppData().language!.recentPosts:'Recent Posts',
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
            ],
          ),
        ),
      ),),
    );
  }
  Future<void> loadPosts({bool isTap=true}) async {
    offset="0";
    _tabController!.index=selected-1;
    if(isTap){
      return;
    }
    openLoadingDialog(context, "Loading");
    var response;
    response = await DioService.post('all_news_with_base_filter_without_login', {
      "offset": offset,
      "category": category,
      if(categoryTag.isNotEmpty)"categoryTag": categoryTag,
      "userCountry": AppData().userlocation!.country
    });
    if(response['status']=='success'){
      var jsonData= response['data'] as List;
      postDetail=  jsonData.map<PostDetail>((e) => PostDetail.fromJson(e)).toList();
      Navigator.pop(context);
      setState(() {

      });
      // showCustomSnackBar(postDetail![0].title??'');
      totalPost=int.tryParse(response['total_posts'].toString())!;
      print(totalPost.toString());
    }
    else{
      Navigator.pop(context);
      setState(() {

      });
      //showCustomSnackBar(response['message']);
      totalPost=0;
      print(totalPost.toString());

    }
    isLoading=false;
  }
  Future<void> loadPostsMore() async {
    _tabController!.index=selected-1;
    openLoadingDialog(context, "Loading");
    var response;
    response = await DioService.post('all_news_with_base_filter_without_login', {
      "offset": offset,
      "category": category,
      if(categoryTag.isNotEmpty)"categoryTag": categoryTag,
      "userCountry": AppData().userlocation!.country
    });
    if(response['status']=='success'){
      var jsonData= response['data'] as List;
      postDetail!.addAll(jsonData.map<PostDetail>((e) => PostDetail.fromJson(e)).toList());
      Navigator.pop(context);
      setState(() {

      });
      // showCustomSnackBar(postDetail![0].title??'');
      totalPost=int.tryParse(response['total_posts'].toString())!;
      print(totalPost.toString());
    }
    else{
      Navigator.pop(context);
      setState(() {

      });
      showCustomSnackBar(response['message']);
      totalPost=0;
      print(totalPost.toString());

    }
    isLoading=false;
  }
  Future<void> loadOtherPosts({bool isTap=true}) async {
    offset="0";
    _tabController!.index=selected-1;
    if(isTap){
      return;
    }
    openLoadingDialog(context, "Loading");
    var response;
    response = await DioService.post('all_news_with_other_filter_without_login', {
      "offset": offset,
      "otherCategory": category
    });
    if(response['status']=='success'){
      var jsonData= response['data'] as List;
      postDetail = jsonData.map<PostDetail>((e) => PostDetail.fromJson(e)).toList();
      Navigator.pop(context);
      setState(() {

      });
      
      //print(response['total_posts']);
      //print(response['data']);
      // showCustomSnackBar(postDetail![0].title??'');
      totalPost=int.tryParse(response['total_posts'].toString())!;
    }
    else{
      Navigator.pop(context);
      setState(() {

      });
      //showCustomSnackBar(response['message']);
      totalPost=0;
    }
    isLoading=false;
  }
  Future<void> loadOtherPostsMore() async {
    _tabController!.index=selected-1;
    openLoadingDialog(context, "Loading");
    var response;
    response = await DioService.post('all_news_with_other_filter_without_login', {
      "offset": offset,
      "otherCategory": category
    });
    if(response['status']=='success'){
      var jsonData= response['data'] as List;
      postDetail!.addAll(jsonData.map<PostDetail>((e) => PostDetail.fromJson(e)).toList());
      Navigator.pop(context);
      setState(() {

      });
      // showCustomSnackBar(postDetail![0].title??'');
      totalPost=int.tryParse(response['total_posts'].toString())!;
    }
    else{
      Navigator.pop(context);
      setState(() {

      });
      showCustomSnackBar(response['message']);
      totalPost=0;
    }
    isLoading=false;
  }
  Future<void> recentPost() async {
    var response;
    response = await DioService.post('get_recent_posts_web_without_login', {
      "passParam": "12"
    });
    if(response['status']=='success'){
      var jsonData= response['data'] as List;
      recentPostDetail=  jsonData.map<PostDetail>((e) => PostDetail.fromJson(e)).toList();
      setState(() {

      });
    }
    else{
      setState(() {

      });
    }
    isLoading=false;
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

    loadOtherPosts(isTap: false);

    //   position=await _determinePosition();
    //   await convertToAddress(position.latitude, position.longitude, AppConstants.apiKey);

    // print("getLocation");
    // print("address"+address);
    //   UserLocation userLocation=UserLocation();
    //   AppData().userlocation=userLocation;
    //   AppData().userlocation!.address=address;
    //   AppData().userlocation!.country=country;
    //   AppData().userlocation!.latitude=position.latitude;
    //   AppData().userlocation!.longitude=position.longitude;
    //   AppData().updateLocation(AppData().userlocation!);
    //   loadOtherPosts(isTap: false);

  }
  convertToAddress(double lat, double long, String apikey) async {
    Dio dio = Dio();  //initilize dio package
    String apiurl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=$apikey";

    var response = await dio.get(apiurl); //send get request to API URL

    print(response.data);

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


          setState(() {
          });
        }
      }else{
        print(data["error_message"]);
      }
    }else{
      print("error while fetching geoconding data");
    }
  }
  void getLanguage() async {
    print("get Language");
    var response;
    response = await DioService.post('get_language', {
      "language":AppData().isLanguage?AppData().language!.currentLanguage:"english"
    });
    if(response['status']=='success'){
      var jsonData= response['data'];
      Language language = Language.fromJson(jsonData);
      AppData().language=language;
      isLanguage=true;
      setState(() {

      });
      loadOtherPosts(isTap: false);
    }
    else{
      print(response['message']);
      //showCustomSnackBar(response['message']);

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
