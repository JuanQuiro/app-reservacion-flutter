import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:form_validator/form_validator.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../routes/app_pages.dart';
import '../controllers/auth_controller.dart';

class RegisterPage extends GetView<AuthController> {
  RegisterPage({Key? key}) : super(key: key) {
    // Ensure the controller is properly initialized
    Get.put(AuthController(), permanent: true);
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear cuenta'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo y título
                const SizedBox(height: 16),
                Icon(
                  Icons.person_add_alt_1_rounded,
                  size: 80,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(height: 16),
                Text(
                  'Crear cuenta',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Campo de nombre completo
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Nombre completo',
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: ValidationBuilder()
                      .required('El nombre es requerido')
                      .minLength(3, 'Mínimo 3 caracteres')
                      .build(),
                ),
                const SizedBox(height: 16),

                // Campo de correo electrónico
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Correo electrónico',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: ValidationBuilder()
                      .required('El correo es requerido')
                      .email('Ingresa un correo válido')
                      .build(),
                ),
                const SizedBox(height: 16),

                // Campo de contraseña
                Obx(
                  () => TextFormField(
                    controller: passwordController,
                    obscureText: !controller.isPasswordVisible.value,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isPasswordVisible.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: ValidationBuilder()
                        .required('La contraseña es requerida')
                        .minLength(6, 'Mínimo 6 caracteres')
                        .build(),
                  ),
                ),
                const SizedBox(height: 16),

                // Campo de confirmar contraseña
                Obx(
                  () => TextFormField(
                    controller: confirmPasswordController,
                    obscureText: !controller.isPasswordVisible.value,
                    decoration: InputDecoration(
                      labelText: 'Confirmar contraseña',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value != passwordController.text) {
                        return 'Las contraseñas no coinciden';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 32),

                // Botón de registro
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      // TODO: Implementar lógica de registro
                      Get.offAllNamed(Routes.home);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Crear cuenta'),
                ),
                const SizedBox(height: 16),

                // Enlace a inicio de sesión
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('¿Ya tienes una cuenta? '),
                    TextButton(
                      onPressed: () {
                        // Usar Get.offAllNamed con el binding para asegurar la inicialización
                        Get.offAllNamed(
                          Routes.login,
                          arguments: {'fromRegister': true},
                        );
                      },
                      child: const Text('Inicia sesión'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
