class Transaction {
  int? _id;
  double _amount;
  String _type; // 'income' or 'expense'
  int _categoryId;
  String _date; // '2026-01-22'
  String? _description;
  String _createdAt;
  String? _categoryName;
  String? _icon;

  get id => _id;

  set id(value) => _id = value;

  get amount => _amount;

  set amount(value) => _amount = value;

  get type => _type;

  set type(value) => _type = value;

  get categoryId => _categoryId;

  set categoryId(value) => _categoryId = value;

  get date => _date;

  set date(value) => _date = value;

  get description => _description;

  set description(value) => _description = value;

  get createdAt => _createdAt;

  set createdAt(value) => _createdAt = value;

  // get categoryName => _categoryName;
  String get categoryName => _categoryName ?? '未知類別';

  set categoryName(value) => _categoryName = value;

  get icon => _icon;

  set icon(value) => _icon = value;

  // Transaction(
  //   this._id,
  //   this._amount,
  //   this._type,
  //   this._categoryId,
  //   this._date,
  //   this._description,
  //   this._createdAt,
  // );

  Transaction({
    int? id, // id 可選，無命名問題
    required double amount, // ✅ 公開命名參數
    required String type,
    required int categoryId,
    required String date,
    String? description,
    required String createdAt,
    required String categoryName,
    required String icon,
  }) : _id = id,
       _amount = amount, // ✅ 初始化列表指定私有欄位
       _type = type,
       _categoryId = categoryId,
       _date = date,
       _description = description,
       _createdAt = createdAt,
       _categoryName = categoryName,
       _icon = icon;

  Map<String, dynamic> toMap() {
    return {
      // 'id': _id,
      'amount': _amount,
      'type': _type,
      'category_id': _categoryId,
      'date': _date,
      'description': _description,
      'created_at': _createdAt,
      'category_name': _categoryName,
      'icon': icon,
    };
  }

  // factory Transaction.fromMap(Map<String, dynamic> map) {
  //   return Transaction(
  //     map['id'],
  //     (map['amount'] as num).toDouble(),
  //     map['type'],
  //     map['category_id'],
  //     map['date'],
  //     map['description'],
  //     map['created_at'],
  //   );
  // }

  // factory Transaction.fromMap(Map<String, dynamic> map) {
  //   return Transaction(
  //     id: map['id'],
  //     amount: (map['amount'] as num).toDouble(),
  //     type: map['type'],
  //     categoryId: map['category_id'],
  //     date: map['date'],
  //     description: map['description'],
  //     createdAt: map['created_at'],
  //     categoryName: map['category_name'],
  //     icon: map['icon'],
  //   );
  // }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      amount: (map['amount'] as num).toDouble(), // ✅ null 安全
      type: map['type'], // ✅ null → 預設值
      categoryId: map['category_id'], // ✅ null → 0
      date: map['date'],
      description: map['description'], // ✅ 可選
      createdAt: map['created_at'],
      categoryName: map['category_name'], // ✅ 可選（JOIN 結果）
      icon: map['icon'], // ✅ 可選
      // ✅ 可選
    );
  }

  // factory Transaction.fromJson(Map<String, dynamic> json) {
  //   return Transaction(
  //     json['id'],
  //     json['amount'],
  //     json['type'],
  //     json['category_id'],
  //     json['date'],
  //     json['description'],
  //     json['created_at'],
  //   );
  // }
}
