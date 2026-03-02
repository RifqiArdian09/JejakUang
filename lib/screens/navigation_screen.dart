import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dashboard_screen.dart';
import '../providers/language_provider.dart';
import 'transaction_list_screen.dart';
import 'wallet_screen.dart';
import 'analytics_screen.dart';

import 'add_transaction_screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const TransactionListScreen(),
    const AnalyticsScreen(),
    const WalletScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF1B4332),
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(FontAwesomeIcons.house),
              label: S.text(context, 'Beranda', 'Home'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(FontAwesomeIcons.listCheck),
              label: S.text(context, 'Catatan', 'Records'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(FontAwesomeIcons.chartPie),
              label: S.text(context, 'Analisis', 'Analytics'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(FontAwesomeIcons.wallet),
              label: S.text(context, 'Dompet', 'Wallets'),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTransactionScreen(),
            ),
          );
        },
        backgroundColor: const Color(0xFF1B4332),
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
