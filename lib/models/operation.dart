import 'user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'operation.g.dart';

@JsonSerializable(explicitToJson: true)
class Operations {
  int id;

  DateTime date;

  @JsonKey(name: 'add_date')
  // UTC time
  DateTime addDate;

  // location
  double lat;
  double lng;
  // location as text
  String state;
  String city;

  String details;

  @JsonKey(name: 'object_type')
  String objectType;

  // this object will be loaded manually
  dynamic object;

  @JsonKey(name: 'type_id')
  int typeId;

  @JsonKey(name: 'status_id')
  int statusId;

  @JsonKey(name: 'country_id')
  int countryId;

  @JsonKey(name: 'user')
  Users user;

  List<String> photos;

  // the comments on this Operation - loaded manually
  @JsonKey(ignore: true)
  List<Comment> comments;

  Operations(
      {this.id,
      this.date,
      this.lat,
      this.lng,
      this.objectType,
      this.typeId,
      this.object,
      this.countryId,
      this.statusId,
      this.photos});

  factory Operations.fromJson(Map<String, dynamic> json) =>
      _$OperationsFromJson(json);

  Map<String, dynamic> toJson() => _$OperationsToJson(this);
}

@JsonSerializable()
class Comment {
  int id;

  @JsonKey(name: 'operation_id')
  int operationId;

  DateTime time;
  Users user;
  String text;

  Comment({
    this.id,
    this.operationId,
    this.time,
    this.user,
    this.text,
  });

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  Map<String, dynamic> toJson() => _$CommentToJson(this);
}

@JsonSerializable()
class TypeOperation {
  int id;

  String name;
  TypeOperation(this.id, this.name);

  factory TypeOperation.fromJson(Map<String, dynamic> json) =>
      _$TypeOperationFromJson(json);

  Map<String, dynamic> toJson() => _$TypeOperationToJson(this);
}

@JsonSerializable()
class StatusOperation {
  int id;

  String name;
  StatusOperation({this.id, this.name});

  factory StatusOperation.fromJson(Map<String, dynamic> json) =>
      _$StatusOperationFromJson(json);

  Map<String, dynamic> toJson() => _$StatusOperationToJson(this);
}

@JsonSerializable()
class Country {
  int id;
  String name;

  @JsonKey(name: 'phone_code')
  int phoneCode;

  @JsonKey(name: 'phone_length')
  int phoneLength;

  @JsonKey(name: 'iso_name')
  String isoName;

  Country({this.id, this.name, this.phoneCode});

  factory Country.fromJson(Map<String, dynamic> json) =>
      _$CountryFromJson(json);

  Map<String, dynamic> toJson() => _$CountryToJson(this);
}
