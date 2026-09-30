import 'package:json_annotation/json_annotation.dart';

part 'address_model.g.dart';

@JsonSerializable()
class Address {
  final int id;
  final String street;
  final String? apartment;
  final String city;
  @JsonKey(name: 'postal_code')
  final String postalCode;
  final String country;
  final String? landmark;
  @JsonKey(name: 'is_default')
  final bool isDefault;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  Address({
    required this.id,
    required this.street,
    this.apartment,
    required this.city,
    required this.postalCode,
    required this.country,
    this.landmark,
    required this.isDefault,
    required this.createdAt,
    this.updatedAt,
  });

  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);
  Map<String, dynamic> toJson() => _$AddressToJson(this);

  Address copyWith({
    int? id,
    String? street,
    String? apartment,
    String? city,
    String? postalCode,
    String? country,
    String? landmark,
    bool? isDefault,
    String? createdAt,
    String? updatedAt,
  }) {
    return Address(
      id: id ?? this.id,
      street: street ?? this.street,
      apartment: apartment ?? this.apartment,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      landmark: landmark ?? this.landmark,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
