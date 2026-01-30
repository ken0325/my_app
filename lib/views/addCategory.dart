import 'package:flutter/material.dart';
import '../../controllers/controller.dart';
import '../../models/category.dart';

class AddCategoryScreen extends StatefulWidget {
  final bool isExpense;
  final VoidCallback? onCategoryAdded;

  const AddCategoryScreen({
    super.key,
    required this.isExpense,
    this.onCategoryAdded,
  });

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  late String _selectedIcon = widget.isExpense ? 'cottage' : 'loyalty';
  bool _isSaving = false;
  final Controller _controller = Controller();

  List<Widget> get expenseIcon => <Widget>[
    _buildIconChoice('cottage', Icons.cottage),
    _buildIconChoice('electric_meter', Icons.electric_meter),
  ];

  List<Widget> get incomeIcon => <Widget>[
    _buildIconChoice('loyalty', Icons.loyalty),
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveCategory() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    print(_selectedIcon);

    try {
      final category = Category(
        name: _nameController.text.trim(),
        type: widget.isExpense ? 'expense' : 'income',
        icon: _selectedIcon,
        isDefault: 0,
      );

      await _controller.createCategory(category);

      // 通知上一頁刷新
      widget.onCategoryAdded?.call();

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('新增失敗：$e')));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isExpense = widget.isExpense;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isExpense ? '新增支出類別' : '新增收入類別',
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 名稱輸入
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: '類別名稱',
                  hintText: '例如：零食、醫療、兼職收入...',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '請輸入類別名稱';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              Container(
                // color: const Color(0xFFF5F5F7),
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Column(
                  children: [
                    SizedBox(
                      // padding: const EdgeInsets.all(5),
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: GridView.count(
                        crossAxisCount: 4,
                        childAspectRatio: 1.0,
                        children: widget.isExpense ? expenseIcon : incomeIcon,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // 儲存按鈕
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveCategory,
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('儲存'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconChoice(String name, IconData icon) {
    final selected = _selectedIcon == name;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedIcon = name);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(1),
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: selected ? Colors.redAccent : Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
              // shape: BoxShape.circle,
              border: Border.all(
                color: Colors.black,
                width: 1,
                style: BorderStyle.solid,
              ),
            ),
            child: Icon(
              icon,
              color: selected ? Colors.white : Colors.black,
              size: 26,
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
