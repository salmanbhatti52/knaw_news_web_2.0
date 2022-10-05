// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat-model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StartChatModel _$StartChatModelFromJson(Map<String, dynamic> json) =>
    StartChatModel(
      profilePicture: json['profile_picture'] as String?,
      userName: json['user_name'] as String?,
    )..id = json['id'] as String?;

Map<String, dynamic> _$StartChatModelToJson(StartChatModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('user_name', instance.userName);
  writeNotNull('profile_picture', instance.profilePicture);
  return val;
}

GetMessagesModel _$GetMessagesModelFromJson(Map<String, dynamic> json) =>
    GetMessagesModel(
      status: json['status'] as String?,
      data: json['data'] == null ? null : GetMessages.fromJson(json['data']),
    )..id = json['id'] as String?;

Map<String, dynamic> _$GetMessagesModelToJson(GetMessagesModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('status', instance.status);
  writeNotNull('data', instance.data);
  return val;
}

GetMessages _$GetMessagesFromJson(Map<String, dynamic> json) => GetMessages(
      message: json['message'] as String?,
      date: json['date'] as String?,
      msgType: json['msgType'] as String?,
      profile_pic: json['profile_pic'] as String?,
      time: json['time'] as String?,
      userId: json['userId'] as int?,
    )..id = json['id'] as String?;

Map<String, dynamic> _$GetMessagesToJson(GetMessages instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('date', instance.date);
  writeNotNull('userId', instance.userId);
  writeNotNull('time', instance.time);
  writeNotNull('msgType', instance.msgType);
  writeNotNull('message', instance.message);
  writeNotNull('profile_pic', instance.profile_pic);
  return val;
}

GetAllChats _$GetAllChatsFromJson(Map<String, dynamic> json) => GetAllChats(
      message: json['message'] as String?,
      time: json['time'] as String?,
      profile_pic: json['profile_pic'] as String?,
      msgType: json['msgType'] as String?,
      badge: json['badge'] as int?,
      msg_time: json['msg_time'] as String?,
      name: json['name'] as String?,
      user_id: json['user_id'] as int?,
    )..id = json['id'] as String?;

Map<String, dynamic> _$GetAllChatsToJson(GetAllChats instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('badge', instance.badge);
  writeNotNull('time', instance.time);
  writeNotNull('msg_time', instance.msg_time);
  writeNotNull('message', instance.message);
  writeNotNull('msgType', instance.msgType);
  writeNotNull('name', instance.name);
  writeNotNull('user_id', instance.user_id);
  writeNotNull('profile_pic', instance.profile_pic);
  return val;
}
