import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'config/app_config.dart';
import 'providers/auth_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/profile_edit_screen.dart';
import 'screens/change_password_screen.dart';
import 'screens/addresses_list_screen.dart';
import 'screens/address_detail_screen.dart';
import 'screens/add_address_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/session_expired_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter _buildRouter(WidgetRef ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/profile-edit',
        name: 'profile-edit',
        builder: (context, state) => const ProfileEditScreen(),
      ),
      GoRoute(
        path: '/change-password',
        name: 'change-password',
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: '/addresses',
        name: 'addresses',
        builder: (context, state) => const AddressesListScreen(),
      ),
      GoRoute(
        path: '/addresses/add',
        name: 'add-address',
        builder: (context, state) => const AddAddressScreen(),
      ),
      GoRoute(
        path: '/addresses/:id',
        name: 'address-detail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return AddressDetailScreen(addressId: id);
        },
      ),
      GoRoute(
        path: '/addresses/:id/edit',
        name: 'address-edit',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return AddAddressScreen(addressId: id, isEdit: true);
        },
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/session-expired',
        name: 'session-expired',
        builder: (context, state) => const SessionExpiredScreen(),
      ),
    ],
    redirect: (context, state) async {
      final authState = ref.read(authStateProvider);
      final isLoggingIn = state.namedLocation('login').toString().contains(state.uri.toString()) || state.uri.toString() == '/login';
      final isRegisteringIn = state.uri.toString() == '/register';
      final isSplash = state.uri.toString() == '/';

      if (authState.when(
        data: (user) => user == null,
        loading: () => false,
        error: (err, st) => false,
      )) {
        if (isLoggingIn || isRegisteringIn || isSplash) {
          return null;
        }
        return '/login';
      }

      if (authState.when(
        data: (user) => user != null,
        loading: () => false,
        error: (err, st) => false,
      )) {
        if (isLoggingIn || isRegisteringIn) {
          return '/home';
        }
      }

      return null;
    },
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const storage = FlutterSecureStorage();
  final token = await storage.read(key: 'auth_token');
  runApp(ProviderScope(child: MyApp(hasToken: token != null)));
}

class MyApp extends ConsumerWidget {
  final bool hasToken;

  const MyApp({required this.hasToken, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = _buildRouter(ref);

    return MaterialApp.router(
      title: 'TrueNorth Customer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
