import 'package:flutter/material.dart';
import '../Services/expense_service.dart';
import '../main.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void _showClearDataDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirm"),
        content: const Text("Delete all data? This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              final messenger = ScaffoldMessenger.of(context);
              await ExpenseService.clearAll();
              navigator.pop();
              messenger.showSnackBar(
                const SnackBar(content: Text("All data cleared successfully!")),
              );
              setState(() {});
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),

          // 🌙 DARK MODE TILE
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text("Dark Mode"),
              subtitle: const Text("Toggle dark or light app theme"),
              trailing: Switch(
                value: MyApp.of(context).isDark,
                onChanged: (value) {
                  MyApp.of(context).toggleTheme(value);
                  setState(() {});
                },
              ),
            ),
          ),

          // 🗑️ CLEAR ALL DATA TILE
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text(
                "Clear All Data",
                style: TextStyle(color: Colors.red),
              ),
              subtitle: const Text("Delete all recorded expenses & earnings"),
              onTap: _showClearDataDialog,
            ),
          ),
        ],
      ),
    );
  }
}
