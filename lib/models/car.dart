import 'package:json_annotation/json_annotation.dart';

part 'car.g.dart';

@JsonSerializable()
class Car {
  int id;

  // the type of the car (large - small) - range (1-5)
  int type;

  // Plate Number of the car (numbers - letters)
  @JsonKey(name: 'plate_number_numbers')
  String plateNumberNumbers;

  @JsonKey(name: 'plate_number_letters')
  String plateNumberLettrs;

  String brand;

  String modle;

  Car(
      {this.id,
      this.type,
      this.plateNumberLettrs,
      this.plateNumberNumbers,
      this.brand,
      this.modle});

  factory Car.fromJson(Map<String, dynamic> json) => _$CarFromJson(json);

  Map<String, dynamic> toJson() => _$CarToJson(this);
}
