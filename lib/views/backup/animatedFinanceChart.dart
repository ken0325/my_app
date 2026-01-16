// import 'package:my_app/l10n/app_localizations.dart';
// import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../api/dataApi.dart';

class AnimatedFinanceChart extends StatefulWidget {
  final bool monthRecord;
  final int selectedYear;
  final int selectedMonth;

  const AnimatedFinanceChart({
    super.key,
    required this.monthRecord,
    required this.selectedYear,
    required this.selectedMonth,
  });

  @override
  State<AnimatedFinanceChart> createState() => _AnimatedFinanceChartState();
}

class _AnimatedFinanceChartState extends State<AnimatedFinanceChart>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  Map<String, double>? monthlyExpensesAndIncome;

  @override
  void initState() {
    super.initState();
    _getData();

    // 載入動畫 (1.5秒)
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.elasticOut),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeInOut),
      ),
    );

    _animationController.forward();
  }

  @override
  void didUpdateWidget(AnimatedFinanceChart oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.monthRecord != widget.monthRecord ||
        oldWidget.selectedYear != widget.selectedYear ||
        oldWidget.selectedMonth != widget.selectedMonth) {
      _getData();
    }
  }

  Future<void> _getData() async {
    setState(() => monthlyExpensesAndIncome = null);
    monthlyExpensesAndIncome = widget.monthRecord
        ? await DataApi().getMonthlyExpensesAndIncome(
            widget.selectedYear,
            widget.selectedMonth,
          )
        : await DataApi().getTotalExpensesAndIncome();
    setState(() {});
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (monthlyExpensesAndIncome == null) {
      return Container(
        padding: const EdgeInsets.all(20),
        height: 300,
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // 月支出/收入卡片（動畫淡入）
          FadeTransition(
            opacity: _fadeAnimation,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCard(
                  widget.monthRecord == true ? '月支出' : '總支出',
                  '\$ ${monthlyExpensesAndIncome?['expenses']?.toStringAsFixed(2) ?? '0.00'}',
                  const Color(0xFFF8C850),
                ),
                _buildStatCard(
                  widget.monthRecord == true ? '月收入' : '總收入',
                  '\$ ${monthlyExpensesAndIncome?['income']?.toStringAsFixed(2) ?? '0.00'}',
                  const Color(0xFF37A9E0),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 動畫圓餅圖 + 中間結餘
          Stack(
            alignment: Alignment.center,
            children: [
              // 圓餅圖背景
              AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: SizedBox(
                      height: 200,
                      child: PieChart(
                        PieChartData(
                          sections: [
                            PieChartSectionData(
                              value: monthlyExpensesAndIncome?['expenses'] ?? 0,
                              showTitle: false,
                              color: const Color(0xFFF8C850),
                              radius: 60,
                              // title: '支出\n\$28,940',
                              titleStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.black26,
                                    offset: Offset(1, 1),
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                            PieChartSectionData(
                              value: monthlyExpensesAndIncome?['income'] ?? 0,
                              color: const Color(0xFF37A9E0),
                              radius: 60,
                              showTitle: false,
                              // title: '收入\n\$32,820',
                              titleStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.black26,
                                    offset: Offset(1, 1),
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                          ],
                          centerSpaceRadius: 45,
                          sectionsSpace: 2,
                        ),
                      ),
                    ),
                  );
                },
              ),

              // 中間結餘數字（彈跳動畫）
              AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Transform.scale(
                          scale: 1.0 + (_scaleAnimation.value * 0.1), // 輕微脈動
                          child: const Icon(
                            Icons.account_balance_wallet,
                            color: Color(0xFF37A9E0),
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '\$${monthlyExpensesAndIncome?['balance']?.toStringAsFixed(2) ?? 0}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF37A9E0),
                            shadows: const [
                              Shadow(
                                color: Colors.black12,
                                offset: Offset(1, 1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          widget.monthRecord == true ? '月結餘' : '總結餘',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 統計卡片組件
  Widget _buildStatCard(String title, String amount, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              amount,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
