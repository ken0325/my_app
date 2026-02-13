import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../../model/data.dart';
// import '../../api/dataApi.dart';

import '../../models/transaction.dart';
import '../../controllers/controller.dart';
import '../addTransaction.dart';

class TransactionList extends StatefulWidget {
  // final int selectedMonth;
  // final int selectedYear;
  final List<Transaction> transactions;

  const TransactionList({
    super.key,
    // required this.selectedMonth,
    // required this.selectedYear,
    required this.transactions,
  });

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  // List<Data>? list;
  final Controller _controller = Controller();
  // List<Transaction> transactions = [];
  // bool isLoading = true;
  // List<Transaction>? list2;

  @override
  void initState() {
    super.initState();
    // _getData();
    // _loadData();
  }

  // Future<void> _getData() async {
  //   list = await DataApi().getData();
  //   setState(() {});
  // }

  // List<Data> get _filteredTransactions {
  //   return list?.where((tx) {
  //         return tx.date.year == widget.selectedYear &&
  //             tx.date.month == widget.selectedMonth;
  //       }).toList() ??
  //       [];
  // }

  // Future<void> _loadData() async {
  //   final fetchedTransactions = await _controller.getAllTransactions();
  //   setState(() {
  //     transactions = fetchedTransactions;
  //     isLoading = false;
  //   });
  //   // print(fetchedTransactions);
  // }

  // List<Transaction> get _filteredTransactions2 {
  //   return transactions.where((tx) {
  //     final date = DateTime.parse(tx.date); // 字串轉 DateTime
  //     return date.year == widget.selectedYear &&
  //         date.month == widget.selectedMonth;
  //   }).toList();
  // }

  @override
  Widget build(BuildContext context) {
    // final filtered = _filteredTransactions;

    // final filtered = _filteredTransactions2;
    // final filtered = widget.transactions;

    // final Map<DateTime, List<Data>> groupedByDay = {};
    // for (final tx in filtered) {
    //   final d = tx.date as DateTime;
    //   final key = DateTime(d.year, d.month, d.day);
    //   groupedByDay.putIfAbsent(key, () => []).add(tx);
    // }

    // if (isLoading) {
    //   return const Center(child: CircularProgressIndicator());
    // }

    final Map<DateTime, List<Transaction>> groupedByDay = {};
    for (final tx in widget.transactions) {
      final date = DateTime.parse(tx.date);
      final key = DateTime(date.year, date.month, date.day);
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
                // return _buildDaySection(day, txs.cast<Data>());
                return _buildDaySection(day, txs);
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

  // Widget _buildDaySection(DateTime day, List<Data> transactions) {
  Widget _buildDaySection(DateTime day, List<Transaction> transactions) {
    final dateLabel =
        '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';

    // .where((tx) => tx.isIncome)
    final dayIncome = transactions
        .where((tx) => tx.type == 'income')
        .fold<double>(0, (sum, tx) => sum + (tx.amount as double));

    // .where((tx) => !tx.isIncome)
    final dayExpense = transactions
        .where((tx) => tx.type == 'expense')
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
                      // '${dayBalance >= 0 ? '+' : '-'}\$${DataApi().formatAmountToString(dayBalance.abs())}',
                      '${dayBalance >= 0 ? '+' : '-'}\$${_controller.formatAmountToString(dayBalance.abs())}',
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
            // '\$${DataApi().formatAmountToString(amount)}', // ✅ 智慧格式化
            '\$${_controller.formatAmountToString(amount)}', // ✅ 智慧格式化
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

  // Widget _buildTransactionTile(Data tx) {
  //   final double amount = tx.amount as double;
  //   // final String formattedAmount = _formatAmount(amount.abs());
  //   final String formattedAmount = DataApi().formatAmountToString(amount.abs());

  //   return Container(
  //     margin: const EdgeInsets.only(bottom: 8),
  //     decoration: BoxDecoration(
  //       color: const Color(0xFFF8F9FA),
  //       borderRadius: BorderRadius.circular(12),
  //       border: Border.all(color: Colors.grey.shade100),
  //     ),
  //     padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
  //     child: Row(
  //       children: [
  //         Container(
  //           width: 38,
  //           height: 38,
  //           decoration: BoxDecoration(
  //             color: tx.isIncome
  //                 ? const Color(0xFFE0FCE5)
  //                 : const Color(0xFFFFE4E6),
  //             borderRadius: BorderRadius.circular(12),
  //           ),
  //           child: Icon(
  //             tx.isIncome
  //                 ? Icons.arrow_downward_rounded
  //                 : Icons.arrow_upward_rounded,
  //             color: tx.isIncome ? Colors.green : Colors.redAccent,
  //             size: 20,
  //           ),
  //         ),
  //         const SizedBox(width: 12),
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 tx.category as String,
  //                 style: const TextStyle(
  //                   fontSize: 15,
  //                   fontWeight: FontWeight.w500,
  //                 ),
  //               ),
  //               const SizedBox(height: 2),
  //               Text(
  //                 tx.description as String,
  //                 style: const TextStyle(fontSize: 12, color: Colors.grey),
  //                 maxLines: 1,
  //                 overflow: TextOverflow.ellipsis,
  //               ),
  //             ],
  //           ),
  //         ),
  //         const SizedBox(width: 8),
  //         Text(
  //           '${tx.isIncome ? '+' : '-'}\$$formattedAmount', // ✅ 智慧格式化
  //           style: TextStyle(
  //             fontSize: 15,
  //             fontWeight: FontWeight.w600,
  //             color: tx.isIncome ? Colors.green : Colors.redAccent,
  //             fontFamily: 'monospace',
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  Widget _buildTransactionTile(Transaction tx) {
    final categoryName = tx.categoryName;
    IconData categoryIcon = Controller.getIconData(tx.icon ?? 'category');

    return InkWell(
      // onTap: () {
      //   // Code to execute when the container is tapped
      //   // print(tx.type);

      // },
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddTransactionScreen(
              onTransactionSaved: null,
              transaction: tx,
              isUpdate: true,
            ),
          ),
        ),
      },
      splashColor: Colors.white.withAlpha(
        30,
      ), // Optional: customize ripple color
      highlightColor: Colors.blue.withAlpha(
        50,
      ), // Optional: customize highlight color
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade100),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            // 圖示
            // Container(
            //   width: 38,
            //   height: 38,
            //   decoration: BoxDecoration(
            //     color: tx.type == 'income' ? Colors.green[100] : Colors.red[100],
            //     borderRadius: BorderRadius.circular(12),
            //   ),
            //   child: Icon(
            //     categoryIcon,
            //     // color: tx.type == 'income' ? Colors.green : Colors.red,
            //     color: Colors.black,
            //     size: 20,
            //   ),
            // ),
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: tx.type == 'income'
                    ? Colors.green[100]
                    : Colors.red[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.black,
                  width: 2.0,
                  style: BorderStyle.solid,
                ),
              ),
              child: Icon(
                categoryIcon,
                // color: tx.type == 'income' ? Colors.green : Colors.red,
                color: Colors.black,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            // 內容
            tx.description == null
                ? Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          categoryName,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                : Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          categoryName,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          tx.description ?? '',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
            // 金額
            Text(
              // '${tx.type == 'income' ? '+' : '-'}\$${tx.amount.abs().toStringAsFixed(1)}',
              '${tx.type == 'income' ? '+' : '-'}\$${_controller.formatAmountToString(tx.amount)}',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: tx.type == 'income' ? Colors.green : Colors.red,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
      ),
    );

