import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  // 先根據 selectedYear / selectedMonth 過濾一份「當月資料」
  List<Data> get _monthlyTransactions {
    return list?.where((tx) {
          return tx.date.year == widget.selectedYear &&
              tx.date.month == widget.selectedMonth;
        }).toList() ??
        [];
  }

  // 核心邏輯：按日期分組並計算每日總額
  List<Map<String, dynamic>> get _dailySummary {
    final Map<String, Map<String, double>> dailyData = {};

    for (var tx in _monthlyTransactions) {
      final String dateKey = DateFormat('yyyy-MM-dd').format(tx.date);
      dailyData.putIfAbsent(dateKey, () => {'income': 0.0, 'expense': 0.0});

      final income = dailyData[dateKey]!['income']!;
      final expense = dailyData[dateKey]!['expense']!;

      if (tx.isIncome as bool) {
        dailyData[dateKey]!['income'] = income + (tx.amount as double);
      } else {
        dailyData[dateKey]!['expense'] = expense + (tx.amount as double);
      }
    }

    final List<Map<String, dynamic>> summary = [];
    dailyData.forEach((date, amounts) {
      final double net = amounts['income']! - amounts['expense']!;
      summary.add({
        'date': date,
        'dateObj': DateTime.parse(date),
        'income': amounts['income']!,
        'expense': amounts['expense']!,
        'net': net,
      });
    });

    summary.sort(
      (a, b) => (b['dateObj'] as DateTime).compareTo(a['dateObj'] as DateTime),
    );
    return summary;
  }

  @override
  Widget build(BuildContext context) {
    if (_dailySummary.isEmpty) {
      return const Center(child: Text('本月沒有交易'));
    }

    return Column(
      children: _dailySummary
          .map((day) => _buildDailyCard(context, day))
          .toList(),
    );
  }

  Widget _buildDailyCard(BuildContext context, Map<String, dynamic> day) {
    bool hasNetPositive = day['net'] > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. 日期標題 + 淨額
            Row(
              children: [
                // 日期
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        // DateFormat('MM月dd日 EEE').format(day['dateObj']),
                        DateFormat(
                          'yyyy/MM/dd EEEE',
                          'zh_CN',
                        ).format(day['dateObj']),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '${hasNetPositive ? '+' : '-'}\$${day['net'].abs().toStringAsFixed(2)}',
                        style: TextStyle(
                          color: hasNetPositive
                              ? Colors.green[600]
                              : Colors.red[600],
                          // fontWeight: FontWeight.w500,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(indent: 0, endIndent: 0, color: Colors.black, thickness: 2),
            ..._getTransactionsForDate(day['date'])
                .asMap()
                .entries
                .map((entry) {
                  int index = entry.key;
                  Data tx = entry.value;
                  List<Widget> items = [];
                  if (index > 0) {
                    items.add(
                      Divider(
                        height: 10,
                        thickness: 1,
                        color: Colors.grey[300],
                      ),
                    );
                  }
                  items.add(_buildTransactionItem(context, tx));
                  return items;
                })
                .expand((item) => item)
                .toList(),
          ],
        ),
      ),
    );
  }

  List<Data> _getTransactionsForDate(String dateKey) {
    return _monthlyTransactions.where((tx) {
      return DateFormat('yyyy-MM-dd').format(tx.date) == dateKey;
    }).toList();
  }

  Widget _buildTransactionItem(BuildContext context, Data tx) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: _getCategoryColor(tx.category),
            child: Text(
              tx.category[0],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.category,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  // tx.note,
                  tx.description,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Text(
            '${tx.isIncome ? '+' : '-'}\$${tx.amount.toStringAsFixed(1)}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: tx.isIncome ? Colors.green[600] : Colors.red[600],
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case '餐飲':
        return Colors.orange[400]!;
      case '交通':
        return Colors.blue[400]!;
      case '購物':
        return Colors.purple[400]!;
      case '娛樂':
        return Colors.pink[400]!;
      case '收入':
        return Colors.green[400]!;
      default:
        return Colors.grey[400]!;
    }
  }
}
