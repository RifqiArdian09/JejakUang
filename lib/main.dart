import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'services/hive_service.dart';
import 'screens/splash_screen.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('id');
  final hiveService = HiveService();
  await hiveService.init();
  await NotificationService.init();
  await NotificationService.requestPermissions();
  try {
    Future.delayed(const Duration(seconds: 3), () {
      NotificationService.showDailyReminder();
    });
  } catch (e) {
    // Ignore notification errors (e.g. permission denied on Android 12+)
    debugPrint('Notification error: $e');
  }

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
          seedColor: const Color(0xFF003820),
          primary: const Color(0xFF003820),
          secondary: const Color(0xFF2CC07B),
          tertiary: const Color(0xFF00D2FF),
          error: const Color(0xFFE63946),
          surface: Colors.white,
          background: const Color(0xFF0A0E12), // Deep Midnight
        ),
        textTheme: GoogleFonts.outfitTextTheme(),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF0A0E12),
          elevation: 0,
          centerTitle: false,
          titleTextStyle: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2CC07B),
            foregroundColor: Colors.white,
            textStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
