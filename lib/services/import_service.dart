import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import '../models/transaction.dart';

class ImportService {
  static Future<List<List<dynamic>>?> pickAndParseCsv() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result == null || result.files.single.path == null) return null;

    final file = File(result.files.single.path!);
    final input = file.openRead();
    final fields = await input
        .transform(utf8.decoder)
        .transform(const CsvToListConverter())
        .toList();

    return fields;
  }

  static List<Transaction> mapCsvToTransactions({
    required List<List<dynamic>> data,
    required String defaultWalletId,
    required String defaultCategoryId,
  }) {
    final transactions = <Transaction>[];

    // Skip header if it exists
    int startIndex = 0;
    if (data.isNotEmpty &&
            data[0][0].toString().toLowerCase().contains('date') ||
        data[0][0].toString().toLowerCase().contains('tanggal')) {
      startIndex = 1;
    }

    for (var i = startIndex; i < data.length; i++) {
      final row = data[i];
      if (row.length < 2) continue;

      try {
        // Expected format: Date, Amount, Note(optional), Type(income/expense - optional)
        final dateStr = row[0].toString();
        final amount =
            double.tryParse(
              row[1].toString().replaceAll(RegExp(r'[^0-9.]'), ''),
            ) ??
            0.0;
        final note = row.length > 2 ? row[2].toString() : '';
        final typeStr = row.length > 3
            ? row[3].toString().toLowerCase()
            : 'expense';

        DateTime date;
        try {
          date = DateTime.parse(dateStr);
        } catch (_) {
          date = DateTime.now();
        }

        bool isExpense = true;
        if (typeStr.contains('income') || typeStr.contains('masuk')) {
          isExpense = false;
        }

        transactions.add(
          Transaction(
            id: DateTime.now().millisecondsSinceEpoch.toString() + i.toString(),
            amount: amount,
            categoryId: defaultCategoryId,
            date: date,
            note: note,
            walletId: defaultWalletId,
            isExpense: isExpense,
          ),
        );
      } catch (e) {
        print('Error parsing row $i: $e');
      }
    }

    return transactions;
  }
}
