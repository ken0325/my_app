import 'package:my_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  final String key = 'locale'; // 用於保存目前語言的鍵名
  SharedPreferences? _preferences;
  String _language = ''; // 目前的語言名稱，例如：'zh'，'en'等
  
  String get language => _language; // 傳回目前語言名稱

  Locale? get locale {
    if (_language != '') {
      switch(_language) {
        case "zh_TW":
          return Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant', countryCode: 'TW');
        default:
          return Locale(_language); 
      }
    }
    return null;
  }

  // 返回用於顯示在介面中的語言名字
  static String localeName(String lang, context) {
    final localizations = AppLocalizations.of(context)!;
    switch (lang) {
      case 'en':
        return localizations.english;
      case 'zh':
        return localizations.simplifiedChinese;
      case 'zh_TW':
        return localizations.traditionalChinese;
      case '':
        return localizations.autoBySystem;
      default:
        return lang; // Return lang code as fallback or an empty string
    }
  }

  // 構造方法
  LocaleProvider() {
    _language = ''; // 預設為跟隨系統
    _loadFromPreferences();
  }

  // 初始化 SharedPreferences
  Future<void> _initialPreferences() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  // 儲存目前的語言名稱
  Future<void> _savePreferences() async {
    await _initialPreferences();
    _preferences!.setString(key, _language);
  }

  // 讀取已儲存的語言名稱
  Future<void> _loadFromPreferences() async {
    await _initialPreferences();
    _language = _preferences!.getString(key) ?? '';
    notifyListeners();
  }

  // 切換語言
  toggleChangeLocale(String language) {
    _language = language;
    // print('current locale: $language');
    _savePreferences();
    notifyListeners(); // 變更通知，在資料處理完成後執行
  }
}
