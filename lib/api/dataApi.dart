import 'package:dio/dio.dart';
import '../model/data.dart';

class DataApi {
  final dio = Dio();

  // 模擬交易數據
  final List<Map<String, dynamic>> _transactions = [
    {
      'amount': 45.0,
      'description': '麥當勞午餐',
      'category': '餐飲',
      'date': DateTime(2026, 1, 7),
      'isIncome': false,
    },
    {
      'amount': 12.56,
      'description': '地鐵上班',
      'category': '交通',
      'date': DateTime(2026, 1, 7),
      'isIncome': false,
    },
    {
      'amount': 120.0,
      'description': '超市購物',
      'category': '購物',
      'date': DateTime(2026, 1, 7),
      'isIncome': false,
    },
    {
      'amount': 10.0,
      'description': '自由工作者收入',
      'category': '收入',
      'date': DateTime(2026, 1, 7),
      'isIncome': true,
    },
    {
      'amount': 68.0,
      'description': '咖啡下午茶',
      'category': '餐飲',
      'date': DateTime(2026, 1, 6),
      'isIncome': false,
    },
    {
      'amount': 35.0,
      'description': '公車回家',
      'category': '交通',
      'date': DateTime(2026, 1, 6),
      'isIncome': false,
    },
    {
      'amount': 89.0,
      'description': 'Netflix月費',
      'category': '娛樂',
      'date': DateTime(2026, 1, 5),
      'isIncome': false,
    },
    {
      'amount': 10.0,
      'description': '月薪',
      'category': '收入',
      'date': DateTime(2026, 1, 1),
      'isIncome': true,
    },
    {
      'amount': 10.0,
      'description': '月薪',
      'category': '收入',
      'date': DateTime(2026, 1, 1),
      'isIncome': true,
    },
    {
      'amount': 10.0,
      'description': '月薪',
      'category': '收入',
      'date': DateTime(2025, 12, 12),
      'isIncome': true,
    },
  ];

  Future<List<Data>> formAPIExample() async {
    final response = await dio.get('');
    List<Data> list = [];
    try {
      for (int i = 0; i < response.data.length; i++) {
        Data data = Data.fromJson(response.data[i]);
        list.add(data);
      }
      return list;
    } on DioError catch (e) {
      if (e.response != null) {
        print(e.response!.data);
      } else {
        print(e.requestOptions);
        print(e.message);
      }
    }
    return list;
  }

  Future<List<Data>> getData() async {
    List<Data> list = [];
    try {
      for (int i = 0; i < _transactions.length; i++) {
        Data data = Data.fromJson(_transactions[i]);
        list.add(data);
      }
      return list;
    } on DioError catch (e) {
      if (e.response != null) {
        print(e.response!.data);
      } else {
        print(e.requestOptions);
        print(e.message);
      }
    }
    return list;
  }

  Future<Map<String, double>> getMonthlyExpensesAndIncome(
    int selectedYear,
    int selectedMonth,
  ) async {
    double expenses = 0;
    double income = 0;
    double balance = 0;

    for (final transaction in _transactions) {
      final data = Data.fromJson(transaction);
      if (data.date.year == selectedYear && data.date.month == selectedMonth) {
        data.isIncome ? income += data.amount : expenses += data.amount;
      }
    }
    balance = income - expenses;
    Map<String, double> monthlyExpensesAndIncome = {
      'expenses': expenses,
      'income': income,
      'balance': balance,
    };
    return monthlyExpensesAndIncome;
  }

  Future<Map<String, double>> getTotalExpensesAndIncome() async {
    double expenses = 0;
    double income = 0;
    double balance = 0;

    for (final transaction in _transactions) {
      final data = Data.fromJson(transaction);
      data.isIncome ? income += data.amount : expenses += data.amount;
    }

    balance = income - expenses;
    Map<String, double> totalExpensesAndIncome = {
      'expenses': expenses,
      'income': income,
      'balance': balance,
    };
    return totalExpensesAndIncome;
  }


  String formatAmountToString(double amount) {
    if (amount == amount.roundToDouble()) {
      return amount.round().toString();
    }
    return amount.toString();
  }
}
