import 'package:json_annotation/json_annotation.dart';

part 'person.g.dart';

@JsonSerializable(explicitToJson: true)
class Person {
  int id;

  String name;

  @JsonKey(name: 'age_id')
  int ageId;

  String gender;

  // skin color - range from (1 - 5)
  int skin;

  // if this person now is resident in shelter or some special place
  bool shelter;

  Person(
      {this.id, this.name, this.ageId, this.gender, this.skin, this.shelter});

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
