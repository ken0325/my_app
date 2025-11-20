import 'package:my_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  final String key = 'theme'; // 用于保存当前主题状态的键名
  // 定义用于三种主题模式的字典
  Map<String, ThemeMode> themeModeList = <String, ThemeMode>{
    'dark': ThemeMode.dark, // 深色模式
    'light': ThemeMode.light, // 浅色模式
    'system': ThemeMode.system, // 跟随系统
  };

  SharedPreferences? _preferences;
  String _themeMode = 'system';

  // 返回当前的主题模式
  String get themeMode => _themeMode;

  // 构造方法
  ThemeProvider() {
    _themeMode = 'system'; // 默认为跟随系统
    _loadFromPreferences(); // 读取已有模式设置
  }

  // Initialize the provider
  Future<void> init() async {
    await _initialPreferences();
    await _loadFromPreferences();
  }

  // 返回用于显示在界面上的主题选项名称
  // static String getThemeModeName(String mode, context) {
  //   switch (mode) {
  //     case 'dark':
  //       return "darkMode";
  //     case 'light':
  //       return "lightMode";
  //     default:
  //       return "autoBySystem";
  //   }
  // }

  static String getThemeModeName(String mode, BuildContext context) {
    // final localizations = AppLocalizations.of(context)!;
    switch (mode) {
      case 'dark':
        return AppLocalizations.of(context)!.darkMode;
      case 'light':
        return AppLocalizations.of(context)!.lightMode;
      default:
        return AppLocalizations.of(context)!.autoBySystem;
    }
  }

  // 返回当前的主题模式
  // ThemeMode getThemeMode(String mode) {
  //   return themeModeList[mode];
  // }

  ThemeMode getThemeMode(String themeMode) {
    return themeModeList[_themeMode] ?? ThemeMode.system;
  }

  // 深色、浅色模式设置
  ThemeData getThemeData({bool isDark = false}) {
    return ThemeData(brightness: isDark ? Brightness.dark : Brightness.light);
  }

  // 初始化 SharedPreferences
  // _initialPreferences() async {
  //   if (_preferences == null)
  //     _preferences = await SharedPreferences.getInstance();
  // }
  Future<void> _initialPreferences() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  //  保存状态
  Future<void> _savePreferences() async {
    await _preferences!.setString(key, _themeMode);
  }
  //   Future<void> _savePreferences() async {
  //   await _preferences!.setString(key, _themeMode);
  // }

  // 读取状态
  // _loadFromPreferences() async {
  //   await _initialPreferences();
  //   _themeMode = _preferences.getString(key) ?? 'system';
  //   notifyListeners(); // 变更通知，在数据处理完成后执行
  // }

  Future<void> _loadFromPreferences() async {
    await _initialPreferences();
    _themeMode = _preferences!.getString(key) ?? 'system';
    notifyListeners();
  }

  // 深浅色切换状态
  // toggleChangeTheme(val) {
  //   _themeMode = val;
  //   print('current theme mode: $_themeMode');
  //   _savePreferences();
  //   notifyListeners(); // 变更通知，在数据处理完成后执行
  // }
  void toggleChangeTheme(String val) {
    _themeMode = val;
    //   print('current theme mode: $_themeMode');
    _savePreferences();
    notifyListeners(); // 变更通知，在数据处理完成后执行
  }
}
