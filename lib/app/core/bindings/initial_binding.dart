import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// Controladores
import '../../modules/auth/controllers/auth_controller.dart';
import '../../modules/home/controllers/home_controller.dart';
import '../../modules/profile/controllers/profile_controller.dart';
import '../../modules/appointments/controllers/appointments_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Inicialización de servicios
    Get.put(GetStorage(), permanent: true);
    
    // Controladores
    Get.lazyPut(() => AuthController(), fenix: true);
    Get.lazyPut(() => HomeController(), fenix: true);
    Get.lazyPut(() => ProfileController(), fenix: true);
    Get.lazyPut(() => AppointmentsController(), fenix: true);
    
    // Aquí se pueden agregar más bindings iniciales
    // Por ejemplo:
    // Get.lazyPut(() => ApiService(), fenix: true);
  }
}
