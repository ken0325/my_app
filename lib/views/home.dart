import 'package:flutter/material.dart';
// import 'package:my_app/api/dataApi.dart';
// import '../model/data.dart';
import '../models/transaction.dart';
import '../views/widgets/Summarycard.dart';
import '../views/widgets/categoryRow.dart';

import '../controllers/controller.dart';
import '../views/widgets/transaction_list.dart';
import 'addTransaction.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Controller _controller = Controller();
  List<Transaction> transactions = [];
  bool isLoading = true;
  // List<Transaction>? list2;

  bool _showOnlyThisMonth = true;
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;

  // double income = 0;
  // double expense = 0;
  // double balance = 0;

  Map<String, double> ieb = {};

  List<Map<String, dynamic>> qqq = [];

  // List<Data>? list;

  // List<Data>? get _filteredTransactions {
  //   if (!_showOnlyThisMonth) return list;

  //   return list?.where((tx) {
  //     final d = tx.date;
  //     return d.year == selectedYear && d.month == selectedMonth;
  //   }).toList();
  // }

  @override
  void initState() {
    super.initState();
    // _getData();
    // _loadData();
    _loadTransactions();
  }

  // Future<void> _getData() async {
  //   list = await DataApi().getData();
  //   setState(() {});
  // }

  // Future<void> _loadData() async {
  //   final fetchedTransactions = await _controller.getAllTransactions();

  //   setState(() {
  //     transactions = fetchedTransactions;
  //     isLoading = false;
  //   });
  //   // print(fetchedTransactions);
  // }

  Future<void> _loadTransactions() async {
    transactions.clear();
    String yearMonth =
        '${selectedYear}-${selectedMonth.toString().padLeft(2, '0')}';
    final data = await _controller.getTransactionsByMonth(yearMonth);

    // final getIncome = await _controller.getMonthlyIncome(yearMonth);
    // final getExpense = await _controller.getMonthlyExpense(yearMonth);

    ieb = await _controller.getIncomeAndExpenseAndBalance(
      yearMonth,
      _showOnlyThisMonth,
    );

    qqq = await _controller.getCategoryExpenseSummary(
      yearMonth,
      _showOnlyThisMonth,
    );

    setState(() {
      transactions = data;
      // income = getIncome;
      // expense = getExpense;
      // balance = income - expense;
    });
    // print(monthlyIncome);
    // print(monthlyExpense);
  }

  // List<Transaction>? get _filteredTransactions2 {
  //   if (!_showOnlyThisMonth) return list2;

  //   return list2?.where((tx) {
  //     final d = tx.date;
  //     return d.year == selectedYear && d.month == selectedMonth;
  //   }).toList();
  // }

  @override
  Widget build(BuildContext context) {
    // final filtered = _filteredTransactions;
    // final filtered = _filteredTransactions2;

    // print(qqq);

    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF5F5F7),
        centerTitle: true,
        title: GestureDetector(
          onTap: () => _showYearMonthDialog(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$selectedMonth 月 $selectedYear 年 ',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const Icon(Icons.arrow_drop_down, size: 25),
              ],
            ),
          ),
        ),
        actions: [
          Container(
            height: 34,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextButton(
              onPressed: () {
                setState(() {
                  _showOnlyThisMonth = !_showOnlyThisMonth;
                  _loadTransactions();
                });
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.all(1),
                minimumSize: Size.zero,
              ),
              child: Text(
                _showOnlyThisMonth == true ? '本月' : '全部',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.calendar_today_outlined),
            color: Colors.black,
          ),
        ],
      ),
      // drawer: Drawer(
      //   child: ListView(
      //     padding: EdgeInsets.zero,
      //     children: [
      //       const DrawerHeader(
      //         decoration: BoxDecoration(color: Colors.blue),
      //         child: Text(''),
      //       ),
      //       ListTile(
      //         title: const Text('Settings'),
      //         onTap: () {
      //           Navigator.popAndPushNamed(context, "setting");
      //         },
      //       ),
      //     ],
      //   ),
      // ),
      drawer: Drawer(
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // 簡潔 Header
            Container(
              height: 160,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                ),
                borderRadius: BorderRadius.only(topRight: Radius.circular(20)),
              ),
              padding: const EdgeInsets.all(24),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 頭像
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white70,
                    child: Icon(
                      Icons.person_outline,
                      size: 28,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(width: 16),
                  // 姓名
                  Text(
                    '李小明',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            // 簡潔選單
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 80),
                children: [
                  _buildMenuItem(Icons.home_outlined, '首頁', 'home'),
                  _buildMenuItem(Icons.analytics_outlined, '統計', '/'),
                  _buildMenuItem(Icons.trending_up_outlined, '報告', '/'),
                  _buildMenuItem(Icons.settings_outlined, '設定', 'setting'),
                  _buildMenuItem(Icons.logout_outlined, '登出', '/'),
                ],
              ),
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 動態計算的總結卡片
              Summarycard(
                // filtered: filtered ?? [],
                showOnlyThisMonth: _showOnlyThisMonth,
                // income: income,
                // expense: expense,
                // balance: balance,
                ieb: ieb,
              ),
              const SizedBox(height: 16),
              // 動態計算的分類統計
              Categoryrow(
                categoryList: qqq,
                showOnlyThisMonth: _showOnlyThisMonth,
              ),
              const SizedBox(height: 20),
              const Text(
                '最近紀錄',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              // TransactionList(
              //   selectedMonth: selectedMonth,
              //   selectedYear: selectedYear,
              // ),
              TransactionList(transactions: transactions),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        // onPressed: () => Navigator.pushNamed(context, "addTransaction"),
        // onPressed: () => {
        //   Navigator.pushNamed(context, "addTransaction"),
        // },
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                AddTransactionScreen(onTransactionSaved: _loadTransactions),
          ),
        ).then((_) => _loadTransactions()),
        //     onPressed: () async {
        //       await _controller.createTransaction(
        //         Transaction(amount: 100.50, type: 'expense', categoryId: 4, date: '2026-01-23', description: '', createdAt: DateTime.now().toIso8601String(), categoryName: '食物', icon: 'restaurant'),
        //       );
        //        await _loadTransactions();
        //       // _loadData();

        // // setState(() {});    // 觸發重建

        //     },
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 3, color: Colors.black),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Icon(Icons.add, size: 28, color: Colors.white),
      ),
      // bottomNavigationBar: Container(
      //   decoration: BoxDecoration(
      //     color: const Color(0xFFFDFDFE),
      //     boxShadow: [
      //       BoxShadow(
      //         color: Colors.black.withOpacity(0.08),
      //         blurRadius: 20,
      //         offset: const Offset(0, -4),
      //       ),
      //     ],
      //   ),
      //   child: BottomAppBar(
      //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      //     height: 70,
      //     color: Colors.transparent,
      //     elevation: 0,
      //     shape: const CircularNotchedRectangle(),
      //     notchMargin: 8,
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceAround,
      //       children: [
      //         _navIcon(Icons.home_outlined, () {}),
      //         _navIcon(Icons.pie_chart_outline, () {}),
      //         const SizedBox(width: 60),
      //         _navIcon(Icons.trending_up_outlined, () {}),
      //         _navIcon(Icons.settings_outlined, () {
      //           Navigator.pushNamed(context, "setting");
      //         }),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }

  // Widget _navIcon(IconData icon, VoidCallback onTap) {
  //   return InkWell(
  //     onTap: onTap,
  //     borderRadius: BorderRadius.circular(12),
  //     child: Padding(
  //       padding: const EdgeInsets.all(8),
  //       child: Icon(icon, color: Colors.black87, size: 30),
  //     ),
  //   );
  // }

  void _showYearMonthDialog() {
    int dialogYear = selectedYear;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFFFDFDFE),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
          content: SizedBox(
            width: double.maxFinite,
            height: 320,
            child: Column(
              children: [
                // 年份區
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F7),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      _roundIconButton(
                        icon: Icons.chevron_left,
                        onTap: () {
                          setDialogState(() => dialogYear--);
                        },
                      ),
                      const Spacer(),
                      Text(
                        '$dialogYear',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const Spacer(),
                      _roundIconButton(
                        icon: Icons.chevron_right,
                        onTap: () {
                          setDialogState(() => dialogYear++);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // 月份格子
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.3,
                        ),
                    itemCount: 12,
                    itemBuilder: (context, index) {
                      final month = index + 1;
                      final isSelected =
                          selectedMonth == month && dialogYear == selectedYear;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedYear = dialogYear;
                            selectedMonth = month;
                          });
                          Navigator.pop(context);
                          _loadTransactions();
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.black
                                : const Color(0xFFF5F5F7),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.black
                                  : Colors.grey.withOpacity(0.25),
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '$month 月',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: isSelected
                                    ? Colors.white
                                    : Colors.black.withOpacity(0.85),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actionsPadding: const EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 12,
            top: 0,
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  selectedYear = DateTime.now().year;
                  selectedMonth = DateTime.now().month;
                });
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.black87,
                textStyle: const TextStyle(fontWeight: FontWeight.w500),
              ),
              child: const Text('返回本月'),
            ),
            FilledButton.tonal(
              onPressed: () => Navigator.pop(context),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFE5E7EB),
                foregroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('關閉'),
            ),
          ],
        ),
      ),
    );
  }

  // 小圓形 IconButton（現代簡約）
  Widget _roundIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.grey.withOpacity(0.25)),
        ),
        child: Icon(icon, size: 20, color: Colors.black87),
      ),
    );
  }

  // 超簡潔選單項目
  Widget _buildMenuItem(IconData icon, String label, String route) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, route);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: Colors.black87, size: 20),
                ),
                const SizedBox(width: 16),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
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
