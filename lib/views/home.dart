import 'package:flutter/material.dart';
import 'package:my_app/api/dataApi.dart';
import '../model/data.dart';
import '../views/widgets/transaction_list.dart';
import '../views/widgets/Summarycard.dart';
import '../views/widgets/categoryRow.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showOnlyThisMonth = true;
  List<Data>? list;
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;

  List<Data>? get _filteredTransactions {
    if (!_showOnlyThisMonth) return list;

    return list?.where((tx) {
      final d = tx.date;
      return d.year == selectedYear && d.month == selectedMonth;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    list = await DataApi().getData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredTransactions;

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
                filtered: filtered ?? [],
                showOnlyThisMonth: _showOnlyThisMonth,
              ),
              const SizedBox(height: 16),
              // 動態計算的分類統計
              Categoryrow(filtered: filtered ?? []),
              const SizedBox(height: 20),
              const Text(
                '最近紀錄',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TransactionList(
                selectedMonth: selectedMonth,
                selectedYear: selectedYear,
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

  void _showYearMonthDialog() {
    int dialogYear = selectedYear;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {
                          setDialogState(() => dialogYear--);
                          setState(() => selectedYear = dialogYear);
                        },

                        icon: const Icon(Icons.chevron_left),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          '$dialogYear',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setDialogState(() => dialogYear++);
                          setState(() => selectedYear = dialogYear);
                        },
                        icon: const Icon(Icons.chevron_right),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.2,
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
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.orange
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.orange
                                  : Colors.grey[300]!,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '$month月',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? Colors.white
                                    : Colors.black87,
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
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  selectedYear = DateTime.now().year;
                  selectedMonth = DateTime.now().month;
                });
                Navigator.pop(context);
              },
              child: const Text('今日月份'),
            ),
          ],
        ),
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
