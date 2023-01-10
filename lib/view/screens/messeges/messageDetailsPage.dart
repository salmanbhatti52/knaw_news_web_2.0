import 'dart:async';


import 'package:flutter/material.dart';
import 'package:knaw_news/mixin/data.dart';
import 'package:knaw_news/services/dio_service.dart';
import 'package:knaw_news/view/base/comment-textfield.dart';
import 'package:knaw_news/view/base/loading_dialog.dart';
import 'package:knaw_news/view/base/profile-image-picker.dart';
import 'package:knaw_news/view/screens/messeges/chat-model.dart';

class MessageDetailsPage extends StatefulWidget {
 final  String? profilePic;
 final int? otherUserChatId;
 final String? userName;

  const MessageDetailsPage({Key? key, this.profilePic,this.otherUserChatId, this.userName, }) : super(key: key);

  @override
  State<MessageDetailsPage> createState() => _MessageDetailsPageState();
}

class _MessageDetailsPageState extends State<MessageDetailsPage> {
    TextEditingController message=TextEditingController();
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    Timer? timer;
    StartChatModel? chat;
    List<GetMessages> messages=[];
    late FocusNode myFocusNode;
    bool isEmojiShown=false;
    ScrollController _controller = ScrollController();


   Future sendMessage() async{
     if(isEmojiShown)
       isEmojiShown=false;
     setState(() {});
     if(message.text.isEmpty)
      return ;
      else{
       print(message.text);
       //openLoadingDialog(context, 'sending');
       await startChat();
       var response;
       try{
         response   = await  DioService.post("chat", {
           "userId" : AppData().userdetail!.usersId,
           "otherUserId" : widget.otherUserChatId,
           "content" :      message.text,
           "messageType" : "text",
           "sendingTime" :  "",
           "requestType" : "sendMessage"
         });
         print(response);
         //Navigator.of(context).pop();
         FocusManager.instance.primaryFocus!.unfocus();
         message.clear();
         _controller.animateTo(_controller.position.maxScrollExtent, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
         // Timer(Duration(milliseconds: 500),() => _controller.jumpTo(_controller.position.maxScrollExtent));
         setState(() {});
       }
       catch(e) {
        // showErrorToast(e.toString());
         print(response);
       }
     }
   }

  Future startChat() async {
    try{
      var response = await DioService.post('chat', {
        "otherUserId": widget.otherUserChatId,
        "userId": AppData().userdetail!.usersId,
        "requestType": "startChat"
      });
      var userDetail= response['data'];

      chat = StartChatModel.fromJson(userDetail);
      setState(() {});
    }
    catch(e){
      Navigator.of(context).pop();
     // showSuccessToast(e.toString());
    }
  }

  Future getMessages() async {
      var response;
      try{
         response = await DioService.post('chat', {
          "otherUserId": widget.otherUserChatId,
          "userId": AppData().userdetail!.usersId,
          "requestType": "getMessages"
        });

        var messagesDetail= response['data'] as List;
        messages =  messagesDetail.map<GetMessages>((e) => GetMessages.fromJson(e)).toList();
        print("messages");
        print(messages.toList());
       //  Navigator.of(context).pop();
        print("messages");
        setState(() {});
      }
      catch(e){
       // Navigator.of(context).pop();
     //   showErrorToast(response['message']);
      }
    }

  @override
    void initState() {
      // TODO: implement initState
      super.initState();
       myFocusNode = FocusNode();
      timer = Timer.periodic(Duration(seconds: 1), (Timer t) =>  getMessages());
    //   WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
    //     openLoadingDialog(context, "loading...");
    //
    //   // getMessages();
    // });
    }
  @override
  void dispose() {
    myFocusNode.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    double mediaWidth=size.width<1000?size.width:size.width*0.7;
    return Scaffold(
      backgroundColor: Color(0xfff6f6f6),

      body: Center(
        child: Container(
          width: mediaWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: mediaWidth,
                height: 45,
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: ProfileImagePicker(
                              onImagePicked: (value){},
                              previousImage: widget.profilePic,
                            ),
                          ),
                          SizedBox(width: 10,),
                          Text(widget.userName.toString(), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold,)),
                          SizedBox(width: 35,),
                        ],
                      ),
                      SizedBox()
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    controller: _controller,
                    itemCount:messages.length,
                      itemBuilder: (context,index){
                        if(index == messages.length){
                          return Container(
                            height: 70,
                          );
                        }
                        if(index == 0){
                          _controller.animateTo(_controller.position.maxScrollExtent, duration: Duration(milliseconds: 1), curve: Curves.easeOut);
                          //cond++;
                        }
                      GetMessages message=messages[index];
                      print(message.userId);
                      bool isMe = message.userId == AppData().userdetail!.usersId;
                      print(isMe);
                    return Container(
                      decoration: BoxDecoration(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if(message.date!.isNotEmpty)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(message.date! , style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.grey.shade500,)),
                            ],
                          ),
                 isMe   ? Container(
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                          child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Flexible(
                              flex: 1,
                              child: Container(
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(message.message!, style: TextStyle(color: Colors.black, fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ):
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(
                                flex: 1,
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(message.message ?? "", style: TextStyle(color: Colors.black, fontSize: 14,
                                  ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ],
                      ),
                    );
                  }),
                )
              ),

              EventCommentTextField(
                onSubmitted: (value) {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    sendMessage();
                  }
                },
                    onTapEmoji: (){
                    FocusScopeNode currentFocus = FocusScope.of(context);
                     if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                      isEmojiShown=!isEmojiShown;
                      setState(() {});
                    },
                    onTap: (){
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                       currentFocus.unfocus();
                    }
                     if(isEmojiShown)
                      isEmojiShown=false;
                      setState(() {});
                    },
                    controller: message,
                    onTapIcon: () => sendMessage(),
                    focusNode: myFocusNode,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}


