import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/goal_provider.dart';
import '../providers/summary_provider.dart';
import '../utils/currency_utils.dart';
import '../models/goal.dart';
import '../providers/language_provider.dart';
import 'package:intl/intl.dart';

class GoalScreen extends ConsumerWidget {
  const GoalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goals = ref.watch(goalsProvider);
    final summary = ref.watch(summaryProvider);
    final currency = summary['currency'] as String? ?? 'IDR';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          S.text(context, 'Target Keuangan', 'Financial Goals'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: goals.isEmpty
          ? Center(
              child: Text(
                S.text(
                  context,
                  'Belum ada target tabungan.',
                  'No saving goals yet.',
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: goals.length,
              itemBuilder: (context, index) {
                final goal = goals[index];
                final percent = (goal.currentAmount / goal.targetAmount).clamp(
                  0.0,
                  1.0,
                );

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        goal.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${S.text(context, 'Tenggat', 'Deadline')}: ${DateFormat('dd MMM yyyy', S.text(context, 'id', 'en')).format(goal.deadline)}',
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 16),
                      LinearProgressIndicator(
                        value: percent,
                        backgroundColor: Colors.grey.withOpacity(0.1),
                        valueColor: const AlwaysStoppedAnimation(
                          Color(0xFF2D6A4F),
                        ),
                        minHeight: 10,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${S.text(context, 'Terkumpul', 'Collected')}: ${CurrencyUtils.format(goal.currentAmount, currency: currency)}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${S.text(context, 'Target', 'Target')}: ${CurrencyUtils.format(goal.targetAmount, currency: currency)}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddGoalDialog(context, ref, currency),
        label: Text(S.text(context, 'Buat Target', 'Create Goal')),
        icon: const Icon(Icons.rocket_launch),
        backgroundColor: const Color(0xFF1B4332),
        foregroundColor: Colors.white,
      ),
    );
  }

  void _showAddGoalDialog(
    BuildContext context,
    WidgetRef ref,
    String currency,
  ) {
    final nameController = TextEditingController();
    final amountController = TextEditingController();
    DateTime deadline = DateTime.now().add(const Duration(days: 30));

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(
            S.text(context, 'Target Tabungan Baru', 'New Saving Goal'),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: S.text(
                    context,
                    'Nama Target (misal: Laptop Baru)',
                    'Goal Name (e.g., New Laptop)',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText:
                      '${S.text(context, 'Jumlah Target', 'Target Amount')} ($currency)',
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(S.text(context, 'Tenggat', 'Deadline')),
                subtitle: Text(
                  DateFormat(
                    'dd MMM yyyy',
                    S.text(context, 'id', 'en'),
                  ).format(deadline),
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: deadline,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) setState(() => deadline = date);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(S.text(context, 'Batal', 'Cancel')),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    amountController.text.isNotEmpty) {
                  final goal = Goal(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: nameController.text,
                    targetAmount: double.parse(amountController.text),
                    deadline: deadline,
                  );
                  ref.read(goalsProvider.notifier).addGoal(goal);
                  Navigator.pop(context);
                }
              },
              child: Text(S.text(context, 'Simpan', 'Save')),
            ),
          ],
        ),
      ),
    );
  }
}
