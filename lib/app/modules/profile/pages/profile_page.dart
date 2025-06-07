import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_theme.dart';
import '../controllers/profile_controller.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        actions: [
          Obx(() => IconButton(
                icon: Icon(
                  controller.isEditing.value ? Icons.close : Icons.edit,
                ),
                onPressed: controller.toggleEditMode,
              )),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Avatar y nombre
              _buildProfileHeader(),
              const SizedBox(height: 32),

              // Formulario de perfil
              _buildProfileForm(),
              const SizedBox(height: 24),

              // Botón de guardar (solo visible en modo edición)
              Obx(() => controller.isEditing.value
                  ? ElevatedButton(
                      onPressed: controller.isLoading.value ? null : controller.saveProfile,
                      child: controller.isLoading.value
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text('Guardar Cambios'),
                    )
                  : const SizedBox.shrink()),
              const SizedBox(height: 16),

              // Botón de cerrar sesión
              OutlinedButton.icon(
                onPressed: () => _showLogoutConfirmation(context),
                icon: const Icon(Icons.logout, size: 20),
                label: const Text('Cerrar Sesión'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
              const SizedBox(height: 24),

              // Información adicional
              _buildAppInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        // Avatar
        Obx(() {
          final name = controller.nameController.text;
          final initials = name.isNotEmpty
              ? name.split(' ').map((e) => e[0]).take(2).join().toUpperCase()
              : 'U';

          return CircleAvatar(
            radius: 50,
            backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
            child: Text(
              initials,
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
          );
        }),
        const SizedBox(height: 16),
        Obx(
          () => Text(
            controller.nameController.text,
            style: Get.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Usuario Premium',
          style: Get.textTheme.bodyMedium?.copyWith(
            color: AppTheme.primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileForm() {
    return Obx(() => AbsorbPointer(
          absorbing: !controller.isEditing.value,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nombre
              Text(
                'Información Personal',
                style: Get.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller.nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre Completo',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Correo electrónico
              TextFormField(
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Correo Electrónico',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu correo';
                  }
                  if (!GetUtils.isEmail(value)) {
                    return 'Ingresa un correo válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Teléfono
              TextFormField(
                controller: controller.phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Teléfono',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu teléfono';
                  }
                  return null;
                },
              ),
            ],
          ),
        ));
  }

  Widget _buildAppInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const SizedBox(height: 16),
        Text(
          'Acerca de la Aplicación',
          style: Get.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.info_outline, size: 22),
          title: const Text('Versión'),
          trailing: Text(
            '1.0.0',
            style: Get.textTheme.bodyMedium,
          ),
          onTap: () {},
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.privacy_tip_outlined, size: 22),
          title: const Text('Política de Privacidad'),
          trailing: const Icon(Icons.chevron_right, size: 22),
          onTap: () {},
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.description_outlined, size: 22),
          title: const Text('Términos y Condiciones'),
          trailing: const Icon(Icons.chevron_right, size: 22),
          onTap: () {},
        ),
      ],
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              controller.logout();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }
}
