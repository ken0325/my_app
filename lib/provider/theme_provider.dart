import 'package:my_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  final String key = 'theme'; // 用於儲存目前主題狀態的鍵名
  Map<String, ThemeMode> themeModeList = <String, ThemeMode>{
    'dark': ThemeMode.dark, // 深色模式
    'light': ThemeMode.light, // 淺色模式
    'system': ThemeMode.system, // 跟随系统
  };
  SharedPreferences? _preferences;
  String _themeMode = 'system';

  String get themeMode => _themeMode; // 返回當前的主題模式

  // 構造方法
  ThemeProvider() {
    _themeMode = 'system'; // 預設為跟隨系統
    _loadFromPreferences(); // 讀取已有模式設定
  }

  // Initialize the provider
  Future<void> init() async {
    await _initialPreferences();
    await _loadFromPreferences();
  }

  // 傳回用於顯示在介面上的主題選項名稱
  static String getThemeModeName(String mode, BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    switch (mode) {
      case 'dark':
        return localizations.darkMode;
      case 'light':
        return localizations.lightMode;
      default:
        return localizations.autoBySystem;
    }
  }

  // 返回當前的主題模式
  ThemeMode getThemeMode(String themeMode) {
    return themeModeList[_themeMode] ?? ThemeMode.system;
  }

  // 深色、浅色模式设置
  ThemeData getThemeData({bool isDark = false}) {
    return ThemeData(brightness: isDark ? Brightness.dark : Brightness.light);
  }

  // 初始化 SharedPreferences
  Future<void> _initialPreferences() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  // 保存狀態
  Future<void> _savePreferences() async {
    await _preferences!.setString(key, _themeMode);
  }

  // 讀取狀態
  Future<void> _loadFromPreferences() async {
    await _initialPreferences();
    _themeMode = _preferences!.getString(key) ?? 'system';
    notifyListeners();
  }

  // 深淺色切換狀態
  void toggleChangeTheme(String val) {
    _themeMode = val;
    // print('current theme mode: $_themeMode');
    _savePreferences();
    notifyListeners(); // 變更通知，在資料處理完成後執行
  }
}
