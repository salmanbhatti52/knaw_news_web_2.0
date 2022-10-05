// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emojis_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetEmojis _$GetEmojisFromJson(Map<String, dynamic> json) => GetEmojis(
      id: json['id'] as int?,
      path: json['path'] as String?,
      status: json['status'] as String?,
      categoryName: json['category_name'] as String?,
      isSelected: json['isSelected'] as bool?,
    );

Map<String, dynamic> _$GetEmojisToJson(GetEmojis instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('category_name', instance.categoryName);
  writeNotNull('path', instance.path);
  writeNotNull('isSelected', instance.isSelected);
  writeNotNull('status', instance.status);
  return val;
}
