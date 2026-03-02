import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dashboard_screen.dart';
import '../providers/language_provider.dart';
import 'transaction_list_screen.dart';
import 'wallet_screen.dart';
import 'analytics_screen.dart';
import '../widgets/glass_container.dart';
import 'add_transaction_screen.dart';

import '../providers/navigation_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavigationScreen extends ConsumerWidget {
  const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationProvider);

    final List<Widget> _screens = [
      const DashboardScreen(),
      const TransactionListScreen(),
      const AnalyticsScreen(),
      const WalletScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E12),
      extendBody: true,
      body: IndexedStack(index: currentIndex, children: _screens),
      bottomNavigationBar: _buildModernNavBar(context, ref, currentIndex),
      floatingActionButton: Container(
        height: 64,
        width: 64,
        child: FloatingActionButton(
          heroTag: 'fab_main',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddTransactionScreen(),
              ),
            );
          },
          backgroundColor: const Color(0xFF2CC07B),
          foregroundColor: Colors.white,
          shape: const CircleBorder(),
          elevation: 10,
          child: const Icon(Icons.add, size: 32),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildModernNavBar(
    BuildContext context,
    WidgetRef ref,
    int currentIndex,
  ) {
    return Container(
      height: 90,
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: GlassContainer(
        padding: EdgeInsets.zero,
        borderRadius: 32,
        opacity: 0.1,
        blur: 20,
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _navItem(
              context,
              ref,
              0,
              currentIndex,
              FontAwesomeIcons.house,
              S.text(context, 'Beranda', 'Home'),
            ),
            _navItem(
              context,
              ref,
              1,
              currentIndex,
              FontAwesomeIcons.listCheck,
              S.text(context, 'Catatan', 'Records'),
            ),
            const SizedBox(width: 40), // Space for FAB
            _navItem(
              context,
              ref,
              2,
              currentIndex,
              FontAwesomeIcons.chartPie,
              S.text(context, 'Analisis', 'Analytics'),
            ),
            _navItem(
              context,
              ref,
              3,
              currentIndex,
              FontAwesomeIcons.wallet,
              S.text(context, 'Dompet', 'Wallet'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navItem(
    BuildContext context,
    WidgetRef ref,
    int index,
    int currentIndex,
    IconData icon,
    String label,
  ) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => ref.read(navigationProvider.notifier).state = index,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF2CC07B).withOpacity(0.1)
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isSelected
                  ? const Color(0xFF2CC07B)
                  : Colors.white.withOpacity(0.4),
              size: 20,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.4),
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
