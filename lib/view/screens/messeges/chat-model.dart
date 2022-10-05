

import 'package:json_annotation/json_annotation.dart';
import 'package:knaw_news/view/screens/messeges/model.dart';

part 'chat-model.g.dart';


@JsonSerializable(includeIfNull: false)
class StartChatModel extends BaseModelHive{
  @JsonKey(name:'user_name')
  String? userName;
  @JsonKey(name:'profile_picture')
  String? profilePicture;

StartChatModel({this.profilePicture,this.userName});

  Map<String, dynamic> toJson() => _$StartChatModelToJson(this);
  factory StartChatModel.fromJson(json) => _$StartChatModelFromJson(json);

}


@JsonSerializable(includeIfNull: false)

class GetMessagesModel extends BaseModelHive
{

String? status;
GetMessages? data;
GetMessagesModel({this.status,this.data});
Map<String, dynamic> toJson() => _$GetMessagesModelToJson(this);
factory GetMessagesModel.fromJson(json) => _$GetMessagesModelFromJson(json);
}


@JsonSerializable(includeIfNull: false)
class GetMessages extends BaseModelHive
{
  String? date;
  int? userId;
  String? time;
  String? msgType;
  String? message;
  String? profile_pic;
  GetMessages({this.message,this.date,this.msgType,this.profile_pic,this.time,this.userId});
  Map<String, dynamic> toJson() => _$GetMessagesToJson(this);
  factory GetMessages.fromJson(json) => _$GetMessagesFromJson(json);
}


@JsonSerializable(includeIfNull: false)
class GetAllChats extends BaseModelHive
{
  int? badge;
  String? time;
  String? msg_time;
  String? message;
  String? msgType;
  String? name;
  int? user_id;
  String? profile_pic;
  GetAllChats({this.message,this.time,this.profile_pic,this.msgType,this.badge,this.msg_time,this.name,this.user_id});
  Map<String, dynamic> toJson() => _$GetAllChatsToJson(this);
  factory GetAllChats.fromJson(json) => _$GetAllChatsFromJson(json);
}






