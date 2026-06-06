import 'package:flutter/material.dart';
import '../Models/expense.dart';

class BuildLIst extends StatelessWidget {
  final List<Expense> items;
  final Function(int) onDelete;

  const BuildLIst({
    super.key,
    required this.items,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    void showAlert(int index) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.blue.shade50,
          title: const Text('Warning'),
          content: const Text(
            'Are you sure that you want to delete this item?',
          ),
          icon: const Icon(Icons.delete, color: Colors.redAccent),
          actions: [
            TextButton(
              onPressed: () {
                onDelete(index);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("The item has been removed!")),
                );
                Navigator.pop(context);
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('No'),
            ),
          ],
        ),
      );
    }

    return Card(
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {

          final item = items[index]; // ✅ CLEAN

          bool itemIsEarning = item.isEarning;

          IconData icon =
          itemIsEarning ? Icons.arrow_upward : Icons.arrow_downward;

          Color avatarColor =
          itemIsEarning ? Colors.green : Colors.red;

          return Dismissible(
            key: Key("${items[index].title}_${items[index].date}"),

            direction: DismissDirection.endToStart,

            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),

            confirmDismiss: (direction) async {
              showAlert(index);
              return false;
            },

            child: ListTile(
              leading: CircleAvatar(
                radius: 15,
                backgroundColor: avatarColor,
                child: Icon(icon, color: Colors.white),
              ),

              title: Text(item.title),

              subtitle: Text(
                "${items[index].date.day}/${items[index].date.month}/${items[index].date.year}",
              ),

              trailing: Text(
                item.amount.toString(),
                style: TextStyle(
                  fontSize: 16,
                  color: itemIsEarning ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}