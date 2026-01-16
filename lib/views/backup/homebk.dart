// import 'package:my_app/l10n/app_localizations.dart';
// import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'transaction_list.dart';
import 'animatedFinanceChart.dart';
// import '../model/data.dart';
// import '../api/dataApi.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;
  bool monthRecord = true;
  bool piChartRecord = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100,
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                );
              },
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.all(8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  splashFactory: NoSplash.splashFactory,
                ),
                onPressed: () {
                  setState(() {
                    monthRecord = !monthRecord;
                  });
                },
                child: Text(
                  monthRecord == true ? '月' : '全部',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
        title: GestureDetector(
          onTap: () => _showYearMonthDialog(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${selectedMonth}月 $selectedYear',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.arrow_drop_down, size: 20),
              ],
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          IconButton(
            icon: piChartRecord == true
                ? Icon(Icons.calendar_today, color: Colors.blue)
                : Icon(Icons.data_usage, color: Colors.blue),
            onPressed: () {
              setState(() {
                piChartRecord = !piChartRecord;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Change to day and daypicker')),
              );
            },
          ),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 圓餅圖 + 總覽
            AnimatedFinanceChart(selectedYear: selectedYear, selectedMonth: selectedMonth, monthRecord: monthRecord),
            SizedBox(height: 20),
            // 最近交易列表
            TransactionList(selectedMonth: selectedMonth, selectedYear: selectedYear),
            SizedBox(height: 64),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, "addTransaction"),
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 3, color: Colors.black),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Icon(Icons.add, size: 28, color: Colors.white),
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
}