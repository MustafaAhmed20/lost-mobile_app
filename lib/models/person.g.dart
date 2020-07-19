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
    photos: (json['photos'] as List)
        ?.map((e) =>
            e == null ? null : Photos.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$PersonToJson(Person instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'age_id': instance.ageId,
      'photos': instance.photos?.map((e) => e?.toJson())?.toList(),
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

Photos _$PhotosFromJson(Map<String, dynamic> json) {
  return Photos(
    link: json['link'] as String,
  );
}

Map<String, dynamic> _$PhotosToJson(Photos instance) => <String, dynamic>{
      'link': instance.link,
    };
