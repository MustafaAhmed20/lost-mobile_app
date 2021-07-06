import 'package:json_annotation/json_annotation.dart';

part 'personalBelongings.g.dart';

@JsonSerializable()
class PersonalBelongings {
  int id;

  @JsonKey(name: 'personal_belongings_type')
  int type;

  @JsonKey(name: 'personal_belongings_subtype')
  int subtype;

  PersonalBelongings({this.id, this.subtype, this.type});

  factory PersonalBelongings.fromJson(Map<String, dynamic> json) =>
      _$PersonalBelongingsFromJson(json);

  Map<String, dynamic> toJson() => _$PersonalBelongingsToJson(this);
}
