import 'package:hive/hive.dart';
import '../Models/expense.dart';

class ExpenseService {

  static Box<Expense> get _box => Hive.box<Expense>('expenses');

  static List<Expense> getExpenses() {
    return _box.values.toList();
  }

  static Future<void> addExpense(Expense expense) async {
    await _box.add(expense);
  }

  static Future<void> deleteExpense(int index) async {
    await _box.deleteAt(index);
  }

  static Future<void> updateExpense(int index, Expense expense) async {
    await _box.putAt(index, expense);
  }

  static Future<void> clearAll() async {
    await _box.clear();
  }

}