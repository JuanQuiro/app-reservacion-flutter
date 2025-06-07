import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class AppointmentsController extends GetxController {
  static AppointmentsController get to => Get.find<AppointmentsController>();
  
  // Controlador para la búsqueda
  final searchController = TextEditingController();
  
  // Estado para manejar la inicialización
  final _isInitialized = false.obs;
  bool get isInitialized => _isInitialized.value;
  
  // Estados reactivos
  final RxString filterStatus = 'todos'.obs;
  final RxString searchQuery = ''.obs;
  final RxBool showHistory = false.obs;
  final Rx<DateTime> focusedDay = DateTime.now().obs;
  final Rx<DateTime?> selectedDay = Rx<DateTime?>(DateTime.now());
  final Rx<CalendarFormat> calendarFormat = CalendarFormat.week.obs;
  
  @override
  void onInit() {
    super.onInit();
    _isInitialized.value = true;
  }
  
  // Lista de citas (datos de ejemplo)
  final RxList<Map<String, dynamic>> appointments = <Map<String, dynamic>>[
    {
      'id': '1',
      'title': 'Cita con el Dr. Pérez',
      'date': DateTime.now().add(const Duration(days: 1)),
      'type': 'Medicina General',
      'doctor': 'Dr. Juan Pérez',
      'location': 'Consultorio 101',
      'status': 'confirmada',
      'notes': 'Llevar exámenes de laboratorio',
    },
    {
      'id': '2',
      'title': 'Control mensual',
      'date': DateTime.now().add(const Duration(days: 2)),
      'type': 'Control',
      'doctor': 'Dra. Ana López',
      'location': 'Consultorio 205',
      'status': 'pendiente',
      'notes': 'Revisar presión arterial',
    },
    {
      'id': '3',
      'title': 'Consulta de seguimiento',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'type': 'Seguimiento',
      'doctor': 'Dr. Carlos Ramírez',
      'location': 'Consultorio 150',
      'status': 'completada',
      'notes': 'Revisar resultados de exámenes',
    },
  ].obs;

  // Lista de estados disponibles para filtro
  final List<String> statusList = [
    'todos',
    'pendiente',
    'confirmada',
    'completada',
    'cancelada',
  ];
  
  // Mostrar vista de historial
  void showHistoryView() {
    showHistory.value = true;
    // Mostrar solo citas pasadas cuando se ve el historial
    filterStatus.value = 'completada';
  }

  // Obtener citas filtradas
  List<Map<String, dynamic>> get filteredAppointments {
    var filtered = appointments.toList();
    
    // Filtrar por estado
    if (filterStatus.value != 'todos') {
      filtered = filtered.where((appt) => appt['status'] == filterStatus.value).toList();
    }
    
    // Filtrar por búsqueda
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      filtered = filtered.where((appt) {
        return appt['title'].toLowerCase().contains(query) ||
               appt['doctor'].toLowerCase().contains(query) ||
               appt['type'].toLowerCase().contains(query);
      }).toList();
    }
    
    // Ordenar por fecha (más recientes primero)
    filtered.sort((a, b) => b['date'].compareTo(a['date']));
    
    return filtered;
  }
  
  // Obtener citas para el día seleccionado
  List<Map<String, dynamic>> get appointmentsForSelectedDay {
    if (selectedDay.value == null) return [];
    
    final selectedDate = DateTime(
      selectedDay.value!.year,
      selectedDay.value!.month,
      selectedDay.value!.day,
    );
    
    return filteredAppointments.where((appt) {
      final apptDate = appt['date'] as DateTime;
      return apptDate.year == selectedDate.year &&
             apptDate.month == selectedDate.month &&
             apptDate.day == selectedDate.day;
    }).toList();
  }
  
  // Obtener citas agrupadas por fecha
  Map<DateTime, List<Map<String, dynamic>>> get groupedAppointments {
    final Map<DateTime, List<Map<String, dynamic>>> data = {};
    
    for (var appt in filteredAppointments) {
      final date = appt['date'] as DateTime;
      final dateOnly = DateTime(date.year, date.month, date.day);
      
      if (data[dateOnly] == null) {
        data[dateOnly] = [];
      }
      
      data[dateOnly]!.add(appt);
    }
    
    return data;
  }
  
  // Obtener fechas con citas para el calendario
  Set<DateTime> get events {
    return groupedAppointments.keys.toSet();
  }
  
  // Cambiar día seleccionado
  void onDaySelected(DateTime selected, DateTime focused) {
    selectedDay.value = selected;
    focusedDay.value = focused;
  }
  
  // Cambiar formato del calendario
  void toggleCalendarFormat() {
    calendarFormat.value = 
        calendarFormat.value == CalendarFormat.month 
            ? CalendarFormat.week 
            : CalendarFormat.month;
  }
  
  // Actualizar búsqueda
  void updateSearchQuery(String query) {
    searchQuery.value = query.toLowerCase();
  }
  
  // Cancelar una cita
  Future<void> cancelAppointment(String appointmentId) async {
    try {
      // Mostrar diálogo de confirmación
      final confirm = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Cancelar cita'),
          content: const Text('¿Estás seguro de que deseas cancelar esta cita?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('No, mantener'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text('Sí, cancelar', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );

      if (confirm == true) {
        // En una aplicación real, aquí harías una petición a tu API
        await Future.delayed(const Duration(seconds: 1));
        
        // Actualizar el estado de la cita a cancelada
        final index = appointments.indexWhere((appt) => appt['id'] == appointmentId);
        if (index != -1) {
          appointments[index]['status'] = 'cancelada';
          appointments.refresh();
          
          Get.snackbar(
            'Cita cancelada',
            'La cita ha sido cancelada correctamente',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo cancelar la cita',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  
  // Confirmar una cita
  Future<void> confirmAppointment(String appointmentId) async {
    try {
      // En una aplicación real, aquí harías una petición a tu API
      await Future.delayed(const Duration(seconds: 1));
      
      // Actualizar el estado de la cita a confirmada
      final index = appointments.indexWhere((appt) => appt['id'] == appointmentId);
      if (index != -1) {
        appointments[index]['status'] = 'confirmada';
        appointments.refresh();
        
        Get.snackbar(
          'Cita confirmada',
          'La cita ha sido confirmada',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo confirmar la cita',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  
  // Obtener el color según el estado de la cita
  Color getStatusColor(String status) {
    switch (status) {
      case 'confirmada':
        return Colors.green;
      case 'pendiente':
        return Colors.orange;
      case 'completada':
        return Colors.blue;
      case 'cancelada':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
  
  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
