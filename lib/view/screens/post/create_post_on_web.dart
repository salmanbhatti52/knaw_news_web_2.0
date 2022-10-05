import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:intl/intl.dart';
import 'package:knaw_news/mixin/data.dart';
import 'package:knaw_news/model/post_model.dart';
import 'package:knaw_news/services/dio_service.dart';
import 'package:knaw_news/util/app_constants.dart';
import 'package:knaw_news/util/dimensions.dart';
import 'package:knaw_news/util/images.dart';
import 'package:knaw_news/util/styles.dart';
import 'package:knaw_news/view/base/custom_image.dart';
import 'package:knaw_news/view/base/custom_snackbar.dart';
import 'package:knaw_news/view/base/loading_dialog.dart';
import 'package:knaw_news/view/base/web_menu_bar.dart';
import 'package:knaw_news/view/screens/dashboard/dashboard_screen.dart';
import 'package:knaw_news/view/screens/home/web_initial_screen.dart';
import 'package:knaw_news/view/screens/map/map.dart';
import 'package:knaw_news/view/screens/menu/app_bar.dart';
import 'package:knaw_news/view/screens/menu/drawer.dart';
import 'package:knaw_news/view/screens/post/widget/category_item.dart';
import 'package:knaw_news/view/screens/post/widget/news_type_item.dart';
import 'package:knaw_news/view/screens/profile/profile_screen.dart';
import 'package:knaw_news/view/screens/web/web_home.dart';
import 'package:knaw_news/view/screens/web/widget/help.dart';
import 'package:knaw_news/view/screens/web/widget/web_sidebar.dart';
import 'package:places_service/places_service.dart';



class WebPostScreen extends StatefulWidget {
  const WebPostScreen({Key? key}) : super(key: key);

  @override
  State<WebPostScreen> createState() => _WebPostScreenState();
}

class _WebPostScreenState extends State<WebPostScreen> {
  TextEditingController eventStartDate=TextEditingController();
  TextEditingController eventEndDate=TextEditingController();
  TextEditingController addressController=TextEditingController();
  TextEditingController linkController=TextEditingController();
  PlacesService  _placesService = PlacesService();
  List<PlacesAutoCompleteResult>  _autoCompleteResult=[];
  PostDetail post=PostDetail(usersId: AppData().userdetail!.usersId,country: "Pakistan",
      location: "Multan Pakistan",latitude: 30.239829,longitude: 71.4853763,
      postalCode: "",externalLink: "");
  int newsType=1;
  int category=0;
  PickedFile _pickedFile=PickedFile("");

