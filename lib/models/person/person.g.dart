// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Person _$PersonFromJson(Map<String, dynamic> json) {
  return Person(
    id: json['id'] as int,
    name: json['name'] as String,
    ageId: json['age_id'] as int,
    gender: json['gender'] as String,
    skin: json['skin'] as int,
    shelter: json['shelter'] as bool,
  );
}

Map<String, dynamic> _$PersonToJson(Person instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'age_id': instance.ageId,
      'gender': instance.gender,
      'skin': instance.skin,
      'shelter': instance.shelter,
    };

Age _$AgeFromJson(Map<String, dynamic> json) {
  return Age(
    id: json['id'] as int,
    minAge: json['min_age'] as int,
    maxAge: json['max_age'] as int,
  );
}

Map<String, dynamic> _$AgeToJson(Age instance) => <String, dynamic>{
      'id': instance.id,
      'min_age': instance.minAge,
      'max_age': instance.maxAge,
    };
