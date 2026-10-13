import '../Screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../Models/expense.dart';

class ExpenseChart extends StatelessWidget {
  final List<Expense> items;

  const ExpenseChart({super.key, required this.items});

  @override
  Widget build(BuildContext context) {

    double totalEarnings = items
        .where((e) => e.isEarning)
        .fold(0, (sum, e) => sum + e.amount);

    double totalExpenses = items
        .where((e) => !e.isEarning)
        .fold(0, (sum, e) => sum + e.amount);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Expense Chart',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),

      body: Card(
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                "Overview",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            if (value == 0) return const Text("Earn");
                            if (value == 1) return const Text("Spend");
                            return const Text("");
                          },
                        ),
                      ),
                    ),

                    barGroups: [
                      BarChartGroupData(x: 0, barRods: [
                        BarChartRodData(
                          toY: totalEarnings,
                          color: Colors.green,
                          width: 20,
                        )
                      ]),
                      BarChartGroupData(x: 1, barRods: [
                        BarChartRodData(
                          toY: totalExpenses,
                          color: Colors.red,
                          width: 20,
                        )
                      ]),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
