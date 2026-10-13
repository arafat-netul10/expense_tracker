import 'dart:io';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../Models/expense.dart';

class ExportService {
  static String _getFormattedDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  // ================= PDF EXPORT =================
  static Future<String> exportToPdf(List<Expense> expenses) async {
    final pdf = pw.Document();

    double totalEarnings = expenses
        .where((e) => e.isEarning)
        .fold(0, (sum, item) => sum + item.amount);

    double totalExpenses = expenses
        .where((e) => !e.isEarning)
        .fold(0, (sum, item) => sum + item.amount);

    double balance = totalEarnings - totalExpenses;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            // Title Header
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Expense Tracker Report',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blueGrey800,
                    ),
                  ),
                  pw.Text(
                    _getFormattedDate(DateTime.now()),
                    style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 16),

            // Summary Cards Table
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey200,
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                children: [
                  pw.Column(
                    children: [
                      pw.Text('Total Earnings',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 4),
                      pw.Text('\$${totalEarnings.toStringAsFixed(2)}',
                          style: pw.TextStyle(color: PdfColors.green700, fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                  pw.Column(
                    children: [
                      pw.Text('Total Expenses',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 4),
                      pw.Text('\$${totalExpenses.toStringAsFixed(2)}',
                          style: pw.TextStyle(color: PdfColors.red700, fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                  pw.Column(
                    children: [
                      pw.Text('Net Balance',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 4),
                      pw.Text('\$${balance.toStringAsFixed(2)}',
                          style: pw.TextStyle(
                            color: balance >= 0 ? PdfColors.blue700 : PdfColors.orange700,
                            fontWeight: pw.FontWeight.bold,
                          )),
                    ],
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 20),

            pw.Text(
              'Transaction Details',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),

            // Transactions Table
            pw.TableHelper.fromTextArray(
              headers: ['Date', 'Type', 'Title', 'Amount'],
              data: expenses.map((e) {
                return [
                  _getFormattedDate(e.date),
                  e.isEarning ? 'Earning' : 'Expense',
                  e.title,
                  '${e.isEarning ? '+' : '-'}\$${e.amount.toStringAsFixed(2)}',
                ];
              }).toList(),
              border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey700),
              rowDecoration: const pw.BoxDecoration(color: PdfColors.grey50),
              cellAlignment: pw.Alignment.centerLeft,
              cellPadding: const pw.EdgeInsets.all(6),
            ),
          ];
        },
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final fileName = "Expenses_${DateTime.now().millisecondsSinceEpoch}.pdf";
    final filePath = "${dir.path}/$fileName";

    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    return filePath;
  }

  // ================= OPEN / VIEW FILE =================
  static Future<void> openExportedFile(String filePath) async {
    await OpenFilex.open(filePath);
  }
}
