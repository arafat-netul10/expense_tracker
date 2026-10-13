import 'package:flutter/material.dart';

class BuildSummaryCard extends StatelessWidget {

  final String title;
  final double amount;
  final Color cardColor;

  const BuildSummaryCard({
    super.key, required this.title, required this.amount, required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        color: cardColor,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            height: 80.0,
            child: Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  amount.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
