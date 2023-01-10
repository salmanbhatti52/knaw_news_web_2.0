import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:knaw_news/model/comment_model.dart';
import 'package:knaw_news/util/app_constants.dart';
import 'package:knaw_news/util/dimensions.dart';
import 'package:knaw_news/util/images.dart';
import 'package:knaw_news/util/styles.dart';
import 'package:knaw_news/view/base/custom_image.dart';

class CommenterDetail extends StatelessWidget {
  CommentDetail? commentDetail;
  void Function()? replyTap;
  void Function()? onTapLike;
  void Function()? isReplyTap;
  CommenterDetail({this.commentDetail,this.replyTap,this.onTapLike,this.isReplyTap});

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            ClipOval(
              child: commentDetail!.commentProfilePicture == null || commentDetail!.commentProfilePicture == "" ?CustomImage(
                image: Images.placeholder,
                height: 30,
                width: 30,
                fit: BoxFit.cover,
              ):Image.network(
                AppConstants.proxyUrl+commentDetail!.commentProfilePicture!,
                width: 30,height: 30,fit: BoxFit.cover,
              ),
            ),
            commentDetail!.userVerified??false?Positioned(
              bottom: 0, right: 0,
              child: SvgPicture.asset(Images.badge,height: 10,width: 10,),
            ):SizedBox(),
          ],
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(commentDetail!.commentUserName??'',style: openSansBold.copyWith(color: Colors.black),),
            Text(commentDetail!.timeAgo??'',style: openSansRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall,color: Colors.black.withOpacity(0.5)),),
            Container(
                width: MediaQuery.of(context).size.width*0.75,
                child: Text(commentDetail!.comment??'',overflow: TextOverflow.ellipsis,maxLines: 50,style: openSansMedium.copyWith(fontSize: Dimensions.fontSizeSmall,color: Colors.black87),)
            ),
            SizedBox(height: 5,),
            Container(
              width: MediaQuery.of(context).size.width*0.75,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: onTapLike,
                    child: Row(
                      children: [
                        SvgPicture.asset(Images.heart,height: 11,width: 11,color: commentDetail!.isCommentLiked=="true"?Colors.red:Colors.grey,),
                        SizedBox(width: 10,),
                        //Icon(Icons.favorite,color: Colors.red,size: 15,),
                        Text(commentDetail!.commentLikes.toString(),style: openSansRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall,color: commentDetail!.isCommentLiked=="true"?Colors.black:Colors.grey),),
                      ],
                    ),
                  ),

                  GestureDetector(
                    onTap: isReplyTap,
                    child: Row(
                      children: [
                        SvgPicture.asset(Images.reply,height: 11,width: 11,color: Colors.grey,),
                        SizedBox(width: 10,),
                        Text("Reply",style: openSansRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall,color: Colors.black.withOpacity(0.5)),),
                      ],
                    ),
                  ),

                  commentDetail!.totalReplies!>1?InkWell(
                    onTap: replyTap,
                    child: Text("Views replies ("+commentDetail!.totalReplies.toString()+")",style: openSansRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall,color: Colors.black.withOpacity(0.5)),),
                  ):SizedBox(),

                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}

