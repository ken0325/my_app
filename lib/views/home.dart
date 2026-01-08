import 'package:my_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../views/widgets/add_transaction_dialog.dart';
import '../views/widgets/transaction_list.dart';

class HomeScreen extends StatefulWidget {
  // const HomeScreen({Key? key}) : super(key: key);
  const HomeScreen({super.key});

  @override
  // _HomeScreenState createState() => _HomeScreenState();
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedPeriod = 0; // 0:月, 1:週, 2:日
  double totalExpense = 9035;
  double totalIncome = 40790;
  double balance = 31755;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('記帳App'),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.account_balance_wallet),
          //   onPressed: () {
          //     ScaffoldMessenger.of(
          //       context,
          //     ).showSnackBar(const SnackBar(content: Text('總結餘: 1,234.56')));
          //   },
          // ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(''),
            ),
            ListTile(
              title: const Text('Settings'),
              onTap: () {
                Navigator.popAndPushNamed(context, "setting");
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 1. 圓餅圖 + 總覽 (參考圖片主畫面)
            _buildPieChartSection(),
            const SizedBox(height: 24),

            // 2. 日期篩選
            // _buildDateFilter(),
            // const SizedBox(height: 24),

            // 3. 最近交易列表
            _buildTransactionSection(),
          ],
        ),
      ),
      // floatingActionButton: Container(
      //   decoration: const BoxDecoration(
      //     color: Colors.white,
      //     boxShadow: [
      //       BoxShadow(
      //         color: Colors.black12,
      //         blurRadius: 10,
      //         offset: Offset(0, 4),
      //       ),
      //     ],
      //   ),
      //   child: FloatingActionButton(
      //     backgroundColor: Colors.blue[600],
      //     foregroundColor: Colors.white,
      //     onPressed: () => _showAddTransaction(context),
      //     child: const Icon(Icons.add, size: 28),
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        // onPressed: () => _showAddTransaction(context),
        onPressed: () => Navigator.pushNamed(context, "addTransaction"),
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 3, color: Colors.black),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Icon(Icons.add, size: 28, color: Colors.white,),
      ),
    );
  }

  // 🔥 圓餅圖 + 總覽區 (完全對應你的參考圖)
  Widget _buildPieChartSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // 圓餅圖
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    value: 9035, // 支出
                    color: Colors.red[400]!,
                    radius: 60,
                    title: 'HK\$9,035',
                    titleStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    value: 22755, // 結餘
                    color: Colors.blue[400]!,
                    radius: 60,
                    title: 'HK\$22,755',
                    titleStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
                sectionsSpace: 2,
                centerSpaceRadius: 40,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // 總覽數字
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildOverviewItem('總支出', 'HK\$9,035', Colors.red[400]!),
              _buildOverviewItem('總收入', 'HK\$40,790', Colors.green[400]!),
              _buildOverviewItem('結餘', 'HK\$31,755', Colors.blue[400]!),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewItem(String label, String amount, Color color) {
    return Column(
      children: [
        Text(
          amount,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  // 日期篩選列 (參考圖片第二個畫面)
  // Widget _buildDateFilter() {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(16),
  //       boxShadow: [
  //         BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
  //       ],
  //     ),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //       children: [
  //         _buildFilterChip('月', 0),
  //         _buildFilterChip('週', 1),
  //         _buildFilterChip('日', 2),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildFilterChip(String label, int index) {
  //   return GestureDetector(
  //     onTap: () => setState(() => selectedPeriod = index),
  //     child: Container(
  //       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //       decoration: BoxDecoration(
  //         color: selectedPeriod == index ? Colors.blue[50] : Colors.transparent,
  //         borderRadius: BorderRadius.circular(25),
  //         border: Border.all(
  //           color: selectedPeriod == index ? Colors.blue : Colors.grey[300]!,
  //         ),
  //       ),
  //       child: Text(
  //         label,
  //         style: TextStyle(
  //           fontWeight: selectedPeriod == index
  //               ? FontWeight.w600
  //               : FontWeight.normal,
  //           color: selectedPeriod == index
  //               ? Colors.blue[700]
  //               : Colors.grey[700],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // 交易列表區
  Widget _buildTransactionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Text('最近交易', style: Theme.of(context).textTheme.titleLarge),
        //     TextButton(onPressed: () {}, child: const Text('查看全部 >')),
        //   ],
        // ),
        const SizedBox(height: 16),
        TransactionList(),
        const SizedBox(height: 64),
      ],
    );
  }

  void _showAddTransaction(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const AddTransactionDialog(),
    );
  }
}
