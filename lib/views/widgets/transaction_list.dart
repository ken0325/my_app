import 'package:flutter/material.dart';
import '../../model/data.dart';
import '../../api/dataApi.dart';

class TransactionList extends StatefulWidget {
  final int selectedMonth;
  final int selectedYear;

  const TransactionList({
    super.key,
    required this.selectedMonth,
    required this.selectedYear,
  });

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  List<Data>? list;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    list = await DataApi().getData();
    setState(() {});
  }

  List<Data> get _filteredTransactions {
    return list?.where((tx) {
          return tx.date.year == widget.selectedYear &&
              tx.date.month == widget.selectedMonth;
        }).toList() ??
        [];
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredTransactions;
    final Map<DateTime, List<Data>> groupedByDay = {};
    for (final tx in filtered) {
      final d = tx.date as DateTime;
      final key = DateTime(d.year, d.month, d.day);
      groupedByDay.putIfAbsent(key, () => []).add(tx);
    }

    final sortedKeys = groupedByDay.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return Expanded(
      child: sortedKeys.isEmpty
          ? const Center(child: Text('本月沒有交易'))
          : ListView.builder(
              itemCount: sortedKeys.length,
              itemBuilder: (context, index) {
                final day = sortedKeys[index];
                final txs = groupedByDay[day]!;
                return _buildDaySection(day, txs.cast<Data>());
              },
            ),
    );
  }

  // ✅ 新增智慧格式化函數
  // String _formatAmount(double amount) {
  //   if (amount == amount.roundToDouble()) {
  //     return '\$${amount.round().toString()}';
  //   }
  //   return '\$$amount';
  // }

  Widget _buildDaySection(DateTime day, List<Data> transactions) {
    final dateLabel =
        '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';

    final dayIncome = transactions
        .where((tx) => tx.isIncome)
        .fold<double>(0, (sum, tx) => sum + (tx.amount as double));
    final dayExpense = transactions
        .where((tx) => !tx.isIncome)
        .fold<double>(0, (sum, tx) => sum + (tx.amount as double).abs());
    final dayBalance = dayIncome - dayExpense;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ 日期 + 總結（完全對齊）
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              // color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Row(
              children: [
                // 日期（左對齊）
                Expanded(
                  flex: 2,
                  child: Text(
                    dateLabel,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                // 收入（固定寬度）
                Expanded(
                  flex: 2,
                  child: _buildDaySummaryItem(
                    '收入',
                    dayIncome,
                    Colors.greenAccent,
                  ),
                ),
                // 支出（固定寬度）
                Expanded(
                  flex: 2,
                  child: _buildDaySummaryItem(
                    '支出',
                    dayExpense,
                    Colors.redAccent,
                  ),
                ),
                // 餘額（固定寬度，右對齊）
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      // '\$${dayBalance.toStringAsFixed(1)}',
                      // '${_formatAmount(dayBalance)}',
                      '\$${DataApi().formatAmountToString(dayBalance)}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: dayBalance >= 0
                            ? Colors.green
                            : Colors.redAccent,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 交易明細
          Padding(
            padding: const EdgeInsets.only(left: 14, right: 14, bottom: 14),
            child: Column(
              children: transactions.map(_buildTransactionTile).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDaySummaryItem(String label, double amount, Color color) {
    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            // _formatAmount(amount), // ✅ 智慧格式化
             '\$${DataApi().formatAmountToString(amount)}', // ✅ 智慧格式化
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionTile(Data tx) {
    final double amount = tx.amount as double;
    // final String formattedAmount = _formatAmount(amount.abs());
    final String formattedAmount =  DataApi().formatAmountToString(amount.abs());

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: tx.isIncome
                  ? const Color(0xFFE0FCE5)
                  : const Color(0xFFFFE4E6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              tx.isIncome
                  ? Icons.arrow_downward_rounded
                  : Icons.arrow_upward_rounded,
              color: tx.isIncome ? Colors.green : Colors.redAccent,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.category as String,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  tx.description as String,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${tx.isIncome ? '+' : '-'}$formattedAmount', // ✅ 智慧格式化
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: tx.isIncome ? Colors.green : Colors.redAccent,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}
