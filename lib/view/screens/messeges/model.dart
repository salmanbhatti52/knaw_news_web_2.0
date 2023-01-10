import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

class $BaseModel {
  @JsonKey(name: 'id')
  int? id;
}

class BaseModelHive extends HiveObject {
  @HiveField(0)
  @JsonKey(name: 'id')
  String? id;
}