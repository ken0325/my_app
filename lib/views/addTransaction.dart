import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  bool isExpense = true;
  int selectedCategoryIndex = 1;
  DateTime selectedDate = DateTime.now();
  String amountText = '0';
  final TextEditingController _descriptionController = TextEditingController();

  final List<Map<String, dynamic>> categories = [
    {'icon': Icons.add, 'label': '新增分類'},
    {'icon': Icons.shopping_cart, 'label': '日用品'},
    {'icon': Icons.rice_bowl, 'label': '午餐'},
    {'icon': Icons.restaurant, 'label': '晚餐'},
    {'icon': Icons.directions_bus, 'label': '交通'},
    {'icon': Icons.local_hospital, 'label': '醫療'},
    {'icon': Icons.free_breakfast, 'label': '早餐'},
    {'icon': Icons.local_cafe, 'label': '飲品'},
    {'icon': Icons.menu_book, 'label': '課程'},
    {'icon': Icons.shopping_bag, 'label': '購物'},
    {'icon': Icons.brush, 'label': '美容'},
    {'icon': Icons.card_giftcard, 'label': '發稿酬'},
  ];

  String displayText = '0';
  double? firstOperand;
  String? operator;
  bool shouldClearDisplay = false;
  bool isCalculating = false;

  void _onKeyTap(String value) {
    setState(() {
      if (value == 'AC') {
        displayText = '0';
        firstOperand = null;
        operator = null;
        shouldClearDisplay = false;
        amountText = '0';
        isCalculating = false; // 重置按鈕狀態
      } else if (value == '←') {
        if (displayText.length > 1) {
          displayText = displayText.substring(0, displayText.length - 1);
        } else {
          displayText = '0';
        }
        amountText = displayText;
      } else if (value == 'RIGHT_BUTTON') {
        // 合併按鈕
        if (isCalculating && firstOperand != null && operator != null) {
          // 運算中 → 按 = 計算
          _calculate();
          firstOperand = null;
          operator = null;
          isCalculating = false; // 變回 OK
        } else {
          // 非運算中 → 按 OK 儲存
          _saveTransaction();
        }
      } else if (['+', '-', '×', '÷'].contains(value)) {
        // 按運算符 → OK 變成 =
        if (firstOperand == null) {
          firstOperand = double.tryParse(displayText) ?? 0;
        } else {
          _calculate();
        }
        firstOperand = double.tryParse(displayText) ?? 0;
        operator = value;
        shouldClearDisplay = true;
        isCalculating = true; // 切換到 = 模式
      } else {
        // 數字、小數點
        if (displayText.length >= 13) {
          Fluttertoast.showToast(msg: '超過輸入上限');
          return;
        }

        if (shouldClearDisplay) {
          displayText = value;
          shouldClearDisplay = false;
        } else if (displayText == '0' && value != '.') {
          displayText = value;
        } else {
          if (value == '.' && displayText.contains('.')) return;
          displayText += value;
        }
        amountText = displayText;
      }
    });
  }

  void _calculate() {
    if (firstOperand == null || operator == null) return;

    double secondOperand = double.tryParse(displayText) ?? 0;

    switch (operator!) {
      case '+':
        displayText = (firstOperand! + secondOperand).toString();
        break;
      case '-':
        displayText = (firstOperand! - secondOperand).toString();
        break;
      case '×':
        displayText = (firstOperand! * secondOperand).toString();
        break;
      case '÷':
        if (secondOperand != 0) {
          displayText = (firstOperand! / secondOperand).toString();
        } else {
          displayText = '錯誤';
        }
        break;
      default:
        return;
    }

    amountText = double.parse(displayText).toStringAsFixed(2);

    // 清理小數點後無限多0
    if (displayText.contains('.')) {
      displayText = double.parse(displayText).toStringAsFixed(2);
    }
    displayText = displayText
        .replaceAll(RegExp(r'0+$'), '')
        .replaceAll(RegExp(r'\.$'), '');
  }

  void _saveTransaction() {
    // 這裡接 Hive / Bloc / API 即可
    Navigator.pop(context, {
      'isExpense': isExpense,
      'category': categories[selectedCategoryIndex]['label'],
      'amount': double.tryParse(amountText) ?? 0,
      'description': _descriptionController.text,
      'date': selectedDate,
    });
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (d != null) setState(() => selectedDate = d);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        title: const Text(
          '新增交易',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            // fontSize: 20,
          ),
        ),
        // backgroundColor: Colors.grey[100],
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.white.withOpacity(0.9)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      // backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // 1. 上方「支出 / 收入」切換 + 分類圖示區
          Container(
            color: Colors.white,
            // padding: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Column(
              children: [
                // const SizedBox(height: 8),
                _buildTypeSwitch(),
                const SizedBox(height: 10),
                _buildCategoryGrid(),
              ],
            ),
          ),

          // const SizedBox(height: 12),

          // 2. 中間：目前選擇 + 金額 + 備註 + 日期列
          _buildAmountNoteBar(),
          // const SizedBox(height: 16),

          // 3. 底部：計算機鍵盤
          // Expanded(
          //   child: Container(
          //     color: Colors.yellow,
          //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          //     child: _buildKeyboard(),
          //   ),
          // ),
          Expanded(
            child: Container(
              // margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: _buildKeyboard(),
            ),
          ),
        ],
      ),
    );
  }

  // 支出 / 收入 Segment
  Widget _buildTypeSwitch() {
    return Container(
      // margin: const EdgeInsets.symmetric(horizontal: 16),
      // padding: const EdgeInsets.all(4),
      // decoration: BoxDecoration(
      //   color: Colors.grey[200],
      //   borderRadius: BorderRadius.circular(24),
      // ),
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F4),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => isExpense = true),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 8),
                // decoration: BoxDecoration(
                //   // color: isExpense ? Colors.yellow : Colors.transparent,
                //   color: isExpense ? Colors.blue : Colors.transparent,
                //   borderRadius: BorderRadius.circular(20),
                // ),
                decoration: BoxDecoration(
                  color: isExpense ? Colors.black : Colors.transparent,
                  borderRadius: BorderRadius.circular(21),
                ),
                alignment: Alignment.center,
                child: Text(
                  '支出',
                  // style: TextStyle(
                  //   fontWeight: FontWeight.w600,
                  //   color: isExpense ? Colors.black : Colors.grey[700],
                  // ),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isExpense ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => isExpense = false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 8),
                // decoration: BoxDecoration(
                //   // color: !isExpense ? Colors.yellow : Colors.transparent,
                //   color: !isExpense ? Colors.yellow : Colors.transparent,
                //   borderRadius: BorderRadius.circular(20),
                // ),
                decoration: BoxDecoration(
                  color: !isExpense ? Colors.black : Colors.transparent,
                  borderRadius: BorderRadius.circular(21),
                ),
                alignment: Alignment.center,
                child: Text(
                  '收入',
                  // style: TextStyle(
                  //   fontWeight: FontWeight.w600,
                  //   color: !isExpense ? Colors.black : Colors.grey[700],
                  // ),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: !isExpense ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 分類圖示 Grid
  Widget _buildCategoryGrid() {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 255, 255, 255)),
      ),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.3,
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: categories.length,
        scrollDirection: Axis.vertical,
        physics: const ScrollPhysics(),
        // physics: const NeverScrollableScrollPhysics(), // The GridView will not scroll
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 1,
          crossAxisSpacing: 1,
          childAspectRatio: 1.0,
        ),
        padding: EdgeInsets.zero, // To remove extra spacing
        itemBuilder: (context, index) {
          final item = categories[index];
          final selected = index == selectedCategoryIndex;
          return GestureDetector(
            onTap: () {
              if (index == 0) {
                // TODO: 新增分類邏輯
              } else {
                setState(() => selectedCategoryIndex = index);
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.all(1),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: selected
                        ? !isExpense
                              ? Colors.yellow
                              : Colors.blue
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    item['icon'] as IconData,
                    // color: selected ? Colors.orange[900] : Colors.grey[800],
                    color: selected ? Colors.white : Colors.black,
                    size: 26,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  (item['label'] as String).replaceAll(' ', '\n'),
                  // style: const TextStyle(fontSize: 11),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
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

  // 金額 + 備註 + 日期
  Widget _buildAmountNoteBar() {
    final customFormatter = NumberFormat('#,##0.00', 'en_US');
    return Container(
      // color: yellow,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        children: [
          // 類別 + 金額 + 備註輸入
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(1),
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          // color: Colors.yellow,
                          color: !isExpense ? Colors.yellow : Colors.blue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          categories[selectedCategoryIndex]['icon'] as IconData,
                          color: Colors.orange[900],
                          size: 25,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        categories[selectedCategoryIndex]['label'] as String,
                        style: const TextStyle(fontSize: 11),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),

                  const SizedBox(width: 8),

                  Text(
                    displayText == '錯誤'
                        ? '錯誤'
                        : '\$ ${customFormatter.format(double.tryParse(displayText) ?? 0)}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: displayText == '錯誤' ? Colors.red : null,
                    ),
                  ),

                  VerticalDivider(color: Colors.black, thickness: 2),
                  Expanded(
                    child: TextField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: '在此輸入備註',
                        hintStyle: TextStyle(fontSize: 13),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(),
          const SizedBox(height: 8),
          // 日期列
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255),
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    setState(() {
                      selectedDate = selectedDate.subtract(
                        const Duration(days: 1),
                      );
                    });
                  },
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: _pickDate,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.calendar_today, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          ' ${DateFormat('yyyy/MM/dd EEEE', 'zh_TW').format(selectedDate)}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    setState(() {
                      selectedDate = selectedDate.add(const Duration(days: 1));
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyboard() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            padding: EdgeInsets.all(10),
            height: double.infinity,
            child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              childAspectRatio: 1.0,
              children: [
                _buildKey('7'),
                _buildKey('8'),
                _buildKey('9'),
                _buildKey('÷'),
                _buildKey('4'),
                _buildKey('5'),
                _buildKey('6'),
                _buildKey('×'),
                _buildKey('1'),
                _buildKey('2'),
                _buildKey('3'),
                _buildKey('+'),
                _buildKey('00'),
                _buildKey('0'),
                _buildKey('.'),
                _buildKey('-'),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
            height: double.infinity,
            child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 1,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              childAspectRatio: 1.0,
              children: [_buildKey('AC'), _buildKey('←'), _buildRightButton()],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKey(String label) {
    final isOp = ['+', '-', '×', '÷'].contains(label);
    final isAC = label == 'AC';

    Color bg = Colors.white;
    Color fg = Colors.black;
    if (isAC || isOp) {
      bg = Colors.blue;
      fg = Colors.white;
    }

    return GestureDetector(
      onTap: () => _onKeyTap(label),
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: !(isAC || isOp)
              ? Border.all(color: Colors.grey[400]!, width: 0.5)
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: label == '00' ? 16 : 20,
            fontWeight: FontWeight.bold,
            color: fg,
          ),
        ),
      ),
    );
  }

  Widget _buildRightButton() {
    return GestureDetector(
      onTap: () => _onKeyTap('RIGHT_BUTTON'),
      child: Container(
        margin: const EdgeInsets.all(2),
        // height: 200,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isCalculating ? '=' : 'OK',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              isCalculating ? '計算' : '完成',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
