import 'package:json_annotation/json_annotation.dart';

part 'person.g.dart';

@JsonSerializable(explicitToJson: true)
class Person {
  int id;

  String name;

  @JsonKey(name: 'age_id')
  int ageId;

  List<String> photos;

  Person({this.id, this.name, this.ageId, this.photos});

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);

  Map<String, dynamic> toJson() => _$PersonToJson(this);
}

@JsonSerializable()
class Age {
  int id;

  @JsonKey(name: 'min_age')
  int minAge;

  @JsonKey(name: 'max_age')
  int maxAge;

  Age({this.id, this.minAge, this.maxAge});

  factory Age.fromJson(Map<String, dynamic> json) => _$AgeFromJson(json);

  Map<String, dynamic> toJson() => _$AgeToJson(this);
}
