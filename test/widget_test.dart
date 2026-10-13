import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:expense_tracker/Models/expense.dart';
import 'package:expense_tracker/main.dart';

void main() {
  setUpAll(() async {
    // Set up a temporary directory for Hive during widget testing
    final tempDir = await Directory.systemTemp.createTemp('hive_test');
    Hive.init(tempDir.path);
    Hive.registerAdapter(ExpenseAdapter());
    await Hive.openBox<Expense>('expenses');
    await Hive.openBox('settings');
  });

  testWidgets('Expense Tracker smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify that Expense Tracker title is displayed.
    expect(find.text('Expense Tracker'), findsWidgets);
  });
}
