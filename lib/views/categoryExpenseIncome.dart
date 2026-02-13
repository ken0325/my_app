import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../../controllers/controller.dart';
import 'addTransaction.dart';

class CategoryExpenseIncome extends StatefulWidget {
  final List<Transaction> transactions;
  final String categoryName;

  const CategoryExpenseIncome({
    super.key,
    required this.transactions,
    required this.categoryName,
  });

  @override
  State<CategoryExpenseIncome> createState() => _CategoryExpenseIncomeState();
}

class _CategoryExpenseIncomeState extends State<CategoryExpenseIncome> {
  final Controller _controller = Controller();
  double total = 0;
  bool isExpense = true;

  @override
  void initState() {
    super.initState();

    if (widget.transactions.isNotEmpty) {
      for (var y in widget.transactions) {
        total += y.amount;
      }

      widget.transactions[0].type == 'income'
          ? isExpense = true
          : isExpense = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryName,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(icon: Icon(Icons.tune, size: 20), onPressed: () => {}),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: widget.transactions.isEmpty
              ? const Center(child: Text('沒有交易'))
              : Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('總金額'),
                        Text(
                          '${isExpense ? '+' : '-'}\$${_controller.formatAmountToString(total)}',
                        ),
                      ],
                    ),
                    Divider(),
                    Expanded(
                      child: ListView.builder(
                        itemCount: widget.transactions.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              // print(widget.transactions[index].id);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddTransactionScreen(
                                    onTransactionSaved: null,
                                    transaction: widget.transactions[index],
                                    isUpdate: true,
                                  ),
                                ),
                              );
                            },
                            splashColor: Colors.white.withAlpha(30),
                            highlightColor: Colors.blue.withAlpha(50),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8F9FA),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade100),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 2.0,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    child: Icon(
                                      Controller.getIconData(
                                        widget.transactions[index].icon,
                                      ),
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    children: [
                                      Text(
                                        widget
                                                .transactions[index]
                                                .description ??
                                            widget.categoryName,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'monospace',
                                        ),
                                      ),
                                      Text(
                                        widget.transactions[index].date,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'monospace',
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '${isExpense ? '+' : '-'}\$${_controller.formatAmountToString(widget.transactions[index].amount)}',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'monospace',
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
        ),
      ),
    );
  }
}
