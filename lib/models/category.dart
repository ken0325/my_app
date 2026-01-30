// class Category {
//   int? _id;
//   String _icon; // 存 icon 名稱，例如 'attach_money'
//   String _name;
//   String _type; // 'income' or 'expense'
//   int _isDefault;

//   get id => _id;

//   set id(value) => _id = value;

//   get icon => _icon;

//   set icon(value) => _icon = value;

//   get name => _name;

//   set name(value) => _name = value;

//   get type => _type;

//   set type(value) => _type = value;

//   get isDefault => _isDefault;

//   set isDefault(value) => _isDefault = value;

//   // Category(this._id, this._icon, this._name, this._type, this._isDefault, {required String name});

//     Category({
//     int? id, // id 可選，無命名問題
//     required String icon,
//     required String name,
//     required String type,
//     required int isDefault,

//   }) : _icon = icon, // ✅ 初始化列表指定私有欄位
//        _name = name,
//        _type = type,
//        _isDefault = isDefault;

//   Map<String, dynamic> toMap() {
//     return {
//       'id': _id,
//       'icon': _icon,
//       'name': _name,
//       'type': _type,
//       'isDefault': _isDefault,
//     };
//   }

//   factory Category.fromMap(Map<String, dynamic> map) {
//     return Category(
//       id: map['id'] as int?,
//       icon: map['icon'] as String,
//       name: map['name'] as String,
//       type: map['type'] as String,
//       isDefault: map['isDefault'] as int,
//     );
//   }

//   // factory Category.fromJson(Map<String, dynamic> json) {
//   //   return Category(
//   //     json['id'],
//   //     json['icon'],
//   //     json['name'],
//   //     json['type'],
//   //     json['isDefault'],
//   //   );
//   // }
// }

class Category {
  int? _id;
  String _name;
  String _type; // 'income' or 'expense'
  String _icon;
  int _isDefault;

  get id => _id;

  set id(value) => _id = value;

  get icon => _icon;

  set icon(value) => _icon = value;

  get name => _name;

  set name(value) => _name = value;

  get type => _type;

  set type(value) => _type = value;

  get isDefault => _isDefault;

  set isDefault(value) => _isDefault = value;

  Category({
    int? id,
    required String name,
    required String type,
    required String icon,
    required int isDefault,
  }) : _id = id,
       _name = name,
       _type = type,
       _icon = icon,
       _isDefault = isDefault;

  Map<String, dynamic> toMap() {
    return {
      // 'id': _id,
      'name': _name,
      'type': _type,
      'icon': _icon,
      'is_default': _isDefault,
    };
  }
  // From database map - handles null safety to fix your error
  // factory Category.fromMap(Map<String, dynamic> map) {
  //   return Category(
  //     id: map['id'] as int?, // Safe nullable int cast
  //     name: map['name'] as String,
  //     type: map['type'] as String,
  //     icon: map['icon'] as String?,
  //     isDefault: (map['is_default'] as int?) ?? 0, // Fix for your line 58 error
  //   );
  // }

  // factory Category.fromMap(Map<String, dynamic> map) {
  //   return Category(
  //     id: map['id'],
  //     name: map['name'],
  //     type: map['type'],
  //     icon: map['icon'],
  //     isDefault: (map['is_default'] as int?) ?? 0,
  //   );
  // }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      // id: map['id'] is int
      //     ? map['id'] as int
      //     : (map['id'] as num?)?.toInt() ?? 0,
      id: map['id'],
      name: map['name'] as String,
      type: map['type'] as String,
      icon: map['icon'] as String? ?? 'category', // ✅ 修正1: 允許null，預設值
      isDefault: (map['is_default'] as int?) ?? 0, // ✅ 修正2: 用DB欄位名 is_default
    );
  }
}
