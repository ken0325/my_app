import 'package:my_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  final String key = 'locale'; // 用于保存当前语言的键名

  SharedPreferences? _preferences;

  String _language = ''; // 当前的语言名称，例如：'zh'，'en'等

  String get language => _language; // 返回当前语言名称

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

  // 返回用于显示在界面中的语言名字
  static String localeName(String lang, context) {
    switch (lang) {
      case 'en':
        return AppLocalizations.of(context)!.english;
      case 'zh':
        return AppLocalizations.of(context)!.simplifiedChinese;
      case 'zh_TW':
        return AppLocalizations.of(context)!.traditionalChinese;
      case '':
        return AppLocalizations.of(context)!.autoBySystem;
      default:
        return lang; // Return lang code as fallback or an empty string
    }
  }

  // 构造方法
  LocaleProvider() {
    _language = ''; // 默认语言跟随系统
    _loadFromPreferences();
  }

  // 初始化 SharedPreferences
  Future<void> _initialPreferences() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  // 保存当前的语言名称
  Future<void> _savePreferences() async {
    await _initialPreferences();
    _preferences!.setString(key, _language);
  }

  // 读取已保存的语言名称
  Future<void> _loadFromPreferences() async {
    await _initialPreferences();
    _language = _preferences!.getString(key) ?? '';
    notifyListeners();
  }

  // 切换语言
  toggleChangeLocale(String language) {
    _language = language;
    // print('current locale: $language');

    _savePreferences();
    notifyListeners(); // 变更通知，在数据处理完成后执行
  }
}
