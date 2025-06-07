import 'package:flutter/material.dart';

class AppTheme {
  // Paleta de colores principal
  static const Color primaryColor = Color(0xFF4361EE);
  static const Color primaryLight = Color(0xFF4895EF);
  static const Color primaryDark = Color(0xFF3A0CA3);
  static const Color secondaryColor = Color(0xFF7209B7);
  static const Color accentColor = Color(0xFFF72585);
  static const Color successColor = Color(0xFF4CC9F0);
  static const Color warningColor = Color(0xFFF8961E);
  static const Color errorColor = Color(0xFFEF476F);
  
  // Colores de fondo y superficie
  static const Color backgroundColor = Color(0xFFF8F9FF);
  static const Color surfaceColor = Colors.white;
  static const Color cardColor = Colors.white;
  
  // Colores de texto
  static const Color textPrimary = Color(0xFF212529);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color textHint = Color(0xFFADB5BD);
  static const Color lightTextColor = Color(0xFF6C757D);
  static const Color textColor = Color(0xFF212529);
  
  // Bordes y sombras
  static const Color borderColor = Color(0xFFE9ECEF);
  static const Color shadowColor = Color(0x1A000000);
  
  // Degradados
  static LinearGradient primaryGradient = const LinearGradient(
    colors: [primaryColor, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Estilos de texto
  static const TextStyle displayLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    letterSpacing: -0.5,
  );
  
  static const TextStyle displayMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    letterSpacing: -0.25,
  );
  
  static const TextStyle heading1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );
  
  static const TextStyle heading2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );
  
  static const TextStyle heading3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    color: textPrimary,
    height: 1.5,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    color: textSecondary,
    height: 1.5,
  );
  
  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.5,
  );
  
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: textSecondary,
    letterSpacing: 0.4,
  );
  
  // Tema claro
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    primaryColor: primaryColor,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      primaryContainer: primaryDark,
      secondary: secondaryColor,
      secondaryContainer: secondaryColor.withOpacity(0.2),
      surface: surfaceColor,
      background: backgroundColor,
      error: errorColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: textPrimary,
      onBackground: textPrimary,
      onError: Colors.white,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: surfaceColor,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: IconThemeData(color: textPrimary),
    ),
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: borderColor, width: 1),
      ),
      color: cardColor,
      margin: EdgeInsets.zero,
    ) as CardThemeData,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: buttonText,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        textStyle: bodyLarge.copyWith(
          color: primaryColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorColor),
      ),
      labelStyle: bodyMedium.copyWith(color: textSecondary),
      hintStyle: bodyMedium.copyWith(color: textHint),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
    ) as DialogThemeData,
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    ),
    iconTheme: const IconThemeData(color: textPrimary),
  );
  
  // Tema oscuro (opcional)
  static ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: primaryColor,
    colorScheme: const ColorScheme.dark().copyWith(
      primary: primaryColor,
      secondary: secondaryColor,
    ),
    // ... otros estilos para el tema oscuro
  );
}
