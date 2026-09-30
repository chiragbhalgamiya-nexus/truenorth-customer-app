import 'package:dio/dio.dart';
import '../models/user_model.dart';
import 'dio_client.dart';

class ProfileService {
  final DioClient _dioClient;

  ProfileService(this._dioClient);

  Future<User> getProfile() async {
    try {
      final response = await _dioClient.get('/profile');
      if (response.statusCode == 200) {
        return User.fromJson(response.data);
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

  Future<User> updateProfile({
    required String name,
    required String email,
    String? phone,
  }) async {
    try {
      final response = await _dioClient.put(
        '/profile',
        data: {
          'name': name,
          'email': email,
          if (phone != null) 'phone': phone,
        },
      );
      if (response.statusCode == 200) {
        return User.fromJson(response.data);
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

  Future<void> changePassword({
    required String currentPassword,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _dioClient.put(
        '/profile/password',
        data: {
          'current_password': currentPassword,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );
      if (response.statusCode != 200) {
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
}
