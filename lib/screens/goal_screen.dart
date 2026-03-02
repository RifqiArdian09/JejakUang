import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/goal_provider.dart';
import '../providers/summary_provider.dart';
import '../utils/currency_utils.dart';
import '../models/goal.dart';
import '../providers/language_provider.dart';
import '../widgets/glass_container.dart';
import 'package:intl/intl.dart';

class GoalScreen extends ConsumerWidget {
  const GoalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goals = ref.watch(goalsProvider);
    final summary = ref.watch(summaryProvider);
    final currency = summary['currency'] as String? ?? 'IDR';

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E12),
      appBar: AppBar(
        title: Text(
          S.text(context, 'Target Keuangan', 'Financial Goals'),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
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
                style: TextStyle(color: Colors.white.withOpacity(0.3)),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              itemCount: goals.length,
              itemBuilder: (context, index) {
                final goal = goals[index];
                final percent = (goal.currentAmount / goal.targetAmount).clamp(
                  0.0,
                  1.0,
                );

                return GlassContainer(
                  padding: const EdgeInsets.all(24),
                  borderRadius: 24,
                  opacity: 0.05,
                  margin: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFB703).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.rocket_launch_rounded,
                              color: Color(0xFFFFB703),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  goal.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '${S.text(context, 'Tenggat', 'Deadline')}: ${DateFormat('dd MMM yyyy').format(goal.deadline)}',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.3),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.add_circle_outline,
                                  color: Color(0xFF2CC07B),
                                  size: 22,
                                ),
                                onPressed: () =>
                                    _showAddProgressDialog(context, ref, goal),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.white24,
                                  size: 20,
                                ),
                                onPressed: () {
                                  ref
                                      .read(goalsProvider.notifier)
                                      .deleteGoal(goal.id);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${(percent * 100).toStringAsFixed(0)}%',
                            style: const TextStyle(
                              color: Color(0xFF2CC07B),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '${CurrencyUtils.format(goal.currentAmount, currency: currency)} / ${CurrencyUtils.format(goal.targetAmount, currency: currency)}',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: percent,
                          backgroundColor: Colors.white.withOpacity(0.05),
                          valueColor: const AlwaysStoppedAnimation(
                            Color(0xFF2CC07B),
                          ),
                          minHeight: 12,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        onPressed: () => _showAddGoalDialog(context, ref, currency),
        label: Text(
          S.text(context, 'Buat Target', 'Create Goal'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        icon: const Icon(Icons.stars_rounded),
        backgroundColor: const Color(0xFF2CC07B),
        foregroundColor: Colors.white,
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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

  void _showAddProgressDialog(BuildContext context, WidgetRef ref, Goal goal) {
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.text(context, 'Tambah Tabungan', 'Add Progress')),
        content: TextField(
          controller: amountController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: S.text(context, 'Jumlah', 'Amount'),
            hintText: '0',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(S.text(context, 'Batal', 'Cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(amountController.text);
              if (amount != null && amount > 0) {
                ref.read(goalsProvider.notifier).addProgress(goal.id, amount);
                Navigator.pop(context);
              }
            },
            child: Text(S.text(context, 'Tambah', 'Add')),
          ),
        ],
      ),
    );
  }
}
