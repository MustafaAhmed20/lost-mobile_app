import 'package:json_annotation/json_annotation.dart';

import 'package:lost/models/car.dart';
import 'package:lost/models/person.dart';

part 'accident.g.dart';

@JsonSerializable(explicitToJson: true)
class Accident {
  int id;

  // cars involved in this accident
  List<Car> cars;

  // persons involved in this accident
  List<Person> persons;

  Accident({this.id, this.cars, this.persons});

  factory Accident.fromJson(Map<String, dynamic> json) =>
      _$AccidentFromJson(json);

  Map<String, dynamic> toJson() => _$AccidentToJson(this);
}
