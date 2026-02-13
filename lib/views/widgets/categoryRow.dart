import 'package:flutter/material.dart';
// import '../../api/dataApi.dart';
import '../../controllers/controller.dart';
import '../categoryExpenseIncome.dart';
// import '../../model/data.dart';

class Categoryrow extends StatelessWidget {
  // final List<Data> filtered;
  final List<Map<String, dynamic>> categoryList;
  final bool showOnlyThisMonth;

  // const Categoryrow({super.key, required this.filtered});
  Categoryrow({
    super.key,
    required this.categoryList,
    required this.showOnlyThisMonth,
  });

  //   @override
  //   State<Categoryrow> createState() => _CategoryrowState();
  // }

  // class _CategoryrowState extends State<Categoryrow> {

  final Controller _controller = Controller();

  // Future<void> _load(context, int id, String categoryName) async {
  //   final list = await _controller.getTransactionsByCategory(id);
  //   Navigator.of(context).push(
  //     MaterialPageRoute<void>(
  //       builder: (context) => CategoryExpenseIncome(
  //         transactions: list,
  //         categoryName: categoryName,
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // final Map<String, double> categoryTotals = {};

    // for (final tx in filtered) {
    //   final category = tx.category as String;
    //   final amount = (tx.amount as double).abs();
    //   categoryTotals.update(
    //     category,
    //     (value) => value + amount,
    //     ifAbsent: () => amount,
    //   );
    // }

    // final sortedCategories = categoryTotals.entries.toList()
    //   ..sort((a, b) => b.value.compareTo(a.value));

    // final colors = [
    //   const Color(0xFF4F46E5), // 餐飲
    //   const Color(0xFF0EA5E9), // 交通
    //   const Color(0xFFF97316), // 娛樂
    //   const Color(0xFF22C55E), // 其他
    // ];

    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            showOnlyThisMonth ? '本月最高' : '總最高',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 78,
            // child: filtered.isEmpty
            child: categoryList.isEmpty
                ? Center(child: Text('本月沒有交易'))
                : ListView.separated(
                    scrollDirection: Axis.horizontal,
                    // itemCount: sortedCategories.length,
                    itemCount: categoryList.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      // final entry = sortedCategories[index];
                      final entry = categoryList[index];
                      // final color = colors[index % colors.length];
                      return InkWell(
                        // onTap: () => {
                        //   // print(entry['id']),
                        //   _load(context, entry['id'], entry['name']),
                        // },
                        onTap: () async {
                          final list = await _controller
                              .getTransactionsByCategory(entry['id']);
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (context) => CategoryExpenseIncome(
                                transactions: list,
                                categoryName: entry['name'],
                              ),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(999),
                        child: Container(
                          width: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: entry['type'] == 'income'
                                  ? Colors.greenAccent
                                  : Colors.redAccent,
                              width: 2,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  // Container(
                                  //   width: 18,
                                  //   height: 18,
                                  //   decoration: BoxDecoration(
                                  //     color: color,
                                  //     borderRadius: BorderRadius.circular(6),
                                  //   ),
                                  // ),
                                  Container(
                                    margin: const EdgeInsets.all(1),
                                    width: 18,
                                    height: 18,
                                    child: Icon(
                                      Controller.getIconData(entry['icon']),
                                      color: Colors.black,
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      // entry.key,
                                      entry['name'],
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
                                // '\$${entry.value.toStringAsFixed(0)}',
                                // '\$${DataApi().formatAmountToString(entry.value)}',
                                // '\$${entry['total_expense']}',
                                '\$${entry['total']}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
