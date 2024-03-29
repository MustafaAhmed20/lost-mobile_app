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
    object: json['object'],
    countryId: json['country_id'] as int,
    statusId: json['status_id'] as int,
    photos: (json['photos'] as List)?.map((e) => e as String)?.toList(),
    user: json['user'] == null
        ? null
        : Users.fromJson(json['user'] as Map<String, dynamic>),
  )
    ..addDate = json['add_date'] == null
        ? null
        : DateTime.parse(json['add_date'] as String)
    ..state = json['state'] as String
    ..city = json['city'] as String
    ..details = json['details'] as String;
}

Map<String, dynamic> _$OperationsToJson(Operations instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date?.toIso8601String(),
      'add_date': instance.addDate?.toIso8601String(),
      'lat': instance.lat,
      'lng': instance.lng,
      'state': instance.state,
      'city': instance.city,
      'details': instance.details,
      'object_type': instance.objectType,
      'object': instance.object,
      'type_id': instance.typeId,
      'status_id': instance.statusId,
      'country_id': instance.countryId,
      'user': instance.user?.toJson(),
      'photos': instance.photos,
    };

Comment _$CommentFromJson(Map<String, dynamic> json) {
  return Comment(
    id: json['id'] as int,
    operationId: json['operation_id'] as int,
    time: json['time'] == null ? null : DateTime.parse(json['time'] as String),
    user: json['user'] == null
        ? null
        : Users.fromJson(json['user'] as Map<String, dynamic>),
    text: json['text'] as String,
  );
}

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'operation_id': instance.operationId,
      'time': instance.time?.toIso8601String(),
      'user': instance.user,
      'text': instance.text,
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
