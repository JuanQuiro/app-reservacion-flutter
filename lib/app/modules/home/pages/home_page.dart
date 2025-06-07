import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';
import '../../auth/controllers/auth_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => controller.refreshAppointments(),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // AppBar personalizado
              SliverAppBar(
                backgroundColor: AppTheme.surfaceColor,
                elevation: 0,
                floating: true,
                pinned: false,
                title: GestureDetector(
                  onTap: () => _showUserMenu(context, authController),
                  child: Row(
                    children: [
                      // User Avatar
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                        child: const Icon(Icons.person, color: AppTheme.primaryColor),
                      ),
                      const SizedBox(width: 12),
                      // User Info
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() {
                            final userName = authController.userName.value;
                            return Text(
                              'Hola, ${userName.isNotEmpty ? userName : 'Usuario'}' ?? 'Hola',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          }),
                          const SizedBox(height: 2),
                          Text(
                            'Ver perfil',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.primaryColor,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: [
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.notifications_outlined,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              
              // Sección de bienvenida
              SliverToBoxAdapter(
                child: _buildWelcomeCard(context),
              ),
              
              // Sección de próximas citas
              SliverToBoxAdapter(
                child: _buildNextAppointmentsSection(context),
              ),
              
              // Calendario
              SliverToBoxAdapter(
                child: _buildCalendarSection(context),
              ),
              
              // Sección de acciones rápidas
              SliverToBoxAdapter(
                child: _buildQuickActionsSection(context),
              ),
              
              // Espacio al final
              const SliverToBoxAdapter(
                child: SizedBox(height: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Tarjeta de bienvenida
  void _showUserMenu(BuildContext context, AuthController authController) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    // User Avatar
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                      child: const Icon(Icons.person, size: 30, color: AppTheme.primaryColor),
                    ),
                    const SizedBox(width: 16),
                    // User Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() {
                            final userName = authController.userName.value;
                            return Text(
                              userName.isNotEmpty ? userName : 'Usuario',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            );
                          }),
                          const SizedBox(height: 4),
                          Text(
                            'Editar perfil',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Menu Items
              _buildMenuOption(
                context,
                icon: Icons.person_outline,
                title: 'Mi perfil',
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navegar a la pantalla de perfil
                },
              ),
              _buildMenuOption(
                context,
                icon: Icons.edit,
                title: 'Editar información',
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navegar a la pantalla de edición de perfil
                },
              ),
              _buildMenuOption(
                context,
                icon: Icons.camera_alt_outlined,
                title: 'Cambiar foto de perfil',
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implementar cambio de foto de perfil
                },
              ),
              _buildMenuOption(
                context,
                icon: Icons.settings_outlined,
                title: 'Configuración',
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navegar a la pantalla de configuración
                },
              ),
              const SizedBox(height: 8),
              // Cerrar sesión
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    authController.logout(); // Changed signOut to logout
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Cerrar sesión'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppTheme.primaryColor),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      minLeadingWidth: 0,
      horizontalTitleGap: 8,
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tienes ${controller.todayAppointments.length} citas para hoy',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No olvides revisar los detalles de tus próximas citas médicas.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Get.toNamed(Routes.appointments);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppTheme.primaryColor,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            ),
            child: const Text(
              'Ver mis citas',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // Sección de próximas citas
  Widget _buildNextAppointmentsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Próximas citas',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.toNamed(Routes.appointments);
                },
                child: const Text('Ver todas'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Obx(() {
            final upcoming = controller.getUpcomingAppointments();
            if (upcoming.isEmpty) {
              return _buildEmptyState(
                context,
                icon: Icons.calendar_today_outlined,
                title: 'Sin citas próximas',
                subtitle: 'No tienes citas programadas para los próximos días.',
              );
            }
            
            return SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: upcoming.length,
                itemBuilder: (context, index) {
                  final appointment = upcoming[index];
                  return _buildAppointmentCard(context, appointment);
                },
              ),
            );
          }),
        ],
      ),
    );
  }
  
  // Tarjeta de cita
  Widget _buildAppointmentCard(BuildContext context, Map<String, dynamic> appointment) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16, bottom: 16),
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Mostrar detalles de la cita
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(appointment['color'] as int).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getAppointmentIcon(appointment['type']),
                        color: Color(appointment['color'] as int),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appointment['title'],
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            appointment['doctor'],
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(appointment['status']).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getStatusText(appointment['status']),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: _getStatusColor(appointment['status']),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildInfoRow(
                      context,
                      icon: Icons.access_time_outlined,
                      text: DateFormat('HH:mm').format(appointment['date']),
                    ),
                    const SizedBox(width: 16),
                    _buildInfoRow(
                      context,
                      icon: Icons.calendar_today_outlined,
                      text: controller.formatDate(appointment['date']),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  context,
                  icon: Icons.location_on_outlined,
                  text: appointment['location'],
                  iconColor: AppTheme.textSecondary.withOpacity(0.7),
                  textColor: AppTheme.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  // Sección de calendario
  Widget _buildCalendarSection(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Calendario',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildCalendar(),
          ],
        ),
      ),
    );
  }
  
  // Calendario
  Widget _buildCalendar() {
    return TableCalendar(
      firstDay: DateTime.now().subtract(const Duration(days: 365)),
      lastDay: DateTime.now().add(const Duration(days: 365)),
      focusedDay: controller.focusedDay.value,
      calendarFormat: CalendarFormat.month,
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        leftChevronIcon: Icon(Icons.chevron_left, size: 24),
        rightChevronIcon: Icon(Icons.chevron_right, size: 24),
      ),
      calendarStyle: const CalendarStyle(
        todayDecoration: BoxDecoration(
          color: AppTheme.primaryColor,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: AppTheme.primaryColor,
          shape: BoxShape.circle,
        ),
        todayTextStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        selectedTextStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        weekendTextStyle: TextStyle(
          color: Colors.red,
        ),
      ),
      selectedDayPredicate: (day) {
        return isSameDay(controller.focusedDay.value, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        controller.focusedDay.value = focusedDay;
        controller.selectedDay.value = selectedDay.day;
      },
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, events) {
          final appointments = controller.getAppointmentsForDay(date);
          if (appointments.isEmpty) return null;
          
          return Positioned(
            right: 1,
            bottom: 1,
            child: Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: AppTheme.primaryColor,
                shape: BoxShape.circle,
              ),
            ),
          );
        },
      ),
    );
  }
  
  // Sección de acciones rápidas
  Widget _buildQuickActionsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Acciones rápidas',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  context,
                  icon: Icons.add_circle_outline,
                  label: 'Nuevo Turno',
                  color: 0xFF4CC9F0,
                  onTap: () {
                    // TODO: Implementar creación de nuevo turno
                    Get.toNamed(Routes.appointments);
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildActionCard(
                  context,
                  icon: Icons.history,
                  label: 'Historial',
                  color: 0xFF7209B7,
                  onTap: () {
                    // Navegar a la página de citas con un parámetro para mostrar el historial
                    Get.toNamed(
                      Routes.appointments,
                      arguments: {'showHistory': true},
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required int color,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).dividerColor.withOpacity(0.1),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(color).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: Color(color),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Método para construir una fila de información
  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String text,
    Color? iconColor,
    Color? textColor,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: iconColor ?? AppTheme.textSecondary,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: textColor ?? AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }
  
  // Helper method to get icon based on appointment type
  IconData _getAppointmentIcon(String type) {
    switch (type.toLowerCase()) {
      case 'doctor':
        return Icons.medical_services;
      case 'dentist':
        return Icons.medical_services_outlined;
      case 'beauty':
        return Icons.spa;
      default:
        return Icons.calendar_today;
    }
  }

  // Helper method to get status color
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Helper method to get status text
  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return 'Confirmado';
      case 'pending':
        return 'Pendiente';
      case 'cancelled':
        return 'Cancelado';
      default:
        return status;
    }
  }

  // Método para mostrar un estado vacío
  Widget _buildEmptyState(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 48,
            color: AppTheme.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
