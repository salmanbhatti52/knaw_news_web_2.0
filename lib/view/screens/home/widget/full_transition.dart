import 'dart:ui';
import 'dart:html' as html;
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:knaw_news/api/auth.dart';
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
import 'package:knaw_news/view/screens/auth/web/web_sign_in.dart';
import 'package:knaw_news/view/screens/comment/comment.dart';
import 'package:knaw_news/view/screens/comment/web_comment.dart';
import 'package:knaw_news/view/screens/home/widget/report_dialog.dart';
import 'package:knaw_news/view/screens/home/widget/user_info.dart';
import 'package:knaw_news/view/screens/home/widget/vertical_tile.dart';
import 'package:like_button/like_button.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:expandable_text_widget/expandable_text_widget.dart';
import 'package:translator/translator.dart';



class FullTransition extends StatefulWidget {
  PostDetail? postDetail;
  FullTransition({Key? key, this.postDetail,}) : super(key: key);

  @override
  State<FullTransition> createState() => _FullTransitionState();
}

class _FullTransitionState extends State<FullTransition> {
  bool isComment=false;
  bool isReadMore=false;
  List<UpperCategories>? getUpperList;
  List<LowerCategories>? getLowerList;
  List<PostDetail> postDetail = [];
  _launchURL(String _url) async {
    html.window.open(_url, '_blank');
    //if (!await launch(_url,universalLinksOnly: true,forceWebView: true,enableJavaScript: true)) throw 'Could not launch $_url';
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      translate();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          width: MediaQuery.of(context).size.width*0.9,
          //padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.03),
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Detail
              UserInfo(postDetail: widget.postDetail,),

              /// Upper emoji list
              Container(
                height: 75,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.postDetail!.uppercategories!.length,
                  itemBuilder: (context, index1) {
                    return  GestureDetector(
                      onTap: (){
                        //   addEmojiToPost(postDetail[index].newsPostId,postDetail[index].uppercategories![index1].id);
                        // loadPosts(widget.cateID!);
                      },
                      child: Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width*0.055,
                            child: Column(
                              children: [
                                SizedBox(height: 12,),
                                Container(
                                  child: SvgPicture.asset('assets/emojis/${widget.postDetail!.uppercategories![index1].path}',height: 25),
                                ),
                                SizedBox(height: 5,),
                                Text(widget.postDetail!.uppercategories![index1].count.toString(),style: TextStyle(color: Colors.black,fontSize: 14),),

                              ],
                            ),
                          ),
                          Positioned(
                            top: 9,
                            left:23,
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: LikeButton(
                                onTap: (value) async {
                                  await addEmojiToPost(widget.postDetail!.newsPostId,widget.postDetail!.uppercategories![index1].id);

                                  return !value;
                                },
                                animationDuration: Duration(seconds: 5),
                                size: 30,
                                likeBuilder: (isTapped){
                                  return Icon(Icons.circle,
                                    color: isTapped? Colors.transparent:Colors.transparent,
                                  );
                                },
                                circleSize: 0.0,
                                circleColor: CircleColor(start: Colors.transparent, end: Colors.transparent),
                                // bubblesColor: BubblesColor(dotPrimaryColor: Colors.red, dotSecondaryColor: Colors.red),
                              ),
                            ),
                          ),

                        ],

                      ),
                    );
                  },
                ),
              ),
              // News Description
              Padding(
                padding: EdgeInsets.symmetric(horizontal: GetPlatform.isDesktop? MediaQuery.of(context).size.width*0.01: 5.0),
                child: Stack(
                  children: [
                    Text(
                      widget.postDetail!.description!,
                     style: openSansRegular.copyWith(fontSize: Dimensions.fontSizeSmall,color: Colors.black,overflow: TextOverflow.fade),
                    ),

                  ],
                ),
              ),
              Container(
                height: 75,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: widget.postDetail!.lowercategories!.length,
                  itemBuilder: (context, index2) {
                    return  GestureDetector(
                      onTap: (){
                        // addEmojiToPost(postDetail[index].newsPostId,postDetail[index].lowercategories![index2].id);
                        // loadEmojis(widget.cateID!);
                      },
                      child:Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width*0.064,
                            child: Column(
                              children: [
                                SizedBox(height: 12,),
                                Container(
                                  child: SvgPicture.asset('assets/emojis/${widget.postDetail!.lowercategories![index2].path}',height: 25),
                                ),
                                SizedBox(height: 5,),
                                Text(widget.postDetail!.lowercategories![index2].count.toString(),style: TextStyle(color: Colors.black,fontSize: 14),)
                              ],
                            ),
                          ),
                          Positioned(
                            top:9,
                            left:28,
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: LikeButton(
                                onTap: (value) async {
                                  await  addEmojiToPost(
                                      widget.postDetail!.newsPostId,
                                      widget.postDetail!.lowercategories![index2].id
                                  );

                                  return !value;
                                },
                                animationDuration: Duration(seconds: 5),
                                size: 30,
                                likeBuilder: (isTapped){
                                  return Icon(Icons.circle,
                                    color: isTapped? Colors.transparent:Colors.transparent,
                                  );
                                },
                                circleSize: 0.0,
                                circleColor: CircleColor(start: Colors.transparent, end: Colors.transparent),
                                // bubblesColor: BubblesColor(dotPrimaryColor: Colors.red, dotSecondaryColor: Colors.red),
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
                // margin: EdgeInsets.symmetric(vertical: 5),
                height: 1.3,
                width: double.infinity,
                color: Colors.grey.withOpacity(0.4),
              ),

              ///Post Image

              SizedBox(height: 8,),
              // Action Bar
              Container(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    VerticalTile(icon:  widget.postDetail!.isBookmarked=="true"?Images.bookmark_bold:Images.bookmark,
                      title: "",
                      onTap: (){
                        bookmarkPost(widget.postDetail!.newsPostId);
                      },
                    ),
                    VerticalTile(icon: Images.comment, title: '(${ widget.postDetail!.totalComments.toString()})',isBlack: true,
                        onTap: (){
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
            ],
          ),
        ),
         isComment?Container(child: GetPlatform.isDesktop?WebComment(postDetail: widget.postDetail,):CommentScreen(postDetail: widget.postDetail,)):SizedBox()

      ],
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

  Future<void> bookmarkPost(int? newsPostId) async {
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
      showCustomSnackBar(response['data'],isError: false);
    }
    else{
      Navigator.pop(context);
      setState(() {

      });
      showCustomSnackBar(response['message']);

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
    if(response['status']=='success'){
      setState(() {

      });
      // Navigator.pop(context);

    }
    else{
      // showCustomSnackBar('You cannot add more than three emoji to the post');
      setState(() {});
      // Navigator.pop(context);

    }
  }
}
