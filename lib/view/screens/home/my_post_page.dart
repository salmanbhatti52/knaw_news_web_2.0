import 'dart:io';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:knaw_news/mixin/data.dart';
import 'package:knaw_news/model/post_model.dart';
import 'package:knaw_news/services/dio_service.dart';
import 'package:knaw_news/util/dimensions.dart';
import 'package:knaw_news/util/images.dart';
import 'package:knaw_news/util/styles.dart';
import 'package:knaw_news/view/base/custom_image.dart';
import 'package:knaw_news/view/base/custom_snackbar.dart';
import 'package:knaw_news/view/base/loading_dialog.dart';
import 'package:knaw_news/view/screens/comment/comment.dart';
import 'package:knaw_news/view/screens/comment/web_comment.dart';
import 'package:knaw_news/view/screens/home/widget/report_dialog.dart';
import 'package:knaw_news/view/screens/home/widget/user_info.dart';
import 'package:knaw_news/view/screens/home/widget/vertical_tile.dart';
import 'package:like_button/like_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:translator/translator.dart';


class PostPage extends StatefulWidget {
  PostDetail? postDetail;
  PostPage({Key? key, this.postDetail,}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  bool isComment=false;
  bool isReadMore=false;
  List<PostDetail> postDetail = [];
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      translate();
    });
  }
  _launchURL(String _url) async {
    if (!await launch(_url)) throw 'Could not launch $_url';
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Wrap(
        children: [
          Container(
            width: MediaQuery.of(context).size.width*0.9,
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 5,
              spreadRadius: 1
          ),
        ]
    ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// User Detail
                UserInfo(postDetail: widget.postDetail,),

                /// Upper emoji list

                Container(
                  height: 75,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount:widget.postDetail!.uppercategories!.length,
                    itemBuilder: (context, index1) {
                      return  GestureDetector(
                        onTap: (){
                          // addEmojiToPost(widget.postDetail!.newsPostId,widget.postDetail!.uppercategories![index1].id);
                        },
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                SizedBox(height: 12,),
                                Container(
                                  child: Padding(
                                    padding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.02),
                                    child: SvgPicture.asset('assets/emojis/${widget.postDetail!.uppercategories![index1].path}',height: 29),
                                  ),
                                ),
                                SizedBox(height: 5,),
                                Text(widget.postDetail!.uppercategories![index1].count.toString(),style: TextStyle(color: Colors.black,fontSize: 14),),
                              ],
                            ),
                            Positioned(
                              top: 12,
                                left:26,
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: LikeButton(
                                  onTap: (value) async {
                                   await addEmojiToPost(widget.postDetail!.newsPostId,widget.postDetail!.uppercategories![index1].id);

                                    return !value;
                                  },
                                  animationDuration: Duration(seconds: 3),
                                  size: 30,
                                  likeBuilder: (isTapped){
                                    return Icon(Icons.circle, color: isTapped? Colors.transparent:Colors.transparent,);
                                  },
                                  circleSize: 0.0,
                                  circleColor: CircleColor(start: Colors.transparent, end: Colors.transparent),
                                ),
                              ),
                            ),
                          ],

                        ),
                      );
                    },
                  ),
                ),

                /// News Description
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.022),
                  child: Text(
                    widget.postDetail!.description!,
                    style: openSansRegular.copyWith(fontSize: Dimensions.fontSizeSmall,color: Colors.black,overflow: TextOverflow.fade),
                  ),
                ),

                    /// lower emoji list

                Container(
                  height: 75,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount:widget.postDetail!.lowercategories!.length,
                    itemBuilder: (context, index1) {
                      return  GestureDetector(
                        onTap: (){
                          addEmojiToPost(widget.postDetail!.newsPostId,widget.postDetail!.lowercategories![index1].id);
                        },
                       child: Stack(
                          children: [
                            Column(
                              children: [
                                SizedBox(height: 12,),
                                Container(
                                  child: Padding(
                                    padding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.025),
                                    child: SvgPicture.asset('assets/emojis/${widget.postDetail!.lowercategories![index1].path}',height: 29),
                                  ),
                                ),
                                SizedBox(height: 5,),
                                Text(widget.postDetail!.lowercategories![index1].count.toString(),style: TextStyle(color: Colors.black,fontSize: 14),)
                              ],
                            ),
                            Positioned(
                              top: 12,
                              left:33,
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: LikeButton(
                                  onTap: (value) async {
                                   await addEmojiToPost(widget.postDetail!.newsPostId,widget.postDetail!.lowercategories![index1].id);

                                    return !value;
                                  },
                                  animationDuration: Duration(seconds: 3),
                                  size: 30,
                                  likeBuilder: (isTapped){
                                    return Icon(Icons.circle,
                                      color: isTapped? Colors.transparent:Colors.transparent,
                                    );
                                  },
                                  circleSize: 0.0,
                                  circleColor: CircleColor(start: Colors.transparent, end: Colors.transparent),
                                ),
                              ),
                            ),
                          ],
                        ),

                      );
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  height: 1.3,
                  width: double.infinity,
                  color: Colors.grey.withOpacity(0.4),
                ),

                /// Action Bar
                Container(
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.03),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      VerticalTile(icon:  widget.postDetail!.isBookmarked=="true"?Images.bookmark_bold:Images.bookmark,
                        title: "",
                        onTap: (){
                          bookmarkPost();
                        },
                      ),
                      VerticalTile(icon: Images.comment, title: '(${ widget.postDetail!.totalComments.toString()})',isBlack: true,onTap: (){
                        //Get.bottomSheet(CommentScreen(postDetail: widget.postDetail,));
                        isComment=!isComment;
                        setState(() {

                        });
                      }),
                      InkWell(
                          onTap: () async {
                            Share.share(widget.postDetail!.description.toString());
                          },
                          child: Icon(Icons.share,size:25,color: Colors.grey.withOpacity(0.5),)),
                      InkWell(
                        onTap: () {
                          Get.dialog(ReportDialog(postDetail:  widget.postDetail));

                        },
                        child: Icon(Icons.info_outline,size: 25,color: Colors.grey.withOpacity(0.5),),
                      ),

                    ],
                  ),
                ),
                SizedBox(height: 5,),
              ],
            ),
          ),
          // Comments on post
          isComment?Container(child: GetPlatform.isDesktop?WebComment(postDetail: widget.postDetail,):CommentScreen(postDetail: widget.postDetail,)):SizedBox()
        ],
      ),
    );
  }
  void translate() async {
    var translation=await widget.postDetail!.title!.translate(to: AppData().language!.languageCode);
    var translator=await widget.postDetail!.description!.translate(to: AppData().language!.languageCode);
    if(mounted){
      widget.postDetail!.title=translation.text;
      widget.postDetail!.description=translator.text;
      setState(() {});
    }
  }
  Future<void> bookmarkPost() async {
    openLoadingDialog(context, "Loading");
    var response;
    response = await DioService.post('bookmark_news_post', {
      "newsPostId" : widget.postDetail!.newsPostId,
      "usersId" : AppData().userdetail!.usersId
    });
    if(response['status']=='success'){
      //print(postDetail![0].toJson());
      widget.postDetail!.isBookmarked=="true"?widget.postDetail!.isBookmarked="false":widget.postDetail!.isBookmarked="true";
      Navigator.pop(context);
      setState(() {

      });
      //showCustomSnackBar(response['data'],isError: false);
    }
    else{
      Navigator.pop(context);
      setState(() {

      });
      //showCustomSnackBar(response['message']);

    }
  }


  Future<void> viewPost() async {
    //openLoadingDialog(context, "Loading");
    var response;

    response = await DioService.post('view_post', {
      "usersId" : AppData().userdetail!.usersId,
      "newsPostId" : widget.postDetail!.newsPostId
    });
    if(response['status']=='success'){
      //Navigator.pop(context);
      setState(() {

      });
      //showCustomSnackBar(response['data'],isError: false);
    }
    else{
      //Navigator.pop(context);
      setState(() {

      });
      //showCustomSnackBar(response['message']);

    }
  }

  Future<void> addEmojiToPost(postID,cateID) async {
    // openLoadingDialog(context, "Loading");
    var response;
    var data = {
      "usersId" : AppData().userdetail!.usersId,
      "newsPostId": postID,
      "categoryId":cateID,
    };
    response = await DioService.post('add_emoji_to_post', data);
    print(response);
    print('--------------------------------------------');
    print(data);
    if(response['status']=='success'){
      setState(() {

      });
      // Navigator.pop(context);

    }
    else{
      setState(() {

      });
      // Navigator.pop(context);

    }
  }
  // Future<void> bookmarkPost(postId) async {
  //   openLoadingDialog(context, "Loading");
  //   var response;
  //   response = await DioService.post('bookmark_news_post', {
  //     "usersId" : AppData().userdetail!.usersId,
  //     "newsPostId" : postId,
  //
  //   });
  //   if(response['status']=='success'){
  //     //print(postDetail![0].toJson());
  //     // widget.postDetail!.isBookmarked=="true"?widget.postDetail!.isBookmarked="false":widget.postDetail!.isBookmarked="true";
  //     Navigator.pop(context);
  //     setState(() {
  //
  //     });
  //     print('book mark ---------------------');
  //     print(response);
  //     //showCustomSnackBar(response['data'],isError: false);
  //   }
  //   else{
  //     Navigator.pop(context);
  //     setState(() {
  //
  //     });
  //     //showCustomSnackBar(response['message']);
  //
  //   }
  // }
}
