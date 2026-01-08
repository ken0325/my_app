import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatefulWidget {
  const TransactionList({super.key});

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  // 模擬交易數據
  final List<Map<String, dynamic>> _transactions = [
    {'amount': 45.0, 'note': '麥當勞午餐', 'category': '餐飲', 'date': DateTime(2026, 1, 7), 'isIncome': false},
    {'amount': 12.5, 'note': '地鐵上班', 'category': '交通', 'date': DateTime(2026, 1, 7), 'isIncome': false},
    {'amount': 120.0, 'note': '超市購物', 'category': '購物', 'date': DateTime(2026, 1, 7), 'isIncome': false},
    {'amount': 250.0, 'note': '自由工作者收入', 'category': '收入', 'date': DateTime(2026, 1, 7), 'isIncome': true},
    {'amount': 68.0, 'note': '咖啡下午茶', 'category': '餐飲', 'date': DateTime(2026, 1, 6), 'isIncome': false},
    {'amount': 35.0, 'note': '公車回家', 'category': '交通', 'date': DateTime(2026, 1, 6), 'isIncome': false},
    {'amount': 89.0, 'note': 'Netflix月費', 'category': '娛樂', 'date': DateTime(2026, 1, 5), 'isIncome': false},
    {'amount': 5000.0, 'note': '月薪', 'category': '收入', 'date': DateTime(2026, 1, 1), 'isIncome': true},
  ];
  
  // 🔥 核心邏輯：按日期分組並計算每日總額
  List<Map<String, dynamic>> get _dailySummary {
    Map<String, Map<String, double>> dailyData = {};

    for (var tx in _transactions) {
      String dateKey = DateFormat('yyyy-MM-dd').format(tx['date']);
      if (!dailyData.containsKey(dateKey)) {
        dailyData[dateKey] = {'income': 0.0, 'expense': 0.0};
      }
      if (tx['isIncome']) {
        dailyData[dateKey]!['income'] =
            dailyData[dateKey]!['income']! + tx['amount'];
      } else {
        dailyData[dateKey]!['expense'] =
            dailyData[dateKey]!['expense']! + tx['amount'];
      }
    }

    List<Map<String, dynamic>> summary = [];
    dailyData.forEach((date, amounts) {
      double net = amounts['income']! - amounts['expense']!;
      summary.add({
        'date': date,
        'dateObj': DateTime.parse(date),
        'income': amounts['income']!,
        'expense': amounts['expense']!,
        'net': net,
      });
    });

    // 按日期降序排列（最近的日期在最上面）
    summary.sort((a, b) => b['dateObj'].compareTo(a['dateObj']));
    return summary;
  }

  @override
  Widget build(BuildContext context) {
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
                // 趨勢圖示
                // Container(
                //   padding: const EdgeInsets.all(8),
                //   decoration: BoxDecoration(
                //     color: hasNetPositive ? Colors.green[50] : Colors.red[50],
                //     borderRadius: BorderRadius.circular(12),
                //   ),
                //   child: Icon(
                //     hasNetPositive ? Icons.trending_up : Icons.trending_down,
                //     color: hasNetPositive ? Colors.green[600] : Colors.red[600],
                //     size: 20,
                //   ),
                // ),
                // const SizedBox(width: 12),

                // 日期
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, //垂直方向居中对齐
                    children: [
                      Text(
                        // DateFormat('MM月dd日 EEE').format(day['dateObj']),
                        DateFormat('yyyy/MM/dd EEEE', 'zh_CN').format(day['dateObj']),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        // '${hasNetPositive ? '+' : '-'}\$${day['net'].abs().toStringAsFixed(0)}',
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
                    ]
                  ),
                  // child: Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Text(
                  //       DateFormat('MM月dd日 EEE').format(day['dateObj']),
                  //       style: Theme.of(context).textTheme.titleMedium
                  //           ?.copyWith(fontWeight: FontWeight.w600),
                  //     ),
                  //     Text(
                  //       '淨額 ${hasNetPositive ? '+' : ''}${day['net'].toStringAsFixed(0)}',
                  //       style: TextStyle(
                  //         color: hasNetPositive
                  //             ? Colors.green[600]
                  //             : Colors.red[600],
                  //         fontWeight: FontWeight.w500,
                  //         fontSize: 14,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ),

                // 右上角箭頭（可選）
                // Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
              ],
            ),

            Divider(indent: 0, endIndent: 0, color: Colors.black, thickness: 2,),

            // const SizedBox(height: 16),

            // 2. 每日總結數字（收入 | 支出）
            // _buildDailySummaryRow(day),

            // const SizedBox(height: 20),

            // ..._getTransactionsForDate(
            //   day['date'],
            // ).map((tx) => _buildTransactionItem(context, tx)),

            ..._getTransactionsForDate(day['date']).asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, dynamic> tx = entry.value;
              
              List<Widget> items = [];
              if (index > 0) {
                items.add( Divider(height: 10, thickness: 1, color: Colors.grey[300]));  // 除了第一個外都加Divider
              }
              items.add(_buildTransactionItem(context, tx));
              
              return items;
            }).expand((item) => item).toList(),



            // 3. 該日所有明細交易（最多顯示3筆）
            // ..._getTransactionsForDate(day['date'])
            //     .take(3)  // 只顯示最近3筆
            //     .map((tx) => _buildTransactionItem(context, tx))
            //     .toList(),

            // 4. 如果有更多交易，顯示「查看全部」
            // if (_getTransactionsForDate(day['date']).length > 3) ...[
            //   const SizedBox(height: 12),
            //   Center(
            //     child: TextButton(
            //       onPressed: () {
            //         // TODO: 跳到該日詳細頁面
            //       },
            //       child: Text(
            //         '查看${_getTransactionsForDate(day['date']).length}筆交易 >',
            //         style: TextStyle(color: Colors.blue[600]),
            //       ),
            //     ),
            //   ),
            // ],
          ],
        ),
      ),
    );
    // return Container(
    //   margin: const EdgeInsets.only(bottom: 12),
    //   decoration: BoxDecoration(
    //     color: Colors.white,
    //     borderRadius: BorderRadius.circular(16),
    //     boxShadow: [
    //       BoxShadow(
    //         color: Colors.black.withOpacity(0.06),
    //         blurRadius: 12,
    //         offset: const Offset(0, 4),
    //       ),
    //     ],
    //   ),
    //   child: ExpansionTile(
    //     leading: Container(
    //       padding: const EdgeInsets.all(8),
    //       decoration: BoxDecoration(
    //         color: hasNetPositive ? Colors.green[50] : Colors.red[50],
    //         borderRadius: BorderRadius.circular(12),
    //       ),
    //       child: Icon(
    //         hasNetPositive ? Icons.trending_up : Icons.trending_down,
    //         color: hasNetPositive ? Colors.green[600] : Colors.red[600],
    //         size: 20,
    //       ),
    //     ),
    //     title: Text(
    //       DateFormat('MM月dd日 EEE').format(day['dateObj']),
    //       style: Theme.of(context).textTheme.titleMedium?.copyWith(
    //         fontWeight: FontWeight.w600,
    //       ),
    //     ),
    //     subtitle: Text(
    //       '淨額 ${hasNetPositive ? '+' : ''}${day['net'].toStringAsFixed(0)}',
    //       style: TextStyle(
    //         color: hasNetPositive ? Colors.green[600] : Colors.red[600],
    //         fontWeight: FontWeight.w500,
    //         fontSize: 14,
    //       ),
    //     ),
    //     childrenPadding: const EdgeInsets.only(left: 20, right: 16, bottom: 16),
    //     expandedCrossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       // 🔥 每日總結數字
    //       _buildDailySummaryRow(day),
    //       const SizedBox(height: 12),

    //       // 🔥 該日所有明細交易
    //       ..._getTransactionsForDate(day['date']).map((tx) => _buildTransactionItem(context, tx)),
    //     ],
    //   ),
    // );
  }

  // Widget _buildDailySummaryRow(Map<String, dynamic> day) {
  //   return Row(
  //     children: [
  //       Expanded(
  //         child: _buildAmountRow(
  //           '收入',
  //           'HK\$${day['income'].toStringAsFixed(0)}',
  //           Colors.green[400]!,
  //         ),
  //       ),
  //       Container(width: 1, height: 32, color: Colors.grey[300]),
  //       Expanded(
  //         child: _buildAmountRow(
  //           '支出',
  //           'HK\$${day['expense'].toStringAsFixed(0)}',
  //           Colors.red[400]!,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildAmountRow(String label, String amount, Color color) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
  //       Text(
  //         amount,
  //         style: TextStyle(
  //           fontSize: 16,
  //           fontWeight: FontWeight.bold,
  //           color: color,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  List<Map<String, dynamic>> _getTransactionsForDate(String dateKey) {
    return _transactions.where((tx) {
      return DateFormat('yyyy-MM-dd').format(tx['date']) == dateKey;
    }).toList();
  }

  Widget _buildTransactionItem(BuildContext context, Map<String, dynamic> tx) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: _getCategoryColor(tx['category']),
            child: Text(
              tx['category'][0],
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
                  '${tx['category']}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  tx['note'], 
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),

              ],
            ),
          ),
          Text(
            '${tx['isIncome'] ? '+' : '-'}\$${tx['amount'].toStringAsFixed(1)}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: tx['isIncome'] ? Colors.green[600] : Colors.red[600],
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
