// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Operations _$OperationsFromJson(Map<String, dynamic> json) {
  return Operations(
    id: json['id'] as int,
    date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
    lat: (json['lat'] as num)?.toDouble(),
    lng: (json['lng'] as num)?.toDouble(),
    objectType: json['object_type'] as String,
    typeId: json['type_id'] as int,
    object: json['object'] == null
        ? null
        : Person.fromJson(json['object'] as Map<String, dynamic>),
    countryId: json['country_id'] as int,
    statusId: json['status_id'] as int,
  )
    ..details = json['details'] as String
    ..user = json['user'] == null
        ? null
        : Users.fromJson(json['user'] as Map<String, dynamic>);
}

Map<String, dynamic> _$OperationsToJson(Operations instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date?.toIso8601String(),
      'lat': instance.lat,
      'lng': instance.lng,
      'details': instance.details,
      'object_type': instance.objectType,
      'object': instance.object?.toJson(),
      'type_id': instance.typeId,
      'status_id': instance.statusId,
      'country_id': instance.countryId,
      'user': instance.user?.toJson(),
    };

TypeOperation _$TypeOperationFromJson(Map<String, dynamic> json) {
  return TypeOperation(
    json['id'] as int,
    json['name'] as String,
  );
}

Map<String, dynamic> _$TypeOperationToJson(TypeOperation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

StatusOperation _$StatusOperationFromJson(Map<String, dynamic> json) {
  return StatusOperation(
    id: json['id'] as int,
    name: json['name'] as String,
  );
}

Map<String, dynamic> _$StatusOperationToJson(StatusOperation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

Country _$CountryFromJson(Map<String, dynamic> json) {
  return Country(
    id: json['id'] as int,
    name: json['name'] as String,
    phoneCode: json['phone_code'] as int,
  )
    ..phoneLength = json['phone_length'] as int
    ..isoName = json['iso_name'] as String;
}

Map<String, dynamic> _$CountryToJson(Country instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone_code': instance.phoneCode,
      'phone_length': instance.phoneLength,
      'iso_name': instance.isoName,
    };
