// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Users _$UsersFromJson(Map<String, dynamic> json) {
  return Users(
    publicId: json['id'] as String,
    name: json['name'] as String,
    phone: json['phone'] as String,
    permission: json['permission'] as int,
    status: json['status'] as int,
  );
}

Map<String, dynamic> _$UsersToJson(Users instance) => <String, dynamic>{
      'id': instance.publicId,
      'name': instance.name,
      'phone': instance.phone,
      'permission': instance.permission,
      'status': instance.status,
    };

Status _$StatusFromJson(Map<String, dynamic> json) {
  return Status(
    id: json['id'] as int,
    name: json['name'] as String,
  );
}

Map<String, dynamic> _$StatusToJson(Status instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

Permission _$PermissionFromJson(Map<String, dynamic> json) {
  return Permission(
    id: json['id'] as int,
    name: json['name'] as String,
  );
}

Map<String, dynamic> _$PermissionToJson(Permission instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
