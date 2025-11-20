// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => '预算应用';

  @override
  String get login => '登录';

  @override
  String get tabHome => '首页';

  @override
  String get tabProject => '项目';

  @override
  String get settings => '设置';

  @override
  String get settingLanguage => '语言';

  @override
  String get autoBySystem => '自动';

  @override
  String get themeMode => '主题模式';

  @override
  String get darkMode => '暗黑模式';

  @override
  String get lightMode => '亮黑模式';

  @override
  String get english => '英语';

  @override
  String get simplifiedChinese => '简体中文';

  @override
  String get traditionalChinese => '繁体中文';
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

  @override
  String get appName => '預算應用';

  @override
  String get login => '登入';

  @override
  String get tabHome => '首頁';

  @override
  String get tabProject => '專案';

  @override
  String get settings => '設定';

  @override
  String get settingLanguage => '語言';

  @override
  String get autoBySystem => '自動';

  @override
  String get themeMode => '主題模式';

  @override
  String get darkMode => '暗黑模式';

  @override
  String get lightMode => '亮黑模式';

  @override
  String get english => '英文';

  @override
  String get simplifiedChinese => '簡體中文';

  @override
  String get traditionalChinese => '繁體中文';
}
