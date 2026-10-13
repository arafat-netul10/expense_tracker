import 'package:flutter/material.dart';
import '../Widgets/build_summary_card.dart';
import '../Widgets/build_list.dart';
import '../Models/expense.dart';
import '../Services/expense_service.dart';
import '../Services/export_service.dart';
import '../Widgets/expense_chart.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {

  List<Expense> allItems = [];
  late TabController _tabController;


  // ================= GETTERS =================

  List<Expense> get earnings =>
      allItems.where((e) => e.isEarning).toList();

  List<Expense> get expenses =>
      allItems.where((e) => !e.isEarning).toList();

  List<Expense> get overallItems => allItems;

  double get totalExpenses =>
      expenses.fold(0, (sum, item) => sum + item.amount);

  double get totalEarnings =>
      earnings.fold(0, (sum, item) => sum + item.amount);

  double get balance => totalEarnings - totalExpenses;

  // ================= INIT & DISPOSE =================

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadData() {
    allItems = ExpenseService.getExpenses();
    setState(() {});
  }


  // ================= ADD OPTIONS =================

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  _textForm(true);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent),
                child: const Text('Add Earnings',
                    style: TextStyle(color: Colors.white)),
              ),
              ElevatedButton(
                onPressed: () {
                  _textForm(false);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent),
                child: const Text('Add Expenses',
                    style: TextStyle(color: Colors.white)),
              )
            ],
          ),
        );
      },
    );
  }

  // ================= EXPORT PDF =================

  void _exportPdf() async {
    final messenger = ScaffoldMessenger.of(context);
    Navigator.pop(context); // close drawer

    final items = ExpenseService.getExpenses();
    if (items.isEmpty) {
      messenger.showSnackBar(
        const SnackBar(content: Text("No expenses to export.")),
      );
      return;
    }

    try {
      final filePath = await ExportService.exportToPdf(items);

      messenger.showSnackBar(
        SnackBar(
          content: const Text("Exported as PDF successfully!"),
          action: SnackBarAction(
            label: "View",
            onPressed: () {
              ExportService.openExportedFile(filePath);
            },
          ),
        ),
      );

      // Open PDF file for viewing directly
      await ExportService.openExportedFile(filePath);
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text("Failed to export PDF: $e")),
      );
    }
  }

  // ================= ADD FORM =================

  void _textForm(bool isEarning) {
    TextEditingController titleController = TextEditingController();
    TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isEarning ? 'Add Earning' : 'Add Expense',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),

                // TITLE
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: isEarning
                        ? 'Title of Earnings'
                        : 'Title of Expense',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),

                const SizedBox(height: 10),

                // AMOUNT
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),

                const SizedBox(height: 10),

                // BUTTONS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {

                        final title = titleController.text;
                        final amount =
                            double.tryParse(amountController.text) ?? 0;

                        if (title.isEmpty || amount <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Enter valid data")),
                          );
                          return;
                        }

                        final navigator = Navigator.of(context);
                        final messenger = ScaffoldMessenger.of(context);

                        await ExpenseService.addExpense(
                          Expense(
                            title: title,
                            amount: amount,
                            date: DateTime.now(),
                            isEarning: isEarning,
                          ),
                        );

                        navigator.pop();
                        navigator.pop();

                        messenger.showSnackBar(
                           SnackBar(
                            content: Text(isEarning ? "Earning added" : "Expense added"),
                          ),
                        );

                        _loadData();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amberAccent),
                      child: const Text('Save',
                          style: TextStyle(color: Colors.white)),
                    ),

                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amberAccent),
                      child: const Text('Cancel',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  // ================= DELETE =================

  void _deleteItem(int index) async {
    await ExpenseService.deleteExpense(index);
    _loadData();
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Expense Tracker',
          style: TextStyle(color: Colors.white),
        ),
        bottom: TabBar(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.white,
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overall', icon: Icon(Icons.monetization_on)),
            Tab(text: 'Earnings', icon: Icon(Icons.arrow_upward)),
            Tab(text: 'Expenses', icon: Icon(Icons.arrow_downward)),
          ],
        ),
      ),

      drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [

              // 🔷 HEADER (LOGO + APP NAME)
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Color(0xFF0F172A),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/et_app_icon.png',
                      width: 80,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Expense Tracker',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // 📊 EXPENSE CHART
              Card(
                child: ListTile(
                  leading: const Icon(Icons.bar_chart),
                  title: const Text("Expense Chart"),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExpenseChart(items: allItems),
                      ),
                    );
                  },
                ),
              ),

              // 📁 EXPORT PDF
              Card(
                child: ListTile(
                  leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                  title: const Text("Export as PDF"),
                  onTap: _exportPdf,
                ),
              ),

              // ⚙️ SETTINGS SCREEN TILE
              Card(
                child: ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text("Settings"),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsScreen(),
                      ),
                    );
                    _loadData();
                  },
                ),
              ),

              // ℹ️ ABOUT
              Card(
                child: ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text("About"),
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: "Expense Tracker",
                      applicationVersion: "1.0.0",
                      children: const [
                        Text("Simple expense tracking app built with Flutter."),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),


      ),

      body: Column(
        children: [
          Row(
            children: [
              BuildSummaryCard(
                  title: 'Earnings',
                  amount: totalEarnings,
                  cardColor: Colors.greenAccent),
              BuildSummaryCard(
                  title: 'Expenses',
                  amount: totalExpenses,
                  cardColor: Colors.redAccent),
              BuildSummaryCard(
                  title: 'Balance',
                  amount: balance,
                  cardColor: Colors.amberAccent),
            ],
          ),

          const SizedBox(height: 10),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                BuildLIst(
                  items: overallItems,
                  onDelete: _deleteItem,
                ),
                BuildLIst(
                  items: earnings,
                  onDelete: _deleteItem,
                ),
                BuildLIst(
                  items: expenses,
                  onDelete: _deleteItem,
                ),
              ],
            ),
          )
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showOptions(context);
        },
        backgroundColor: Colors.amberAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
