import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/hive_service.dart';
import 'screens/splash_screen.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final hiveService = HiveService();
  await hiveService.init();
  await NotificationService.init();
  await NotificationService.showDailyReminder();

  runApp(const ProviderScope(child: JejakUangApp()));
}

class JejakUangApp extends StatelessWidget {
  const JejakUangApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JejakUang',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B4332),
          primary: const Color(0xFF1B4332),
          secondary: const Color(0xFF2D6A4F),
          tertiary: const Color(0xFFFFB703),
          error: const Color(0xFFE63946),
          surface: Colors.white,
          background: const Color(0xFFF8F9FA),
        ),
        textTheme: GoogleFonts.lexendDecaTextTheme(),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: GoogleFonts.lexendDeca(
            color: const Color(0xFF1B4332),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: const IconThemeData(color: Color(0xFF1B4332)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2D6A4F),
            foregroundColor: Colors.white,
            textStyle: GoogleFonts.lexendDeca(fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
