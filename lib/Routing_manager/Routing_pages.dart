
import 'package:go_router/go_router.dart';
import 'package:attempt_with_kimchi/Screens/logIn.dart';
import 'package:attempt_with_kimchi/Screens/Registration.dart';
import 'package:attempt_with_kimchi/Screens/Forgot_pass.dart';
import 'package:attempt_with_kimchi/Screens/HomePage.dart';
import '../Shared_Preferance_Manager/Shared_preferance.dart';

// --- Route names ---
class AppRoutes {
  static const home = '/';
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
}

// --- GoRouter config ---
final goRouter = GoRouter(
  initialLocation: AppRoutes.login,
  redirect: (context, state) {
    final loggedIn = SharedPreserance.isLoggedInSync;
    final isAuthRoute = state.matchedLocation == AppRoutes.login ||
        state.matchedLocation == AppRoutes.register ||
        state.matchedLocation == AppRoutes.forgotPassword;

    // If logged in & on auth route → go home
    if (loggedIn && isAuthRoute) return AppRoutes.home;

    // If NOT logged in & on home → go to login
    if (!loggedIn && state.matchedLocation == AppRoutes.home) {
      return AppRoutes.login;
    }

    return null; // no redirect
  },
  routes: [
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: AppRoutes.login,
      name: 'login',
      builder: (context, state) => const loginPage(),
    ),
    GoRoute(
      path: AppRoutes.register,
      name: 'register',
      builder: (context, state) => const RegistrationPage(),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      name: 'forgot-password',
      builder: (context, state) => const ForgotPassPage(),
    ),
  ],
);
