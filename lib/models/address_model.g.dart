// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_model.dart';

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
      id: json['id'] as int,
      street: json['street'] as String,
      apartment: json['apartment'] as String?,
      city: json['city'] as String,
      postalCode: json['postal_code'] as String,
      country: json['country'] as String,
      landmark: json['landmark'] as String?,
      isDefault: json['is_default'] as bool,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'id': instance.id,
      'street': instance.street,
      'apartment': instance.apartment,
      'city': instance.city,
      'postal_code': instance.postalCode,
      'country': instance.country,
      'landmark': instance.landmark,
      'is_default': instance.isDefault,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
