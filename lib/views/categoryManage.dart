import 'package:flutter/material.dart';
import '../models/category.dart';
import '../../controllers/controller.dart';
import 'categoryExpenseIncome.dart';

class CategoryManageScreen extends StatefulWidget {
  const CategoryManageScreen({super.key});

  @override
  State<CategoryManageScreen> createState() => _CategoryManageScreenState();
}

class _CategoryManageScreenState extends State<CategoryManageScreen> {
  final Controller _controller = Controller();
  bool isExpense = true;
  List<Category> categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    // print('🔍 開始查詢類別...');
    // final allCats = await _controller.getAllCategories();
    // print('📊 總類別數: ${allCats.length}');
    final cats = await _controller.getCategoriesByType(
      isExpense ? 'expense' : 'income',
    );
    // print('📊 支出類別數: ${cats.length}');
    if (mounted) {
      setState(() {
        categories = cats;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Category Manage',
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
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Column(
              children: [
                _buildTypeSwitch(),
                const SizedBox(height: 10),
                _buildCategoryGrid(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeSwitch() {
    return GestureDetector(
      onTap: () async {
        setState(() => isExpense = !isExpense);
        await _loadCategories(); // ✅ 重新載入對應類別
      },
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F3F4),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: isExpense ? Colors.black : Colors.transparent,
                  borderRadius: BorderRadius.circular(21),
                ),
                alignment: Alignment.center,
                child: const Text(
                  '支出',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: !isExpense ? Colors.black : Colors.transparent,
                  borderRadius: BorderRadius.circular(21),
                ),
                alignment: Alignment.center,
                child: const Text(
                  '收入',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return Container(
      padding: const EdgeInsets.all(5),
      height: MediaQuery.of(context).size.height * 0.25,
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: categories.length,
        scrollDirection: Axis.vertical,
        physics: const ScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 1,
          crossAxisSpacing: 1,
          childAspectRatio: 1.0,
        ),
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () async {
              //   print('🔍 Category: ${category.toString()}'); // 看 id 是否 null
              //   print('🔍 ID: ${category.id}'); // 應該印 null
              final list = await _controller.getTransactionsByCategory(
                category.id,
              );
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => CategoryExpenseIncome(
                    transactions: list,
                    categoryName: category.name,
                  ),
                ),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.all(1),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Icon(
                    Controller.getIconData(category.icon),
                    color: Colors.black,
                    size: 26,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  category.name.replaceAll(' ', '\n'),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
