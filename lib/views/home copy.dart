import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showOnlyThisMonth = true;

  // 模擬交易資料
  List<Map<String, dynamic>> get _allTransactions => [
    {
      'description': '午餐 - 麥當勞',
      'category': '餐飲',
      'amount': 52.0,
      'date': DateTime(2026, 1, 14),
      'isIncome': false,
    },
    {
      'description': '薪金入帳',
      'category': '收入',
      'amount': 18000.0,
      'date': DateTime(2026, 1, 13),
      'isIncome': true,
    },
    {
      'description': '薪金入帳',
      'category': '收入',
      'amount': 18000.0,
      'date': DateTime(2025, 12, 13),
      'isIncome': true,
    },
    {
      'description': '地鐵交通',
      'category': '交通',
      'amount': 12.5,
      'date': DateTime(2026, 1, 13),
      'isIncome': false,
    },
    {
      'description': '咖啡',
      'category': '餐飲',
      'amount': 28.0,
      'date': DateTime(2026, 1, 12),
      'isIncome': false,
    },
    {
      'description': 'Netflix',
      'category': '娛樂',
      'amount': 78.0,
      'date': DateTime(2025, 12, 30),
      'isIncome': false,
    },
    {
      'description': 'Netflix',
      'category': '娛樂',
      'amount': 78.0,
      'date': DateTime(2026, 1, 1),
      'isIncome': false,
    },
  ];

  List<Map<String, dynamic>> get _filteredTransactions {
    if (!_showOnlyThisMonth) return _allTransactions;

    final now = DateTime.now();
    return _allTransactions.where((tx) {
      final d = tx['date'] as DateTime;
      return d.year == now.year && d.month == now.month;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredTransactions;

    // 依「日」分組
    final Map<DateTime, List<Map<String, dynamic>>> groupedByDay = {};
    for (final tx in filtered) {
      final d = tx['date'] as DateTime;
      final key = DateTime(d.year, d.month, d.day);
      groupedByDay.putIfAbsent(key, () => []).add(tx);
    }

    final sortedKeys = groupedByDay.keys.toList()
      ..sort((a, b) => b.compareTo(a)); // 由新到舊

    return Scaffold(
      extendBody: true,
      // backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        elevation: 0,
        // backgroundColor: const Color(0xFFF5F5F7),
        centerTitle: false,
        title: const Text(
          '我的記帳',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          // 月 / 全部 切換按鈕（移到 AppBar）
          Container(
            height: 34,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                _buildToggleItem('本月', true),
                _buildToggleItem('全部', false),
              ],
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.calendar_today_outlined),
            color: Colors.black87,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ 動態計算的總結卡片
              _buildSummaryCard(filtered),
              const SizedBox(height: 16),
              // ✅ 動態計算的分類統計
              _buildCategoryRow(filtered),
              const SizedBox(height: 20),
              const Text(
                '最近紀錄',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: sortedKeys.length,
                  itemBuilder: (context, index) {
                    final day = sortedKeys[index];
                    final txs = groupedByDay[day]!;
                    return _buildDaySection(day, txs);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, "addTransaction"),
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 3, color: Colors.black),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Icon(Icons.add, size: 28, color: Colors.white),
      ),
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 60,
        color: Colors.cyan.shade400,
        shape: const CircularNotchedRectangle(),
        notchMargin: 5,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.home_outlined, color: Colors.black),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.pie_chart_outline, color: Colors.black),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.trending_up_outlined, color: Colors.black),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.settings_outlined, color: Colors.black),
              onPressed: () {
                Navigator.pushNamed(context, "setting");
              },
            ),
          ],
        ),
      ),
    );
  }

  // ✅ 動態計算總結卡片
  Widget _buildSummaryCard(List<Map<String, dynamic>> transactions) {
    // final income = transactions
    //     .where((tx) => (tx['amount'] as double) >= 0)
    //     .fold<double>(0, (sum, tx) => sum + (tx['amount'] as double));
    final income = transactions
        .where((tx) => tx['isIncome'] == true)
        .fold<double>(0, (sum, tx) => sum + (tx['amount'] as double));
    // final expense = transactions
    //     .where((tx) => (tx['amount'] as double) < 0)
    //     .fold<double>(0, (sum, tx) => sum + (tx['amount'] as double).abs());
    // final balance = income - expense;
    final expense = transactions
        .where((tx) => tx['isIncome'] == false)
        .fold<double>(0, (sum, tx) => sum + (tx['amount'] as double).abs());
    final balance = income - expense;

    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '本期結餘',
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
                label: '收入',
                amount: income,
                color: Colors.greenAccent,
              ),
              const SizedBox(width: 24),
              _buildSummaryItem(
                label: '支出',
                amount: expense,
                color: Colors.redAccent,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ✅ 動態計算分類統計
  Widget _buildCategoryRow(List<Map<String, dynamic>> transactions) {
    final Map<String, double> categoryTotals = {};

    for (final tx in transactions) {
      final category = tx['category'] as String;
      final amount = (tx['amount'] as double).abs();
      categoryTotals.update(
        category,
        (value) => value + amount,
        ifAbsent: () => amount,
      );
    }

    final sortedCategories = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final colors = [
      const Color(0xFF4F46E5), // 餐飲
      const Color(0xFF0EA5E9), // 交通
      const Color(0xFFF97316), // 娛樂
      const Color(0xFF22C55E), // 其他
    ];

    return SizedBox(
      height: 78,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: sortedCategories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final entry = sortedCategories[index];
          final color = colors[index % colors.length];
          return Container(
            width: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        entry.key,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  '\$${entry.value.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildToggleItem(String text, bool isMonth) {
    final selected = _showOnlyThisMonth == isMonth;
    return GestureDetector(
      onTap: () {
        setState(() {
          _showOnlyThisMonth = isMonth;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: selected ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: selected ? Colors.white : Colors.black87,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildDaySection(
    DateTime day,
    List<Map<String, dynamic>> transactions,
  ) {
    // final dateLabel =
    //     '${day.year}-${_twoDigits(day.month)}-${_twoDigits(day.day)}';
    final dateLabel =
        '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        Text(
          dateLabel,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        ...transactions.map(_buildTransactionTile),
        const SizedBox(height: 8),
      ],
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
              '\$${amount.toStringAsFixed(2)}',
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

  Widget _buildTransactionTile(Map<String, dynamic> tx) {
    final double amount = tx['amount'] as double;
    // final bool isIncome = amount >= 0;

    // final DateTime date = tx['date'] as DateTime;
    // final String timeStr =
    //     '${_twoDigits(date.hour)}:${_twoDigits(date.minute)}';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: tx['isIncome']
                  ? const Color(0xFFE0FCE5)
                  : const Color(0xFFFFE4E6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              tx['isIncome']
                  ? Icons.arrow_downward_rounded
                  : Icons.arrow_upward_rounded,
              color: tx['isIncome'] ? Colors.green : Colors.redAccent,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx['category'] as String,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  // '${tx['category']} · $timeStr',
                  // '${tx['title']}',
                  '${tx['description']}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${tx['isIncome'] ? '+' : '-'}\$${amount.abs().toStringAsFixed(1)}',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: tx['isIncome'] ? Colors.green : Colors.redAccent,
            ),
          ),
        ],
      ),
    );
  }

  // String _twoDigits(int n) => n.toString().padLeft(2, '0');
}
