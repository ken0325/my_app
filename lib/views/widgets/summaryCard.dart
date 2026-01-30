import 'package:flutter/material.dart';
// import '../../api/dataApi.dart';
import '../../controllers/controller.dart';
// import '../../model/data.dart';
// import '../../models/transaction.dart';

// class Summarycard extends StatelessWidget {
class Summarycard extends StatefulWidget {
  // final List<Data> filtered;
  final bool showOnlyThisMonth;
  // final double income;
  // final double expense;
  // final double balance;
  final Map<String, double> ieb;

  const Summarycard({
    super.key,
    // required this.filtered,
    required this.showOnlyThisMonth,
    // required this.income,
    // required this.expense,
    // required this.balance,
    required this.ieb,
  });

  @override
  State<Summarycard> createState() => _SummarycardState();
}

class _SummarycardState extends State<Summarycard> {
  final Controller _controller = Controller();

  double get balance => widget.ieb['balance'] ?? 0.0;
  double get income => widget.ieb['income'] ?? 0.0;
  double get expense => widget.ieb['expense'] ?? 0.0;

  @override
  Widget build(BuildContext context) {
    // final income = filtered
    //     .where((tx) => tx.isIncome == true)
    //     .fold<double>(0, (sum, tx) => sum + (tx.amount as double));

    // final expense = filtered
    //     .where((tx) => tx.isIncome == false)
    //     .fold<double>(0, (sum, tx) => sum + (tx.amount as double).abs());

    // final balance = income - expense;
    // final balance = monthlyIncome - monthlyExpense;

    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.showOnlyThisMonth ? '本月結餘' : '總結餘',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 6),
          Text(
            '\$${balance.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildSummaryItem(
                label: widget.showOnlyThisMonth ? '本月收入' : '總收入',
                amount: income,
                color: Colors.greenAccent,
              ),
              const SizedBox(width: 24),
              _buildSummaryItem(
                label: widget.showOnlyThisMonth ? '本月支出' : '總支出',
                amount: expense,
                color: Colors.redAccent,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({
    required String label,
    required double amount,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 2),
            Text(
              // '\$${amount.toStringAsFixed(2)}',
              // '\$${DataApi().formatAmountToString(amount)}',
              '\$${_controller.formatAmountToString(amount)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