    // return Container(
    //   margin: const EdgeInsets.only(bottom: 8),
    //   decoration: BoxDecoration(
    //     color: const Color(0xFFF8F9FA),
    //     borderRadius: BorderRadius.circular(12),
    //     border: Border.all(color: Colors.grey.shade100),
    //   ),
    //   padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    //   child: Row(
    //     children: [
    //       // 圖示
    //       // Container(
    //       //   width: 38,
    //       //   height: 38,
    //       //   decoration: BoxDecoration(
    //       //     color: tx.type == 'income' ? Colors.green[100] : Colors.red[100],
    //       //     borderRadius: BorderRadius.circular(12),
    //       //   ),
    //       //   child: Icon(
    //       //     categoryIcon,
    //       //     // color: tx.type == 'income' ? Colors.green : Colors.red,
    //       //     color: Colors.black,
    //       //     size: 20,
    //       //   ),
    //       // ),
    //       Container(
    //         width: 38,
    //         height: 38,
    //         decoration: BoxDecoration(
    //           color: tx.type == 'income' ? Colors.green[100] : Colors.red[100],
    //           borderRadius: BorderRadius.circular(12),
    //           border: Border.all(
    //             color: Colors.black,
    //             width: 2.0,
    //             style: BorderStyle.solid,
    //           ),
    //         ),
    //         child: Icon(
    //           categoryIcon,
    //           // color: tx.type == 'income' ? Colors.green : Colors.red,
    //           color: Colors.black,
    //           size: 20,
    //         ),
    //       ),
    //       const SizedBox(width: 12),
    //       // 內容
    //       tx.description == null
    //           ? Expanded(
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   Text(
    //                     categoryName,
    //                     style: const TextStyle(
    //                       fontSize: 15,
    //                       fontWeight: FontWeight.w500,
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             )
    //           : Expanded(
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   Text(
    //                     categoryName,
    //                     style: const TextStyle(
    //                       fontSize: 15,
    //                       fontWeight: FontWeight.w500,
    //                     ),
    //                   ),
    //                   const SizedBox(height: 2),
    //                   Text(
    //                     tx.description ?? '',
    //                     style: const TextStyle(
    //                       fontSize: 12,
    //                       color: Colors.grey,
    //                     ),
    //                     maxLines: 1,
    //                     overflow: TextOverflow.ellipsis,
    //                   ),
    //                 ],
    //               ),
    //             ),
    //       // 金額
    //       Text(
    //         '${tx.type == 'income' ? '+' : '-'}\$${tx.amount.abs().toStringAsFixed(1)}',
    //         style: TextStyle(
    //           fontSize: 15,
    //           fontWeight: FontWeight.w600,
    //           color: tx.type == 'income' ? Colors.green : Colors.red,
    //           fontFamily: 'monospace',
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
