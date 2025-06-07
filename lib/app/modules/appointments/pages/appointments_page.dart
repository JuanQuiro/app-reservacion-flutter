import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/theme/app_theme.dart';
import '../controllers/appointments_controller.dart';

// Extension for string capitalization
extension CustomStringExtension on String {
  String capitalizeFirstLetter() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

class AppointmentsPage extends StatelessWidget {
  const AppointmentsPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppointmentsController>(
      init: AppointmentsController(),
      builder: (controller) {
        return _AppointmentsView(controller: controller);
      },
    );
  }
}

class _AppointmentsView extends StatefulWidget {
  final AppointmentsController controller;
  
  const _AppointmentsView({Key? key, required this.controller}) : super(key: key);

  @override
  _AppointmentsViewState createState() => _AppointmentsViewState();
}

class _AppointmentsViewState extends State<_AppointmentsView> {
  late final AppointmentsController controller;
  
  @override
  void initState() {
    super.initState();
    controller = widget.controller;
    
    // Inicialización diferida para evitar problemas de contexto
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = Get.arguments as Map<String, dynamic>?;
      if (args != null && args['showHistory'] == true) {
        controller.showHistoryView();
      }
    });
  }

  @override
  void dispose() {
    // No es necesario limpiar el controlador aquí porque usamos Get.lazyPut con fenix: true
    super.dispose();
  }

  void _toggleHistoryView() {
    setState(() {
      controller.showHistory.toggle();
      if (controller.showHistory.value) {
        controller.filterStatus.value = 'completada';
      } else {
        controller.filterStatus.value = 'todos';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Citas'),
        actions: [
          // Botón para cambiar entre historial y próximas citas
          Obx(
            () => IconButton(
              icon: Icon(
                controller.showHistory.value
                    ? Icons.calendar_today
                    : Icons.history,
                color: Colors.white,
              ),
              onPressed: _toggleHistoryView,
              tooltip: controller.showHistory.value
                  ? 'Ver próximas citas'
                  : 'Ver historial',
            ),
          ),
          // Botón para cambiar el formato del calendario
          Obx(
            () => IconButton(
              icon: Icon(
                controller.calendarFormat.value == CalendarFormat.month
                    ? Icons.calendar_view_week
                    : Icons.calendar_view_month,
                color: Colors.white,
              ),
              onPressed: controller.toggleCalendarFormat,
              tooltip: 'Cambiar vista del calendario',
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (!controller.isInitialized) {
          return const Center(child: CircularProgressIndicator());
        }
        
        return Column(
          children: [
            // Barra de búsqueda
            _buildSearchBar(),
            
            // Filtros de estado
            _buildStatusFilter(),
            
            // Calendario
            _buildCalendar(),
            
            // Lista de citas
            Expanded(
              child: controller.showHistory.value
                  ? _buildHistoryList()
                  : _buildAppointmentsList(),
            ),
          ],
        );
      }),
      // Botón flotante para agregar nueva cita
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Implementar navegación a pantalla de nueva cita
          Get.snackbar(
            'Nueva cita',
            'Funcionalidad en desarrollo',
            snackPosition: SnackPosition.BOTTOM,
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Nueva Cita'),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: controller.searchController,
        onChanged: controller.updateSearchQuery,
        decoration: InputDecoration(
          hintText: 'Buscar citas...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: Obx(
            () {
              if (controller.searchQuery.value.isNotEmpty) {
                return IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    controller.searchController.clear();
                    controller.updateSearchQuery('');
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
        ),
      ),
    );
  }

  Widget _buildStatusFilter() {
    return SizedBox(
      height: 50,
      child: Obx(
        () => ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          itemCount: controller.statusList.length,
          itemBuilder: (context, index) {
            final status = controller.statusList[index];
            final isSelected = controller.filterStatus.value == status;
            
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ChoiceChip(
                label: Text(
                  status.capitalizeFirstLetter(),
                  style: TextStyle(
                    color: isSelected ? Colors.white : null,
                    fontSize: 12,
                  ),
                ),
                selected: isSelected,
                selectedColor: Theme.of(context).primaryColor,
                onSelected: (_) => controller.filterStatus.value = status,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Obx(
          () => TableCalendar(
            firstDay: DateTime.now().subtract(const Duration(days: 365)),
            lastDay: DateTime.now().add(const Duration(days: 365)),
            focusedDay: controller.focusedDay.value,
            selectedDayPredicate: (day) => 
                isSameDay(controller.selectedDay.value, day),
            onDaySelected: controller.onDaySelected,
            onPageChanged: (focusedDay) => 
                controller.focusedDay.value = focusedDay,
            calendarFormat: controller.calendarFormat.value,
            onFormatChanged: (format) => 
                controller.calendarFormat.value = format,
            eventLoader: (day) => 
                controller.groupedAppointments[DateTime(day.year, day.month, day.day)] ?? [],
            calendarBuilders: CalendarBuilders(
              // Reducir el tamaño de los días
              defaultBuilder: (context, day, focusedDay) {
                return Container(
                  margin: const EdgeInsets.all(4.0),
                  alignment: Alignment.center,
                  child: Text(
                    '${day.day}',
                    style: const TextStyle(fontSize: 12.0),
                  ),
                );
              },
            ),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Theme.of(Get.context!).primaryColor,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Theme.of(Get.context!).colorScheme.secondary,
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: Theme.of(Get.context!).colorScheme.secondary,
                shape: BoxShape.circle,
              ),
              markersAlignment: Alignment.bottomCenter,
              markersAutoAligned: false,
              markerSize: 4,
              markerMargin: const EdgeInsets.only(top: 12),
              cellPadding: const EdgeInsets.all(2.0),
              // Asegurar que el contenido de la celda no se desborde
              cellAlignment: Alignment.center,
              outsideDaysVisible: false,
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: const TextStyle(fontSize: 14.0),
              leftChevronIcon: const Icon(Icons.chevron_left, size: 20),
              rightChevronIcon: const Icon(Icons.chevron_right, size: 20),
              headerPadding: const EdgeInsets.symmetric(vertical: 8.0),
              leftChevronMargin: const EdgeInsets.only(left: 8.0),
              rightChevronMargin: const EdgeInsets.only(right: 8.0),
              formatButtonShowsNext: false,
            ),
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle: TextStyle(fontSize: 11.0, fontWeight: FontWeight.normal),
              weekendStyle: TextStyle(fontSize: 11.0, fontWeight: FontWeight.normal),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentsList() {
    try {
      final appointments = controller.appointmentsForSelectedDay;
      
      if (appointments.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.event_available_outlined,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              Text(
                'No hay citas programadas',
                style: Theme.of(Get.context!).textTheme.titleMedium?.copyWith(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final appointment = appointments[index];
          return _buildAppointmentCard(appointment);
        },
      );
    } catch (e) {
      debugPrint('Error building appointments list: $e');
      return const Center(
        child: Text('Error al cargar las citas'),
      );
    }
  }

  Widget _buildHistoryList() {
    try {
      final pastAppointments = controller.filteredAppointments
          .where((appt) => appt['date'].isBefore(DateTime.now()))
          .toList();

      if (pastAppointments.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.history_outlined,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              Text(
                'No hay citas en el historial',
                style: Theme.of(Get.context!).textTheme.titleMedium?.copyWith(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: pastAppointments.length,
        itemBuilder: (context, index) {
          final appointment = pastAppointments[index];
          return _buildAppointmentCard(appointment);
        },
      );
    } catch (e) {
      debugPrint('Error loading history: $e');
      return const Center(
        child: Text('Error al cargar el historial'),
      );
    }
  }

  Widget _buildAppointmentCard(Map<String, dynamic> appointment) {
    try {
      final date = appointment['date'] as DateTime? ?? DateTime.now();
      final time = '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
      final status = (appointment['status'] as String?) ?? 'pendiente';
      final statusColor = controller.getStatusColor(status);
      
      return Card(
        margin: const EdgeInsets.only(bottom: 16, left: 8, right: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            _showAppointmentDetails(appointment);
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          status.capitalizeFirstLetter(),
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      time,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  (appointment['title']?.toString() ?? 'Sin título').trim(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (appointment['description'] != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    appointment['description'].toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                // Información adicional
                if (appointment['location'] != null) ...[
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          appointment['location'].toString(),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
                if (appointment['doctor'] != null) ...[
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 16,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          appointment['doctor'].toString(),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                if (status == 'pendiente') ...[
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => controller.confirmAppointment(appointment['id']),
                        child: const Text('Confirmar'),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () => controller.cancelAppointment(appointment['id']),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        child: const Text('Cancelar'),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      debugPrint('Error building appointment card: $e');
      return const SizedBox.shrink();
    }
  }

  // Helper methods for date and time formatting
  String _formatDate(DateTime date) {
    return '${_getWeekday(date.weekday)}, ${date.day} ${_getMonth(date.month)} ${date.year}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _getWeekday(int weekday) {
    switch (weekday) {
      case 1: return 'Lunes';
      case 2: return 'Martes';
      case 3: return 'Miércoles';
      case 4: return 'Jueves';
      case 5: return 'Viernes';
      case 6: return 'Sábado';
      case 7: return 'Domingo';
      default: return '';
    }
  }

  String _getMonth(int month) {
    switch (month) {
      case 1: return 'Enero';
      case 2: return 'Febrero';
      case 3: return 'Marzo';
      case 4: return 'Abril';
      case 5: return 'Mayo';
      case 6: return 'Junio';
      case 7: return 'Julio';
      case 8: return 'Agosto';
      case 9: return 'Septiembre';
      case 10: return 'Octubre';
      case 11: return 'Noviembre';
      case 12: return 'Diciembre';
      default: return '';
    }
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  void _showAppointmentDetails(Map<String, dynamic> appointment) {
    final status = (appointment['status'] as String?) ?? 'pendiente';
    final statusColor = controller.getStatusColor(status);
    final date = appointment['date'] as DateTime? ?? DateTime.now();
    
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (_, ScrollController sheetScrollController) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SingleChildScrollView(
                controller: sheetScrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Título y fecha
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appointment['title']?.toString() ?? 'Sin título',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_formatDate(date)} • ${_formatTime(date)}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Estado
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        status[0].toUpperCase() + status.substring(1),
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Detalles de la cita
                    _buildDetailSection(
                      title: 'Detalles de la cita',
                      children: [
                        _buildDetailItem(
                          icon: Icons.person_outline,
                          title: 'Médico',
                          value: appointment['doctor']?.toString() ?? 'No especificado',
                        ),
                        _buildDetailItem(
                          icon: Icons.category_outlined,
                          title: 'Tipo de cita',
                          value: appointment['type']?.toString() ?? 'No especificado',
                        ),
                        _buildDetailItem(
                          icon: Icons.location_on_outlined,
                          title: 'Ubicación',
                          value: appointment['location']?.toString() ?? 'No especificada',
                        ),
                        _buildDetailItem(
                          icon: Icons.access_time,
                          title: 'Duración',
                          value: '30 minutos',
                        ),
                      ],
                    ),
                    
                    // Notas
                    if (appointment['notes'] != null && (appointment['notes'] as String).isNotEmpty) ...[
                      _buildDetailSection(
                        title: 'Notas',
                        children: [
                          Text(
                            appointment['notes'].toString(),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                    
                    // Acciones
                    if (status != 'cancelada' && status != 'completada') ...[
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.edit_outlined, size: 20),
                              label: const Text('Editar'),
                              onPressed: () {
                                // TODO: Implementar edición de cita
                                Get.back();
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                side: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.cancel_outlined, size: 20),
                              label: const Text('Cancelar'),
                              onPressed: () {
                                // TODO: Implementar cancelación de cita
                                Get.back();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
