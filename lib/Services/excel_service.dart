import 'package:excel/excel.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../Models/expense.dart';

class ExcelService {
  static Future<String> export(List<Expense> expenses) async {
    final excel = Excel.createExcel();
    final sheet = excel['Expenses'];

    sheet.appendRow(['Title', 'Amount', 'Date']);

    for (var e in expenses) {
      sheet.appendRow([
        e.title,
        e.amount,
        e.date.toString(),
      ]);
    }

    final dir = await getApplicationDocumentsDirectory();
    final filePath = "${dir.path}/expenses.xlsx";

    final file = File(filePath);
    await file.writeAsBytes(excel.encode()!);

    return filePath;
  }
}