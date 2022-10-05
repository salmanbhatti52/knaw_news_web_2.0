import 'package:flutter/material.dart';
import 'package:knaw_news/mixin/data.dart';
import 'package:knaw_news/model/blocked_model.dart';
import 'package:knaw_news/services/dio_service.dart';
import 'package:knaw_news/util/images.dart';
import 'package:knaw_news/view/base/custom_image.dart';
import 'package:knaw_news/view/base/custom_snackbar.dart';
import 'package:knaw_news/view/base/loading_dialog.dart';
import 'package:knaw_news/view/screens/menu/appbar_with_back.dart';

import '../../../util/styles.dart';


class BlockedMembers extends StatefulWidget {
   BlockedMembers({Key? key}) : super(key: key);

  @override
  State<BlockedMembers> createState() => _BlockedMembersState();
}

class _BlockedMembersState extends State<BlockedMembers> {
  List<BlockedUserModel>? blockedMemberDetail=[];
  ScrollController scrollController=ScrollController();

  int totalMember=0;
  int? selectedIndex;
  bool isLoading=true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      blockedMembersList();
    });
  }
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    double mediaWidth =size.width<1000?size.width:size.width*0.5;
    return Scaffold(
      appBar: AppBarWithBack(title: 'Blocked Members',isTitle: true,isSuffix: false,),
      body: SafeArea(
        child: Center(
          child: Container(
              width: mediaWidth,
              child: ListView.builder(
                  controller: scrollController,
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: blockedMemberDetail!.length,
                  itemBuilder: (context,index){
                    return Column(
                      children: [
                        Container(
                          child: ListTile(
                            leading: Stack(
                              children: [
                                ClipOval(
                                  child: blockedMemberDetail![index].blockedMemberProfilePicture == null || blockedMemberDetail![index].blockedMemberProfilePicture == "" ?CustomImage(
                                    image: Images.placeholder,
                                    height: 45,
                                    width: 45,
                                    fit: BoxFit.cover,
                                  ):Image.network(blockedMemberDetail![index].blockedMemberProfilePicture.toString(),
                                    width: 45,height: 45,fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ),
                            title: Text(blockedMemberDetail![index].blockedMemberUserName??'',style: openSansBold.copyWith(color: Colors.black,),),
                            trailing: Container(
                              height: 30,
                              width: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.red
                              ),
                              child: GestureDetector(
                                onTap: (){
                                  unblockUser(blockedMemberDetail![index].blockedUserId);
                                },
                                child: Center(
                                  child: Text('Unblock',
                                    style: openSansSemiBold.copyWith(color: Colors.white),textAlign: TextAlign.center,)),),
                            ),
                          ),
                        ),
                        Container(
                          color: Theme.of(context).disabledColor.withOpacity(0.5),
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(vertical: 7,horizontal: 20),
                          height: 1.5,
                        ),
                      ],

                    );

                  }
              ),
            ),
        ),
        )
    );
  }
  void blockedMembersList() async{
    openLoadingDialog(context, "Loading");
    var response;
    response = await DioService.post('get_block_list', {
      "blockByUserId": AppData().userdetail!.usersId
    });
    if(response['status']=='success'){
       // totalMember=response['total_count'];
      var jsonData= response['data'] as List;
      blockedMemberDetail!.addAll(jsonData.map<BlockedUserModel>((e) => BlockedUserModel.fromJson(e)).toList());
      print(response);
      isLoading=false;
      setState(() {

      });
      Navigator.pop(context);
    }
    else{
      setState(() {

      });
      Navigator.pop(context);
    }

  }
  void unblockUser(blockUserId) async {
    openLoadingDialog(context, "Loading");
    var response;
    var data = {
      "blockedByUserId":AppData().userdetail!.usersId.toString(),
      "blockedUserId": blockUserId
    };
    print(data);
    response = await DioService.post('unblock_user', data);
    print(response);
    if(response['status']=='success'){
      showCustomSnackBar("Unblocked successfully");
      Navigator.pop(context);
    }
    else{
      Navigator.pop(context);
      print(response['message']);
      showCustomSnackBar(response['message']);
    }
  }
}
