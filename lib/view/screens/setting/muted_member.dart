import 'package:flutter/material.dart';
import 'package:knaw_news/mixin/data.dart';
import 'package:knaw_news/model/mute_model.dart';
import 'package:knaw_news/services/dio_service.dart';
import 'package:knaw_news/util/dimensions.dart';
import 'package:knaw_news/util/images.dart';
import 'package:knaw_news/view/base/custom_snackbar.dart';
import 'package:knaw_news/view/base/loading_dialog.dart';
import 'package:knaw_news/view/base/no_data_screen.dart';
import 'package:knaw_news/view/screens/menu/appbar_with_back.dart';
import 'package:knaw_news/view/screens/setting/widget/member_card.dart';

class MutedMember extends StatefulWidget {
  const MutedMember({Key? key}) : super(key: key);

  @override
  State<MutedMember> createState() => _MutedMemberState();
}

class _MutedMemberState extends State<MutedMember> {
  ScrollController scrollController=ScrollController();
  List<MutedMemberDetail>? mutedMemberDetail=[];
  int offset=0;
  int totalMember=0;
  int? selectedIndex;
  bool isLoading=true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController.addListener(_handleScroll);
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      mutedMembersList();
    });
  }
  void _handleScroll() {
    if(scrollController.position.pixels >= scrollController.position.maxScrollExtent){
      print("max scroll");
      if(totalMember>mutedMemberDetail!.length&&!isLoading) {
        offset+=10;
        mutedMembersList();
        isLoading=true;
      }
      else{
        print("Follower not avilable");
      }

    }
    else{
    }
  }
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    double mediaWidth =size.width<1000?size.width:size.width*0.5;
    return Scaffold(
      appBar: AppBarWithBack(title: AppData().language!.mutedMembers,isTitle: true,isSuffix: false,),
      //backgroundColor:Get.isDarkMode ? Colors.black : Colors.white,
      body: SafeArea(
        child: totalMember>0?Align(
          alignment: Alignment.topCenter,
          child: Container(
          width: mediaWidth,
          child: ListView.builder(
            controller: scrollController,
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              //padding: EdgeInsetsGeometry.infinity,
              itemCount: mutedMemberDetail!.length,
              itemBuilder: (context,index){
                return Column(
                  children: [
                    MuteMemberCard(mutedMemberDetail: mutedMemberDetail![index],onTapSuffix: (){
                      selectedIndex=index;
                      unMuteMember();
                    },),
                    Container(
                      color: Theme.of(context).disabledColor.withOpacity(0.5),
                      width: MediaQuery.of(context).size.width*0.9,
                      margin: EdgeInsets.symmetric(vertical: 7),
                      height: 1.5,
                    ),
                  ],

                );

              }
          ),
      ),
        ):Center(child: NoDataScreen(text: "No Muted Member Exist",)),),
    );
  }
  void mutedMembersList() async{
    openLoadingDialog(context, "Loading");
    var response;
    response = await DioService.post('get_muted_members', {
      "offset": offset,
      "userId": AppData().userdetail!.usersId
    });
    if(response['status']=='success'){
      totalMember=response['total_count'];
      var jsonData= response['data'] as List;
      mutedMemberDetail!.addAll(jsonData.map<MutedMemberDetail>((e) => MutedMemberDetail.fromJson(e)).toList());
      isLoading=false;
      setState(() {

      });
      print(mutedMemberDetail!.first.toJson());
      Navigator.pop(context);
    }
    else{
      setState(() {

      });
      Navigator.pop(context);
      //showCustomSnackBar(response['message']);
    }

  }
  void unMuteMember() async{
    openLoadingDialog(context, "Loading");
    var response;
    response = await DioService.post('unmute_member', {
      "muteUsersId": mutedMemberDetail![selectedIndex??0].mutedMemberId,
      "usersId": AppData().userdetail!.usersId

    });
    if(response['status']=='success'){

      mutedMemberDetail!.removeAt(selectedIndex??0);
      totalMember-=1;
      setState(() {

      });
      Navigator.pop(context);
      //showCustomSnackBar(response['data'],isError: false);
    }
    else{
      setState(() {

      });
      Navigator.pop(context);
      //showCustomSnackBar(response['message']);
    }

  }
}
