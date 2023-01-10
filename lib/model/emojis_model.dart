import 'package:json_annotation/json_annotation.dart';
part 'emojis_model.g.dart';
@JsonSerializable(includeIfNull: false)


class GetEmojis{

  int? id;
  @JsonKey(name: 'category_name',)
  String? categoryName;
  String? path;
  bool? isSelected=false;
  String? status;


  GetEmojis({this.id,this.path,this.status,this.categoryName,this.isSelected});

  Map<String, dynamic> toJson() => _$GetEmojisToJson(this);
  factory GetEmojis.fromJson(json) => _$GetEmojisFromJson(json);


}