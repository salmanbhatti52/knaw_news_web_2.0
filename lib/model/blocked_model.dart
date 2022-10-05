import 'package:json_annotation/json_annotation.dart';
part 'blocked_model.g.dart';

@JsonSerializable(includeIfNull: false)
class BlockedUserModel {

  int? id;
  @JsonKey(name: 'blocked_user_id',)
  int? blockedUserId;
  @JsonKey(name: 'blocked_by_user_id',)
  int? blockedByUserId;
  String? status;
  @JsonKey(name: 'user_name',)
  String? blockedMemberUserName;
  @JsonKey(name: 'profile_picture',)
  String? blockedMemberProfilePicture;
  @JsonKey(name: 'is_online',)
  bool? isOnline;
  BlockedUserModel({this.blockedMemberUserName,this.blockedMemberProfilePicture,this.isOnline,this.blockedUserId,
  this.blockedByUserId,this.id,this.status});

  Map<String, dynamic> toJson() => _$BlockedUserModelToJson(this);
  factory BlockedUserModel.fromJson(json) => _$BlockedUserModelFromJson(json);
}

