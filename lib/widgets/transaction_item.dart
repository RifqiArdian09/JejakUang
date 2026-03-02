import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../models/category.dart';
import '../utils/currency_utils.dart';
import '../providers/wallet_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionItem extends ConsumerWidget {
  final Transaction transaction;
  final Category category;

  const TransactionItem({
    super.key,
    required this.transaction,
    required this.category,
  });

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'utensils':
        return FontAwesomeIcons.utensils;
      case 'car':
        return FontAwesomeIcons.car;
      case 'gamepad':
        return FontAwesomeIcons.gamepad;
      case 'money-bill-wave':
        return FontAwesomeIcons.moneyBillWave;
      case 'shopping-cart':
        return FontAwesomeIcons.cartShopping;
      case 'heartbeat':
        return FontAwesomeIcons.heartPulse;
      default:
        return FontAwesomeIcons.circleQuestion;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallets = ref.watch(walletsProvider);
    final wallet = wallets.firstWhere(
      (w) => w.id == transaction.walletId,
      orElse: () => wallets.first,
    );
    final currency = wallet.currency;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(category.color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getIcon(category.icon),
              color: Color(category.color),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (transaction.note.isNotEmpty)
                  Text(
                    transaction.note,
                    style: const TextStyle(color: Colors.black54, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                (transaction.isExpense ? '- ' : '+ ') +
                    CurrencyUtils.format(
                      transaction.amount,
                      currency: currency,
                    ),
                style: TextStyle(
                  color: transaction.isExpense
                      ? const Color(0xFFE63946)
                      : const Color(0xFF2D6A4F),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                DateFormat('dd MMM').format(transaction.date),
                style: const TextStyle(color: Colors.black38, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
