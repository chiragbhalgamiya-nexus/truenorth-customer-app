import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/auth_response.dart';
import '../models/user_model.dart';
import '../config/app_config.dart';
import 'dio_client.dart';

class AuthService {
  final DioClient _dioClient;
  final FlutterSecureStorage _secureStorage;

  AuthService(this._dioClient, this._secureStorage);

  Future<AuthResponse> register({
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _dioClient.post(
        '/auth/register',
        data: {
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );

      if (response.statusCode == 201) {
        final authResponse = AuthResponse.fromJson(response.data);
        await _secureStorage.write(
          key: AppConfig.tokenStorageKey,
          value: authResponse.token,
        );
        await _secureStorage.write(
          key: AppConfig.userStorageKey,
          value: authResponse.user.id.toString(),
        );
        return authResponse;
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

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dioClient.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final authResponse = AuthResponse.fromJson(response.data);
        await _secureStorage.write(
          key: AppConfig.tokenStorageKey,
          value: authResponse.token,
        );
        await _secureStorage.write(
          key: AppConfig.userStorageKey,
          value: authResponse.user.id.toString(),
        );
        return authResponse;
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

  Future<void> logout() async {
    try {
      await _dioClient.post('/auth/logout');
    } finally {
      await _secureStorage.delete(key: AppConfig.tokenStorageKey);
      await _secureStorage.delete(key: AppConfig.userStorageKey);
    }
  }

  Future<String?> getStoredToken() async {
    return await _secureStorage.read(key: AppConfig.tokenStorageKey);
  }

  Future<void> clearToken() async {
    await _secureStorage.delete(key: AppConfig.tokenStorageKey);
    await _secureStorage.delete(key: AppConfig.userStorageKey);
  }
}
