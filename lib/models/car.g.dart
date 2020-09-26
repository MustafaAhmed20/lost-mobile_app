// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Car _$CarFromJson(Map<String, dynamic> json) {
  return Car(
    id: json['id'] as int,
    type: json['type'] as int,
    plateNumberLettrs: json['plate_number_letters'] as String,
    plateNumberNumbers: json['plate_number_numbers'] as String,
    brand: json['brand'] as String,
    model: json['model'] as String,
  );
}

Map<String, dynamic> _$CarToJson(Car instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'plate_number_numbers': instance.plateNumberNumbers,
      'plate_number_letters': instance.plateNumberLettrs,
      'brand': instance.brand,
      'model': instance.model,
    };
