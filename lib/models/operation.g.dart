// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Operations _$OperationsFromJson(Map<String, dynamic> json) {
  return Operations(
    id: json['id'] as int,
    date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
    lat: json['lat'] as String,
    lng: json['lng'] as String,
    objectType: json['object_type'] as String,
    typeId: json['type_id'] as int,
    object: json['object'] == null
        ? null
        : Person.fromJson(json['object'] as Map<String, dynamic>),
    countryId: json['country_id'] as int,
    statusId: json['status_id'] as int,
  );
}

Map<String, dynamic> _$OperationsToJson(Operations instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date?.toIso8601String(),
      'lat': instance.lat,
      'lng': instance.lng,
      'object_type': instance.objectType,
      'object': instance.object?.toJson(),
      'type_id': instance.typeId,
      'status_id': instance.statusId,
      'country_id': instance.countryId,
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
  );
}

Map<String, dynamic> _$CountryToJson(Country instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone_code': instance.phoneCode,
    };
