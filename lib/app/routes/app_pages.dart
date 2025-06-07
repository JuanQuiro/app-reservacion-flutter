import 'package:get/get.dart';

// Páginas
import '../modules/auth/pages/login_page.dart';
import '../modules/auth/pages/register_page.dart';
import '../modules/auth/pages/forgot_password_page.dart';
import '../modules/home/pages/home_page.dart';
import '../modules/profile/pages/profile_page.dart';
import '../modules/appointments/pages/appointments_page.dart';
import '../modules/appointments/bindings/appointments_binding.dart';

class AppPages {
  static const initial = Routes.login;

  static final routes = [
    // Auth
    GetPage(
      name: Routes.login,
      page: () => LoginPage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.register,
      page: () => RegisterPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.forgotPassword,
      page: () => const ForgotPasswordPage(),
      transition: Transition.rightToLeft,
    ),
    
    // Home
    GetPage(
      name: Routes.home,
      page: () => const HomePage(),
      transition: Transition.fadeIn,
    ),
    
    // Profile
    GetPage(
      name: Routes.profile,
      page: () => const ProfilePage(),
      transition: Transition.rightToLeft,
    ),
    
    // Appointments
    GetPage(
      name: Routes.appointments,
      page: () => const AppointmentsPage(),
      binding: AppointmentsBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}

class Routes {
  // Auth
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  
  // Main
  static const home = '/home';
  static const profile = '/profile';
  static const appointments = '/appointments';
  
  // No encontrado
  static const notFound = '/not-found';
}
