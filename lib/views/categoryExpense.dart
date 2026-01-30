import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../../controllers/controller.dart';

class CategoryExpense extends StatefulWidget {
  final List<Transaction> transactions;

  const CategoryExpense({super.key, required this.transactions});

  @override
  State<CategoryExpense> createState() => _CategoryExpenseState();
}

class _CategoryExpenseState extends State<CategoryExpense> {
  final Controller _controller = Controller();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '類別',
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Expanded(
        child: widget.transactions.isEmpty
            ? const Center(child: Text('沒有交易'))
            : ListView.builder(
                itemCount: widget.transactions.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      // Code to execute when the container is tapped
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
                              // color: tx.type == 'income'
                              //     ? Colors.green[100]
                              //     : Colors.red[100],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.black,
                                width: 2.0,
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: Icon(
                              Icons.import_contacts,
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          // 金額
                          Text(
                            '100',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              // color: tx.type == 'income'
                              //     ? Colors.green
                              //     : Colors.red,
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
    );
  }
}
