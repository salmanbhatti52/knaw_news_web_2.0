import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:knaw_news/util/loading-builder.dart';

class ProfileImagePicker extends StatefulWidget {
  final String? previousImage;
  final Function (String)? onImagePicked;
  ProfileImagePicker({this.previousImage,this.onImagePicked});
  @override
  _ProfileImagePickerState createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends State<ProfileImagePicker> {
  PickedFile? pickedImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 62.0,
      height: 62.0,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.amber,width: 1)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: pickedImage == null ? (widget.previousImage!=null && widget.previousImage!.isNotEmpty)
            ? Image.network(widget.previousImage!,fit: BoxFit.cover, loadingBuilder: circularImageLoader,)
            :  Image.asset("assets/image/placeholder.jpg", fit: BoxFit.cover,
        )
            : Image.file(File(pickedImage!.path),fit: BoxFit.cover,)

      ),
    );
  }
}
