
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ReportUserDialog extends StatefulWidget {
  void Function(String)? onUserReport;
  ReportUserDialog({Key? key,this.onUserReport}) : super(key: key);

  @override
  State<ReportUserDialog> createState() => _ReportUserDialogState();
}

class _ReportUserDialogState extends State<ReportUserDialog> {
  int selected=0;
  String reportType="";
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8)
      ),
      backgroundColor: Colors.white,
      child: Container(
        width: MediaQuery.of(context).size.width*0.3,
        height: 300,
        padding: EdgeInsets.only(right: 20,left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(child: Container()),
                Text("Report User",style: TextStyle(color: Colors.white)),
                Expanded(child: Container()),
                // InkWell(
                //   onTap: () => Get.back(),
                //   child: SvgPicture.asset(Images.close,color: KdullWhite,height: 15,width: 15,),
                // ),
              ],
            ),
            SizedBox(height: 20,),
            Text("Why you want to Report the user?",textAlign: TextAlign.center,style: TextStyle(color: Colors.black)),
            SizedBox(height: 20,),
            ReportCard(title: "Illegal Activity",isSeclected: selected==1,onTap: (){reportType="Illegal Activity";selected=1;setState(() {});widget.onUserReport!(reportType);}),
            SizedBox(height: 10,),
            ReportCard(title: "Spam",isSeclected: selected==2,onTap: (){reportType="Spam";selected=2;setState(() {});widget.onUserReport!(reportType);}),
            SizedBox(height: 10,),
            ReportCard(title: "Harassment or Bullying",isSeclected: selected==3,onTap: (){reportType="Harassment or Bullying";selected=3;setState(() {});widget.onUserReport!(reportType);}),
            SizedBox(height: 10,),
            ReportCard(title: "Hate Speech/Discrimination",isSeclected: selected==4,onTap: (){reportType="Hate Speech/Discrimination";selected=4;setState(() {});widget.onUserReport!(reportType);}),
            SizedBox(height: 10,),
            ReportCard(title: "Underage",isSeclected: selected==5,onTap: (){reportType="Underage";selected=5;setState(() {});widget.onUserReport!(reportType);}),
            SizedBox(height: 10,),
            ReportCard(title: "Impersonation",isSeclected: selected==6,onTap: (){reportType="Impersonation";selected=6;setState(() {});widget.onUserReport!(reportType);}),
          SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }
}



class ReportCard extends StatelessWidget {
  String title;
  bool isSeclected;
  void Function()? onTap;
  ReportCard({required this.title,this.isSeclected=false,this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child:Container(
          child: Row(
            children: [
              Icon(Icons.check_circle,color: isSeclected?Colors.amber:null,),
              SizedBox(width: 5,),
              Text(title,style: TextStyle(color:Colors.black) ),
            ],
          ),
        )
    );
  }
}