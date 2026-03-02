import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/transaction.dart';
import '../models/category.dart';
import '../utils/currency_utils.dart';
import '../models/wallet.dart';

class ReportService {
  static Future<void> generatePdfReport(
    List<Transaction> transactions,
    List<Category> categories,
    List<Wallet> wallets,
  ) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Laporan Keuangan JejakUang',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: ['Tanggal', 'Kategori', 'Catatan', 'Jumlah'],
                data: transactions.map((tx) {
                  final category = categories.firstWhere(
                    (c) => c.id == tx.categoryId,
                    orElse: () => categories.first,
                  );
                  final wallet = wallets.firstWhere(
                    (w) => w.id == tx.walletId,
                    orElse: () => wallets.first,
                  );
                  return [
                    tx.date.toString().substring(0, 10),
                    category.name,
                    tx.note,
                    (tx.isExpense ? '-' : '+') +
                        CurrencyUtils.format(
                          tx.amount,
                          currency: wallet.currency,
                        ),
                  ];
                }).toList(),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
