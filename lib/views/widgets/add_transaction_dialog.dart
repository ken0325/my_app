import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTransactionDialog extends StatefulWidget {
  const AddTransactionDialog({super.key});

  @override
  State<AddTransactionDialog> createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  String _category = '餐飲';
  DateTime _selectedDate = DateTime.now();
  bool _isIncome = false;

  final List<String> categories = ['餐飲', '交通', '購物', '娛樂', '其他'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 6,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              Text(
                '新增交易',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 24),
              
              // 金額輸入
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: '金額',
                  prefixText: 'HK ',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) return '請輸入金額';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // 分類 + 日期
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _category,
                      decoration: const InputDecoration(
                        labelText: '分類',
                        border: OutlineInputBorder(),
                      ),
                      items: categories.map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      )).toList(),
                      onChanged: (value) => setState(() => _category = value!),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectDate(context),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: '日期',
                          border: OutlineInputBorder(),
                        ),
                        child: Text(DateFormat('yyyy-MM-dd').format(_selectedDate)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // 備註
              TextFormField(
                decoration: const InputDecoration(
                  labelText: '備註',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 24),
              
              // 收入/支出切換
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _saveTransaction(),
                      icon: const Icon(Icons.save),
                      label: const Text('儲存'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _saveTransaction() {
    if (_formKey.currentState!.validate()) {
      // TODO: 存到Hive或Bloc
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('已新增交易 HK \$${_amountController.text}')),
      );
    }
  }
}
