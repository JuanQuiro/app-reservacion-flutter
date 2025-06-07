import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:form_validator/form_validator.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../routes/app_pages.dart';
import '../controllers/auth_controller.dart';

class ForgotPasswordPage extends GetView<AuthController> {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperar contraseña'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Ilustración y título
                const SizedBox(height: 32),
                Icon(
                  Icons.lock_reset_rounded,
                  size: 80,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(height: 24),
                Text(
                  '¿Olvidaste tu contraseña?',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Ingresa tu correo electrónico y te enviaremos un enlace para restablecer tu contraseña.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Campo de correo electrónico
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Correo electrónico',
                    prefixIcon: const Icon(Icons.email_outlined),
                    hintText: 'ejemplo@dominio.com',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: ValidationBuilder()
                      .required('El correo es requerido')
                      .email('Ingresa un correo válido')
                      .build(),
                ),
                const SizedBox(height: 32),

                // Botón de enviar enlace
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      // TODO: Implementar lógica de recuperación de contraseña
                      Get.snackbar(
                        'Enlace enviado',
                        'Hemos enviado un enlace a tu correo para restablecer tu contraseña',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.green.shade100,
                        colorText: Colors.green.shade800,
                      );
                      Future.delayed(const Duration(seconds: 2), () {
                        Get.offAllNamed(Routes.login);
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Enviar enlace'),
                ),
                const SizedBox(height: 16),

                // Enlace a inicio de sesión
                TextButton(
                  onPressed: () => Get.offAllNamed(Routes.login),
                  child: const Text('Volver al inicio de sesión'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
