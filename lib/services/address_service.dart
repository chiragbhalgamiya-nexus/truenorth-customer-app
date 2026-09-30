import 'package:dio/dio.dart';
import '../models/address_model.dart';
import 'dio_client.dart';

class AddressService {
  final DioClient _dioClient;

  AddressService(this._dioClient);

  Future<List<Address>> getAddresses() async {
    try {
      final response = await _dioClient.get('/addresses');
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final addressesList = (data['data'] as List)
            .map((e) => Address.fromJson(e as Map<String, dynamic>))
            .toList();
        return addressesList;
      }
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<Address> getAddressById(String id) async {
    try {
      final response = await _dioClient.get('/addresses/$id');
      if (response.statusCode == 200) {
        return Address.fromJson(response.data);
      }
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<Address> createAddress({
    required String street,
    required String city,
    required String postalCode,
    String country = 'CA',
    String? apartment,
    String? landmark,
    bool isDefault = false,
  }) async {
    try {
      final response = await _dioClient.post(
        '/addresses',
        data: {
          'street': street,
          'city': city,
          'postal_code': postalCode,
          'country': country,
          if (apartment != null) 'apartment': apartment,
          if (landmark != null) 'landmark': landmark,
          if (isDefault) 'is_default': isDefault,
        },
      );
      if (response.statusCode == 201) {
        return Address.fromJson(response.data);
      }
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<Address> updateAddress(
    String id, {
    required String street,
    required String city,
    required String postalCode,
    String country = 'CA',
    String? apartment,
    String? landmark,
  }) async {
    try {
      final response = await _dioClient.put(
        '/addresses/$id',
        data: {
          'street': street,
          'city': city,
          'postal_code': postalCode,
          'country': country,
          if (apartment != null && apartment.isNotEmpty) 'apartment': apartment,
          if (landmark != null && landmark.isNotEmpty) 'landmark': landmark,
        },
      );
      if (response.statusCode == 200) {
        return Address.fromJson(response.data);
      }
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<void> deleteAddress(String id) async {
    try {
      final response = await _dioClient.delete('/addresses/$id');
      if (response.statusCode != 204) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<Address> setDefaultAddress(String id) async {
    try {
      final response = await _dioClient.put('/addresses/$id/set-default');
      if (response.statusCode == 200) {
        return Address.fromJson(response.data);
      }
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    } on DioException catch (e) {
      rethrow;
    }
  }
}
