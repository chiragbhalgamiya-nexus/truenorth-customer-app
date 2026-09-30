import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/profile_service.dart';
import 'dio_provider.dart';

final profileServiceProvider = Provider<ProfileService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return ProfileService(dioClient);
});

final profileProvider = FutureProvider<User>((ref) async {
  final profileService = ref.watch(profileServiceProvider);
  return await profileService.getProfile();
});

class ProfileNotifier extends AsyncNotifier<User> {
  late ProfileService _profileService;

  @override
  Future<User> build() async {
    _profileService = ref.watch(profileServiceProvider);
    return await _profileService.getProfile();
  }

  Future<void> updateProfile({
    required String name,
    required String email,
    String? phone,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await _profileService.updateProfile(
        name: name,
        email: email,
        phone: phone,
      );
    });
  }

  Future<void> changePassword({
    required String currentPassword,
    required String password,
    required String passwordConfirmation,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _profileService.changePassword(
        currentPassword: currentPassword,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      return await _profileService.getProfile();
    });
  }
}

final profileNotifierProvider = AsyncNotifierProvider<ProfileNotifier, User>(
  () => ProfileNotifier(),
);
