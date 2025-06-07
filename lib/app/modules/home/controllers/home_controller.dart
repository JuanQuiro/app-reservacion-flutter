import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  // Estado para controlar la carga
  final RxBool isLoading = false.obs;
  final RxInt selectedDay = DateTime.now().day.obs;
  final Rx<DateTime> focusedDay = DateTime.now().obs;
  
  // Datos de ejemplo para las citas
  final RxList<Map<String, dynamic>> upcomingAppointments = <Map<String, dynamic>>[
    {
      'id': '1',
      'title': 'Cita con el Dr. Pérez',
      'date': DateTime.now().add(const Duration(hours: 2)),
      'type': 'Medicina General',
      'status': 'confirmada',
      'doctor': 'Dr. Juan Pérez',
      'specialty': 'Medicina General',
      'location': 'Consultorio 101',
      'notes': 'Llevar exámenes de laboratorio',
      'color': 0xFF4CC9F0, // Azul claro
    },
    {
      'id': '2',
      'title': 'Control mensual',
      'date': DateTime.now().add(const Duration(days: 1, hours: 3)),
      'type': 'Control',
      'status': 'pendiente',
      'doctor': 'Dra. Ana López',
      'specialty': 'Cardiología',
      'location': 'Consultorio 205',
      'notes': 'Revisar presión arterial',
      'color': 0xFF7209B7, // Morado
    },
    {
      'id': '3',
      'title': 'Examen de laboratorio',
      'date': DateTime.now().add(const Duration(days: 2, hours: 10)),
      'type': 'Examen',
      'status': 'pendiente',
      'doctor': 'Dr. Carlos Rojas',
      'specialty': 'Laboratorio Clínico',
      'location': 'Laboratorio Central',
      'notes': 'Ayunas de 8 horas',
      'color': 0xFFF8961E, // Naranja
    },
  ].obs;

  // Obtener las próximas citas
  List<Map<String, dynamic>> getUpcomingAppointments() {
    return upcomingAppointments.where((appt) {
      return appt['date'].isAfter(DateTime.now().subtract(const Duration(hours: 1)));
    }).toList();
  }

  // Obtener citas para el día seleccionado
  List<Map<String, dynamic>> getAppointmentsForDay(DateTime day) {
    return upcomingAppointments.where((appt) {
      return appt['date'].year == day.year &&
          appt['date'].month == day.month &&
          appt['date'].day == day.day;
    }).toList();
  }

  // Obtener citas del día actual
  List<Map<String, dynamic>> get todayAppointments {
    final now = DateTime.now();
    return getAppointmentsForDay(now);
  }

  // Formatear fecha para mostrar
  String formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);
    
    if (dateOnly == today) return 'Hoy';
    if (dateOnly == tomorrow) return 'Mañana';
    
    return DateFormat('EEEE, d MMM', 'es').format(date);
  }

  // Formatear hora
  String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  // Actualizar la lista de citas
  Future<void> refreshAppointments() async {
    try {
      isLoading.value = true;
      // Simular carga de datos
      await Future.delayed(const Duration(seconds: 1));
      // En una aplicación real, aquí cargarías los datos de la API
      update();
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudieron cargar las citas',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
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
        // Simular cancelación
        await Future.delayed(const Duration(seconds: 1));
        
        // Eliminar la cita de la lista
        upcomingAppointments.removeWhere((appt) => appt['id'] == appointmentId);
        
        Get.snackbar(
          'Cita cancelada',
          'La cita ha sido cancelada correctamente',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
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

  @override
  void onInit() {
    super.onInit();
    // Cargar las citas al iniciar el controlador
    refreshAppointments();
  }
}
