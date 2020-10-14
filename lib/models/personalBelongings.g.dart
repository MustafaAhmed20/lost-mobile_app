// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personalBelongings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonalBelongings _$PersonalBelongingsFromJson(Map<String, dynamic> json) {
  return PersonalBelongings(
    id: json['id'] as int,
    subtype: json['personal_belongings_subtype'] as int,
    type: json['personal_belongings_type'] as int,
  );
}

Map<String, dynamic> _$PersonalBelongingsToJson(PersonalBelongings instance) =>
    <String, dynamic>{
      'id': instance.id,
      'personal_belongings_type': instance.type,
      'personal_belongings_subtype': instance.subtype,
    };
