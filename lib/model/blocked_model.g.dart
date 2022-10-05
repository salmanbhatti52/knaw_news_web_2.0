// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blocked_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlockedUserModel _$BlockedUserModelFromJson(Map<String, dynamic> json) =>
    BlockedUserModel(
      blockedMemberUserName: json['user_name'] as String?,
      blockedMemberProfilePicture: json['profile_picture'] as String?,
      isOnline: json['is_online'] as bool?,
      blockedUserId: json['blocked_user_id'] as int?,
      blockedByUserId: json['blocked_by_user_id'] as int?,
      id: json['id'] as int?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$BlockedUserModelToJson(BlockedUserModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('blocked_user_id', instance.blockedUserId);
  writeNotNull('blocked_by_user_id', instance.blockedByUserId);
  writeNotNull('status', instance.status);
  writeNotNull('user_name', instance.blockedMemberUserName);
  writeNotNull('profile_picture', instance.blockedMemberProfilePicture);
  writeNotNull('is_online', instance.isOnline);
  return val;
}
