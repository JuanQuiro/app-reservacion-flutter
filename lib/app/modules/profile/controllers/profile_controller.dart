import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_theme.dart';
import '../../../routes/app_pages.dart';
import '../../auth/controllers/auth_controller.dart';

class ProfileController extends GetxController {
  // Controladores para los campos del formulario
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  
  // Clave para el formulario
  final formKey = GlobalKey<FormState>();
  
  // Estado para controlar la carga
  final RxBool isLoading = false.obs;
  final RxBool isEditing = false.obs;
  
  // Referencia al controlador de autenticación
  final AuthController authController = Get.find();
  
  @override
  void onInit() {
    super.onInit();
    // Cargar datos del perfil
    _loadProfileData();
  }
  
  // Cargar datos del perfil
  void _loadProfileData() {
    // En una aplicación real, aquí cargarías los datos del perfil desde tu API
    // Por ahora, usaremos el nombre de usuario del controlador de autenticación
    nameController.text = authController.userName.value;
    emailController.text = '${authController.userName.value.toLowerCase()}@example.com';
    phoneController.text = '+51 999 999 999';
  }
  
  // Alternar modo de edición
  void toggleEditMode() {
    isEditing.value = !isEditing.value;
    
    // Si se desactiva el modo de edición, restaurar los valores originales
    if (!isEditing.value) {
      _loadProfileData();
    }
  }
  
  // Guardar cambios del perfil
  Future<void> saveProfile() async {
    if (!formKey.currentState!.validate()) return;
    
    try {
      isLoading.value = true;
      
      // Simular guardado en el servidor
      await Future.delayed(const Duration(seconds: 2));
      
      // En una aplicación real, aquí actualizarías el perfil en tu API
      authController.userName.value = nameController.text;
      
      // Desactivar modo de edición
      isEditing.value = false;
      
      Get.snackbar(
        '¡Perfecto!',
        'Perfil actualizado correctamente',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.successColor,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo actualizar el perfil',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  // Cerrar sesión
  Future<void> logout() async {
    await authController.logout();
  }
  
  @override
  void onClose() {
    // Limpiar controladores
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
