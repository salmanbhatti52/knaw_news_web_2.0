import 'package:flutter/material.dart';
import 'package:knaw_news/model/post_model.dart';
import 'package:knaw_news/view/base/web_menu_bar.dart';
import 'package:knaw_news/view/screens/home/widget/full_transition.dart';


class RecentPost extends StatefulWidget {
  PostDetail postDetail;
  RecentPost({Key? key,required this.postDetail}) : super(key: key);

  @override
  _RecentPostState createState() => _RecentPostState();
}

class _RecentPostState extends State<RecentPost> {
  PostDetail postDetail=PostDetail();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    double mediaWidth=size.width;
    mediaWidth/=2;
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        //backgroundColor: Color(0XFFF8F8FA),
        appBar: WebMenuBar(context: context,isAuthenticated: true,isHalf: true,),
        body: Center(
          child: Container(
            width: mediaWidth,
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: FullTransition(postDetail: widget.postDetail),
            ),
          ),
        ),
      ),
    );
  }
}
