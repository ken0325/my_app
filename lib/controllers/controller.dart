import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' hide Transaction;
import 'package:path/path.dart';
import '../models/transaction.dart';
import '../models/category.dart';

class Controller {
  static Database? _database;
  static const String _dbName = 'finance.db';

  /// 交易表
  static const String _transactionsTable = 'transactions';

  /// 類別表
  static const String _categoriesTable = 'categories';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _dbName);
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    /// 建立類別表
    await db.execute('''
      CREATE TABLE $_categoriesTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        type TEXT NOT NULL CHECK(type IN ('income', 'expense')),
        icon TEXT,
        is_default INTEGER DEFAULT 0
      )
    ''');

    // 插入預設類別
    // await db.rawInsert('''
    //   INSERT OR IGNORE INTO $_categoriesTable (name, type, icon, is_default) VALUES
    //   ('薪水', 'income', 'work', 1),
    //   ('投資', 'income', 'trending_up', 1),
    //   ('其他收入', 'income', 'savings', 1),
    //   ('食物', 'expense', 'restaurant', 1),
    //   ('交通', 'expense', 'directions_car', 1),
    //   ('購物', 'expense', 'shopping_bag', 1),
    //   ('娛樂', 'expense', 'movie', 1),
    //   ('其他支出', 'expense', 'more_horiz', 1)
    // ''');

    final defaults = [
      {'name': '薪水', 'type': 'income', 'icon': 'work', 'is_default': 1},
      {'name': '投資', 'type': 'income', 'icon': 'trending_up', 'is_default': 1},
      {'name': '其他收入', 'type': 'income', 'icon': 'savings', 'is_default': 1},
      {'name': '食物', 'type': 'expense', 'icon': 'restaurant', 'is_default': 1},
      {
        'name': '交通',
        'type': 'expense',
        'icon': 'directions_car',
        'is_default': 1,
      },
      {
        'name': '購物',
        'type': 'expense',
        'icon': 'shopping_bag',
        'is_default': 1,
      },
      {'name': '娛樂', 'type': 'expense', 'icon': 'movie', 'is_default': 1},
      {
        'name': '其他支出',
        'type': 'expense',
        'icon': 'more_horiz',
        'is_default': 1,
      },
    ];

    for (var data in defaults) {
      // final id = await db.insert(
      await db.insert(
        _categoriesTable,
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      // print('✅ 插入 ${data['name']}: ID=$id');
    }

    // final count = Sqflite.firstIntValue(
    //   await db.rawQuery('SELECT COUNT(*) FROM $_categoriesTable'),
    // );
    // print('🎉 總共插入: $count 筆');

    /// 建立交易表
    await db.execute('''
      CREATE TABLE $_transactionsTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL NOT NULL,
        type TEXT NOT NULL CHECK(type IN ('income', 'expense')),
        category_id INTEGER NOT NULL,
        date TEXT NOT NULL,
        description TEXT,
        created_at TEXT NOT NULL,
        category_name TEXT NOT NULL,
        icon TEXT NOT NULL,
        FOREIGN KEY (category_id) REFERENCES $_categoriesTable (id)
      )
    ''');
  }

  /// ==================== 交易操作 ====================

  /// 新增交易
  Future<int> createTransaction(Transaction transaction) async {
    final db = await database;
    transaction.createdAt = DateTime.now().toIso8601String();
    return await db.insert(
      _transactionsTable,
      transaction.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// 取得所有交易 (最新在前)
  Future<List<Transaction>> getAllTransactions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _transactionsTable,
      orderBy: 'date DESC, created_at DESC',
    );

    // maps.forEach(print);

    return List.generate(maps.length, (i) => Transaction.fromMap(maps[i]));
  }

  // 取得指定月份交易
  Future<List<Transaction>> getTransactionsByMonth(String yearMonth) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT t.*, c.name as categoryName, c.icon
      FROM $_transactionsTable t
      LEFT JOIN $_categoriesTable c ON t.category_id = c.id
      WHERE strftime('%Y-%m', t.date) = ?
      ORDER BY t.date DESC, t.created_at DESC
    ''',
      [yearMonth],
    );

    return List.generate(maps.length, (i) {
      return Transaction.fromMap(maps[i]);
    });
  }

  /// 更新交易
  Future<int> updateTransaction(Transaction transaction) async {
    final db = await database;
    return await db.update(
      _transactionsTable,
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  /// 刪除交易
  Future<int> deleteTransaction(int id) async {
    final db = await database;
    return await db.delete(
      _transactionsTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// 取得總餘額
  Future<double> getTotalBalance() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT COALESCE(SUM(amount), 0) as total FROM $_transactionsTable
    ''');
    return (result.first['total'] as num).toDouble();
  }

  /// 取得當月收入
  Future<double> getMonthlyIncome(String yearMonth) async {
    final db = await database;
    final result = await db.rawQuery(
      '''
      SELECT COALESCE(SUM(amount), 0) as total 
      FROM $_transactionsTable 
      WHERE type = 'income' AND strftime('%Y-%m', date) = ?
    ''',
      [yearMonth],
    );
    return (result.first['total'] as num).toDouble();
  }

  /// 取得當月支出
  Future<double> getMonthlyExpense(String yearMonth) async {
    final db = await database;
    final result = await db.rawQuery(
      '''
      SELECT COALESCE(SUM(abs(amount)), 0) as total 
      FROM $_transactionsTable 
      WHERE type = 'expense' AND strftime('%Y-%m', date) = ?
    ''',
      [yearMonth],
    );
    return (result.first['total'] as num).toDouble();
  }

  Future<Map<String, double>> getIncomeAndExpenseAndBalance(
    String yearMonth,
    bool showOnlyThisMonth,
  ) async {
    final db = await database;

    // 1. 先組 income SQL + 參數
    final incomeSql = showOnlyThisMonth
        ? '''
        SELECT COALESCE(SUM(amount), 0) as total
        FROM $_transactionsTable
        WHERE type = 'income' AND strftime('%Y-%m', date) = ?
      '''
        : '''
        SELECT COALESCE(SUM(amount), 0) as total
        FROM $_transactionsTable
        WHERE type = 'income'
      ''';
    final incomeArgs = showOnlyThisMonth ? [yearMonth] : [];

    // 2. 再組 expense SQL + 參數
    final expenseSql = showOnlyThisMonth
        ? '''
        SELECT COALESCE(SUM(abs(amount)), 0) as total
        FROM $_transactionsTable
        WHERE type = 'expense' AND strftime('%Y-%m', date) = ?
      '''
        : '''
        SELECT COALESCE(SUM(abs(amount)), 0) as total
        FROM $_transactionsTable
        WHERE type = 'expense'
      ''';
    final expenseArgs = showOnlyThisMonth ? [yearMonth] : [];

    // 3. 查詢並安全取出 double
    final incomeResult = await db.rawQuery(incomeSql, incomeArgs);
    final expenseResult = await db.rawQuery(expenseSql, expenseArgs);

    final income = (incomeResult.first['total'] as num).toDouble();
    final expense = (expenseResult.first['total'] as num).toDouble();
    final balance = income - expense;

    return {'income': income, 'expense': expense, 'balance': balance};
  }

  Future<List<Map<String, dynamic>>> getCategoryExpenseSummary(
    String yearMonth,
    bool showOnlyThisMonth,
  ) async {
    final db = await database;

    final sql = showOnlyThisMonth
        ? '''
      SELECT 
        c.id,
        c.name,
        c.icon,
        COALESCE(SUM(ABS(t.amount)), 0) as total_expense
      FROM $_categoriesTable c
      LEFT JOIN $_transactionsTable t ON c.id = t.category_id 
        AND t.type = 'expense' 
        AND strftime('%Y-%m', t.date) = ?
      GROUP BY c.id, c.name, c.icon 
      HAVING total_expense > 0
      ORDER BY total_expense DESC, c.name ASC
    '''
        : '''
      SELECT 
        c.id,
        c.name,
        c.icon,
        COALESCE(SUM(ABS(t.amount)), 0) as total_expense
      FROM $_categoriesTable c
      LEFT JOIN $_transactionsTable t ON c.id = t.category_id 
        AND t.type = 'expense' 
      GROUP BY c.id, c.name, c.icon 
      HAVING total_expense > 0
      ORDER BY total_expense DESC, c.name ASC
    ''';

    final args = showOnlyThisMonth ? [yearMonth] : [];

    final results = await db.rawQuery(sql, args);

    return results;
  }

  // ==================== 類別操作 ====================

  /// 取得所有類別
  Future<List<Category>> getAllCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _categoriesTable,
      orderBy: 'is_default DESC, name ASC',
    );
    return List.generate(maps.length, (i) => Category.fromMap(maps[i]));
  }

  /// 根據類型取得類別
  Future<List<Category>> getCategoriesByType(String type) async {
    final db = await database;
    // final countResult = await db.rawQuery('SELECT COUNT(*) as count FROM $_categoriesTable WHERE type = ?', [type]);
    // print('📊 $type 類別數量: ${countResult.first['count']}');
    final maps = await db.query(
      _categoriesTable,
      where: 'type = ?',
      whereArgs: [type],
      orderBy: 'is_default DESC, name ASC', // ✅ 加排序
    );
    // print('🔍 實際查詢結果: ${maps.length} 筆');
    return List.generate(maps.length, (i) => Category.fromMap(maps[i]));
  }

  /// 新增類別
  Future<int> createCategory(Category category) async {
    final db = await database;
    return await db.insert(
      _categoriesTable,
      category.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  /// 更新類別
  Future<int> updateCategory(Category category) async {
    final db = await database;
    return await db.update(
      _categoriesTable,
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  /// 刪除類別 (僅非預設類別)
  Future<int> deleteCategory(int id) async {
    final db = await database;
    return await db.delete(
      _categoriesTable,
      where: 'id = ? AND is_default = 0',
      whereArgs: [id],
    );
  }

  /// 關閉資料庫
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  // ==================== other ====================

  // static IconData getIconData(String? iconName) {
  //   switch (iconName) {
  //     case 'attach_money':
  //       return Icons.attach_money;
  //     case 'restaurant':
  //       return Icons.restaurant;
  //     case 'directions_car':
  //       return Icons.directions_car;
  //     case 'shopping_bag':
  //       return Icons.shopping_bag;
  //     case 'movie':
  //       return Icons.movie;
  //     case 'work':
  //       return Icons.work;
  //     case 'trending_up':
  //       return Icons.trending_up;
  //     case 'savings':
  //       return Icons.savings;
  //     case 'category':
  //       return Icons.category;
  //     default:
  //       return Icons.category; // 預設圖示
  //   }
  // }

  static final Map<String, IconData> _iconMap = {
    /// Expense icon
    'attach_money': Icons.attach_money,
    'restaurant': Icons.restaurant,
    'directions_car': Icons.directions_car,
    'movie': Icons.movie,
    'more_horiz': Icons.more_horiz,
    'shopping_bag': Icons.shopping_bag,
    'cottage': Icons.cottage,
    'electric_meter': Icons.electric_meter,
    'category': Icons.category,
    /// income Icon
    'loyalty': Icons.loyalty,
    'savings': Icons.savings,
    'trending_up': Icons.trending_up,
    'work': Icons.work,
    
  };

  static IconData getIconData(String? iconName) {
    return _iconMap[iconName] ?? Icons.error;
  }

  String formatAmountToString(double amount) {
    if (amount == amount.roundToDouble()) {
      return amount.round().toString();
    }
    return amount.toString();
  }
}
