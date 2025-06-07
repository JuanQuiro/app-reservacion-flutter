import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController {
  // Estados
  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxString userName = ''.obs;
  
  // Almacenamiento local
  final _storage = GetStorage();
  
  // Claves para el almacenamiento local
  static const String _userNameKey = 'user_name';
  static const String _isLoggedInKey = 'is_logged_in';

  // Métodos
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Iniciar sesión
  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      
      // Simular una petición de red
      await Future.delayed(const Duration(seconds: 2));
      
      // TODO: Implementar lógica real de autenticación
      if (email.isNotEmpty && password.isNotEmpty) {
        // Simular datos del usuario
        final userEmail = email;
        final name = userEmail.split('@')[0];
        
        // Guardar datos de sesión
        await _storage.write(_isLoggedInKey, true);
        await _storage.write(_userNameKey, name);
        
        // Actualizar estado
        userName.value = name;
        
        // Navegar a la pantalla principal
        Get.offAllNamed('/home');
      } else {
        Get.snackbar(
          'Error',
          'Credenciales inválidas',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Ocurrió un error al iniciar sesión',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Registrar nuevo usuario
  Future<void> register(String name, String email, String password) async {
    try {
      isLoading.value = true;
      
      // Simular una petición de red
      await Future.delayed(const Duration(seconds: 2));
      
      // TODO: Implementar lógica real de registro
      if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty) {
        // Guardar datos de sesión
        await _storage.write(_isLoggedInKey, true);
        await _storage.write(_userNameKey, name);
        
        // Actualizar estado
        userName.value = name;
        
        // Navegar a la pantalla principal
        Get.offAllNamed('/home');
        
        Get.snackbar(
          '¡Bienvenido!',
          'Tu cuenta ha sido creada exitosamente',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Por favor completa todos los campos',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Ocurrió un error al registrar el usuario',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Enviar enlace para restablecer contraseña
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      isLoading.value = true;
      
      // Simular una petición de red
      await Future.delayed(const Duration(seconds: 2));
      
      // TODO: Implementar lógica real de recuperación de contraseña
      if (email.isNotEmpty && email.contains('@')) {
        return; // Éxito
      } else {
        throw Exception('Correo electrónico inválido');
      }
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
  // Método para cerrar sesión
  Future<void> logout() async {
    try {
      // Limpiar datos de sesión
      await _storage.remove(_isLoggedInKey);
      await _storage.remove(_userNameKey);
      
      // Resetear estado
      userName.value = '';
      
      // Navegar a la pantalla de login
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar(
        'Error',
        'Ocurrió un error al cerrar sesión',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  
  @override
  void onInit() {
    super.onInit();
    // Verificar si el usuario ya está autenticado
    _checkAuthStatus();
  }
  
  void _checkAuthStatus() {
    final isLoggedIn = _storage.read(_isLoggedInKey) ?? false;
    if (isLoggedIn) {
      userName.value = _storage.read(_userNameKey) ?? 'Usuario';
    }
  }
}
