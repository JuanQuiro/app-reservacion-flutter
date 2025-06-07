import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// Core
import 'app/core/theme/app_theme.dart';

// Bindings
import 'app/core/bindings/initial_binding.dart';

// Routes
import 'app/routes/app_pages.dart';

void main() async {
  // Inicialización de paquetes
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  
  // Configuración inicial de la aplicación
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Turnos App',
      debugShowCheckedModeBanner: false,
      
      // Configuración de temas
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      
      // Configuración de localización
      locale: const Locale('es', 'ES'),
      fallbackLocale: const Locale('es', 'ES'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'),
        Locale('en', 'US'),
      ],
      
      // Rutas y navegación
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      defaultTransition: Transition.fadeIn,
      
      // Bindings iniciales
      initialBinding: InitialBinding(),
      
      // Configuración de fuentes
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
    );
  }
}
