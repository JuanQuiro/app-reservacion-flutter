import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:form_validator/form_validator.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../routes/app_pages.dart';
import '../controllers/auth_controller.dart';

class LoginPage extends GetView<AuthController> {
  LoginPage({Key? key}) : super(key: key) {
    // Asegurarse de que el controlador esté inicializado
    Get.put(AuthController(), permanent: true);
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo y título
              const SizedBox(height: 32),
              Icon(
                Icons.calendar_today_rounded,
                size: 80,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(height: 16),
              Text(
                'Bienvenido',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Inicia sesión para continuar',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).hintColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // Formulario de inicio de sesión
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Campo de correo electrónico
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Correo electrónico',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: ValidationBuilder()
                          .email('Ingresa un correo electrónico válido')
                          .required('El correo electrónico es requerido')
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
                        ),
                        validator: ValidationBuilder()
                            .minLength(6, 'Mínimo 6 caracteres')
                            .required('La contraseña es requerida')
                            .build(),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Enlace para recuperar contraseña
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Get.toNamed(Routes.forgotPassword);
                        },
                        child: const Text('¿Olvidaste tu contraseña?'),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Botón de inicio de sesión
                    Obx(
                      () => ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : () async {
                                if (formKey.currentState!.validate()) {
                                  await controller.login(
                                    emailController.text.trim(),
                                    passwordController.text,
                                  );
                                }
                              },
                        child: controller.isLoading.value
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text('Iniciar sesión'),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Enlace a registro
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '¿No tienes una cuenta?',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextButton(
                          onPressed: () {
                            Get.toNamed(Routes.register);
                          },
                          child: const Text('Regístrate'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
