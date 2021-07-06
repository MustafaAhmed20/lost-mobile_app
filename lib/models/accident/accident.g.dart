// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accident.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Accident _$AccidentFromJson(Map<String, dynamic> json) {
  return Accident(
    id: json['id'] as int,
    cars: (json['cars'] as List)
        ?.map((e) => e == null ? null : Car.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    persons: (json['persons'] as List)
        ?.map((e) =>
            e == null ? null : Person.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$AccidentToJson(Accident instance) => <String, dynamic>{
      'id': instance.id,
      'cars': instance.cars?.map((e) => e?.toJson())?.toList(),
      'persons': instance.persons?.map((e) => e?.toJson())?.toList(),
    };
