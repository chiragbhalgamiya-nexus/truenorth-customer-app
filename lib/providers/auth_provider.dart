import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/dio_client.dart';
import '../services/profile_service.dart';
import 'dio_provider.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  return AuthService(dioClient, secureStorage);
});

final profileServiceProvider = Provider<ProfileService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return ProfileService(dioClient);
});

class AuthNotifier extends AsyncNotifier<User?> {
  late AuthService _authService;
  late ProfileService _profileService;

  @override
  Future<User?> build() async {
    _authService = ref.watch(authServiceProvider);
    _profileService = ref.watch(profileServiceProvider);
    final secureStorage = ref.watch(secureStorageProvider);

    final token = await secureStorage.read(key: 'auth_token');
    if (token == null) {
      return null;
    }

    try {
      final user = await _profileService.getProfile();
      return user;
    } catch (e) {
      await secureStorage.delete(key: 'auth_token');
      await secureStorage.delete(key: 'auth_user');
      return null;
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final authResponse = await _authService.register(
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      return authResponse.user;
    });
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final authResponse = await _authService.login(
        email: email,
        password: password,
      );
      return authResponse.user;
    });
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _authService.logout();
      return null;
    });
  }
}

final authStateProvider = AsyncNotifierProvider<AuthNotifier, User?>(
  () => AuthNotifier(),
);