  bool isActive=false;
  bool isLocation=false;
  bool isEventIndefinit=false;
  bool isEvent=false;
  String? postPicture;
  Uint8List? bytesFromPicker;
  Image? fromPicker;
  Position? position;
  DateTime selectedDate=DateTime.now();

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPosition();
    _placesService.initialize(apiKey: AppConstants.apiKey);
  }
  Future<void> getPosition() async {
    position= await _determinePosition();
    await convertToAddress(position!.latitude, position!.longitude, AppConstants.apiKey);

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

          post.location = firstresult["formatted_address"];
          List<String> list=post.location!.split(',');
          print("this is country name");
          print(list.last);
          post.country = list.last.trim();
          print(post.country);
          addressController.text=post.country!;


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

  @override
  Widget build(BuildContext context) {

    Size size=MediaQuery.of(context).size;
    double mediaWidth=size.width;
    if(mediaWidth>1000)
      mediaWidth*=0.5;
    return Scaffold(
      appBar: WebMenuBar(context: context,isAuthenticated: true,),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top:20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding: EdgeInsets.only(top: mediaWidth*0.01,),
                  color: Colors.white,
                  width: mediaWidth*0.37,
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
              SizedBox(width: 20,),
              InkWell(
              hoverColor: Color(0xFFF8F8FA),
              splashColor: Color(0xFFF8F8FA),
              highlightColor: Color(0xFFF8F8FA),
              focusColor: Color(0xFFF8F8FA),
              onTap: (){

                setState(() {
                  _autoCompleteResult.clear();
                });
              },
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                //padding: EdgeInsets.symmetric(horizontal:Dimensions.PADDING_SIZE_SMALL),
                child: Container(
                  width: mediaWidth,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20,),
                      Container(
                          width: mediaWidth,
                          //padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.03),
                          //alignment: Alignment.centerLeft,
                          child: Text(AppData().language!.post,style: openSansBold.copyWith(color: Colors.black),)
                      ),
                      SizedBox(height: 10,),


                      SizedBox(
                        width: MediaQuery.of(context).size.width*0.4,
                        child: TextFormField(
                          onChanged: (value)=> post.description=value,
                          minLines: 4,
                          maxLines: 4,
                          maxLength: 150,
                          style: openSansRegular.copyWith(fontSize: Dimensions.fontSizeSmall,color: textColor),
                          keyboardType: TextInputType.multiline,
                          cursorColor: Theme.of(context).primaryColor,
                          autofocus: false,
                          decoration: InputDecoration(
                            focusColor: const Color(0XF7F7F7),
                            hoverColor: const Color(0XF7F7F7),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                              borderSide: const BorderSide(style: BorderStyle.none, width: 0),
                            ),
                            isDense: true,
                            hintText: AppData().language!.yourDescription,
                            fillColor:Color(0XFFF0F0F0),
                            hintStyle: openSansRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                            filled: true,

                          ),
                        ),
                      ),
                      SizedBox(height: 10,),


                      Container(
                        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.12),
                        height: 35,
                        width: mediaWidth*0.6,
                        margin: EdgeInsets.symmetric(vertical: 20),
                        child: TextButton(
                          onPressed: (){
                             postNews();
                             },

                          style: flatButtonStyle,
                          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                            Text(AppData().language!.post.toUpperCase(), textAlign: TextAlign.center, style: openSansBold.copyWith(
                              color: textBtnColor,
                              fontSize: Dimensions.fontSizeDefault,
                            )),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
            ],
          ),
        ),),
    );
  }

  Future<void> postNews() async {

    if(category==1&&!isEventIndefinit&&(eventStartDate.text.isEmpty||eventEndDate.text.isEmpty)){
      print("here");
      //showCustomSnackBar("Select Event start and end date");
      return;

    }
    openLoadingDialog(context, "Loading");
    var response;
    var data = {
      "usersId" : post.usersId,
      "title": post.title,
      "description": post.description,
      if(post.externalLink!=null && post.externalLink!.isNotEmpty)"externalLink": post.externalLink??' ',
      "location": post.location,
      "newsCountry": post.country,
      "longitude": post.longitude,
      "latitude": post.latitude,
      if(post.postPicture!=null)"postPicture": post.postPicture,
      if(category==1&&!isEventIndefinit)"eventNewsStartDate" : post.eventNewsStartDate,
      if(category==1&&!isEventIndefinit)"eventNewsEndDate" : post.eventNewsEndDate
    };

    response = await DioService.post('create_news_post', data);
    if(response['status']=='success'){
      Navigator.pop(context);
      Get.toNamed("/WebHome");
    }
    else{
      Navigator.pop(context);
      showCustomSnackBar(response['message']);

    }
  }
  Future uploadPicture(var data) async {
    print(bytesFromPicker);

    print(data.files.toList());
    print(data.fields.toList().toList());
    //print(data.finalize().toList());
    openLoadingDialog(context, "Loading");
    var response;

    response = await DioService.post('upload_news_image', FormData.fromMap(({
      'news_image' :  MultipartFile.fromBytes(data.bytes as List<int>)
    })));
    if(response['status']=='success'){
      post.postPicture=response["data"];
      Navigator.pop(context);
      showCustomSnackBar(response['data']);
    }
    else{
      Navigator.pop(context);
      print("helllooo");
      print(response['message']);
      showCustomSnackBar(response['message']);

    }
  }
  _selectStartDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: selectedDate,
      lastDate: DateTime(selectedDate.year+5),
    );
    if (selected != null && selected != selectedDate) {
      print(selected);
      setState(() {
        selectedDate = selected;
        eventStartDate.text=DateFormat("dd MMM, yyyy").format(selectedDate);
        post.eventNewsStartDate=eventStartDate.text;
      });
    }
  }
  _selectEndDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: selectedDate,
      lastDate: DateTime(selectedDate.year+5),
    );
    if (selected != null && selected != selectedDate) {
      print(selected);
      setState(() {
        selectedDate = selected;
        eventEndDate.text=DateFormat("dd MMM, yyyy").format(selectedDate);
        post.eventNewsEndDate=eventEndDate.text;
      });
    }
  }


}
