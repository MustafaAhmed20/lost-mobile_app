import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class Users {
  String publicId;

  String name;

  String phone;

  int permission;

  int status;

  Users({
    this.publicId,
    this.name,
    this.phone,
    this.permission,
    this.status,
  });
  factory Users.fromJson(Map<String, dynamic> json) => _$UsersFromJson(json);

  Map<String, dynamic> toJson() => _$UsersToJson(this);
}

@JsonSerializable()
class Status {
  int id;
  String name;

  Status({this.id, this.name});
  factory Status.fromJson(Map<String, dynamic> json) => _$StatusFromJson(json);

  Map<String, dynamic> toJson() => _$StatusToJson(this);
}

@JsonSerializable()
class Permission {
  int id;
  String name;
  Permission({this.id, this.name});
  factory Permission.fromJson(Map<String, dynamic> json) =>
      _$PermissionFromJson(json);

  Map<String, dynamic> toJson() => _$PermissionToJson(this);
}
