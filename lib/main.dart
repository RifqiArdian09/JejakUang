import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/hive_service.dart';
import 'screens/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final hiveService = HiveService();
  await hiveService.init();

  runApp(const ProviderScope(child: CatatWangApp()));
}

class CatatWangApp extends StatelessWidget {
  const CatatWangApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CatatWang',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6200EE),
          primary: const Color(0xFF6200EE),
          secondary: const Color(0xFF03DAC6),
          surface: Colors.white,
          background: const Color(0xFFF8F9FA),
        ),
        textTheme: GoogleFonts.lexendDecaTextTheme(),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: GoogleFonts.lexendDeca(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: const IconThemeData(color: Colors.black),
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}
