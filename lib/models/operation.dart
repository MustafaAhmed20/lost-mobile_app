import 'person.dart';
import 'package:json_annotation/json_annotation.dart';

part 'operation.g.dart';

@JsonSerializable(explicitToJson: true)
class Operations {
  int id;

  DateTime date;

  String lat;
  String lng;

  @JsonKey(name: 'object_type')
  String objectType;

  Person object;

  @JsonKey(name: 'type_id')
  int typeId;

  @JsonKey(name: 'status_id')
  int statusId;

  @JsonKey(name: 'country_id')
  int countryId;

  Operations(
      {this.id,
      this.date,
      this.lat,
      this.lng,
      this.objectType,
      this.typeId,
      this.object,
      this.countryId,
      this.statusId});

  factory Operations.fromJson(Map<String, dynamic> json) =>
      _$OperationsFromJson(json);

  Map<String, dynamic> toJson() => _$OperationsToJson(this);
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

  Country({this.id, this.name, this.phoneCode});

  factory Country.fromJson(Map<String, dynamic> json) =>
      _$CountryFromJson(json);

  Map<String, dynamic> toJson() => _$CountryToJson(this);
}
