import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_app/l10n/app_localizations.dart';
import 'package:my_app/provider/locale_provider.dart';
import 'package:my_app/provider/theme_provider.dart';

class CommonSettings extends StatelessWidget {
  const CommonSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Padding(
          //   padding: EdgeInsets.only(left: 15, top: 10),
          //   child: Text(AppLocalizations.of(context)!.settings),
          // ),
          // SizedBox(height: 10),
          ExpansionTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)!.themeMode),
                Text(
                  ThemeProvider.getThemeModeName(
                    Provider.of<ThemeProvider>(context).themeMode,
                    context,
                  ),
                ),
              ],
            ),
            children: [
              _themeModeItem(
                Icon(Icons.sync),
                'system',
                context,
              ), // system: 表示主題模式跟隨系統
              _themeModeItem(
                Icon(Icons.brightness_2),
                'dark',
                context,
              ), // dark: 深色模式
              _themeModeItem(
                Icon(Icons.wb_sunny_outlined),
                'light',
                context,
              ), // light: 淺色模式
            ],
          ),
          ExpansionTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)!.settingLanguage),
                Text(
                  LocaleProvider.localeName(
                    Provider.of<LocaleProvider>(context).language,
                    context,
                  ),
                ),
              ],
            ),
            children: [
              _languageItem('', context), // '': 表示語言跟隨系統
              _languageItem('zh', context), // 'zh': 表示(簡體)中文
              _languageItem('zh_TW', context), // 'zhtw': 表示(繁體)中文
              _languageItem('en', context), // 'en': 表示 English
            ],
          ),
        ],
      ),
    );
  }

  // 表示(繁體)中文
  Widget _languageItem(String lang, context) {
    return InkWell(
      onTap: () {
        // Provider 狀態修改方式一：
        Provider.of<LocaleProvider>(
          context,
          listen: false,
        ).toggleChangeLocale(lang);
      },
      child: Container(
        padding: EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 0),
        child: Container(
          // 新增 ListTile 選取項目的背景顏色
          decoration: BoxDecoration(
            color: Provider.of<LocaleProvider>(context).language == lang
                ? Theme.of(context).buttonColor
                : null,
          ),
          child: ListTile(
            // leading: Icon(Icons.drag_handle),
            title: Container(
              // 縮小 leading 和 title之的間隔
              // transform: Matrix4.translationValues(-20, 0.0, 0.0),
              child: Text(
                LocaleProvider.localeName(lang, context),
                // style: TextStyle(
                //   color: Provider.of<LocaleProvider>(context).language == lang
                //       ? Theme.of(context).primaryColor
                //       : null,
                // ),
              ),
            ),
            // title: Text(LocaleProvider.localeName(lang, context)),
            // trailing: Opacity(
            //   opacity:
            //       Provider.of<LocaleProvider>(context).language == lang ? 1 : 0,
            //   child: Icon(Icons.done),
            // ),
            trailing: Provider.of<LocaleProvider>(context).language == lang
                ? Icon(Icons.done)
                : null,
          ),
        ),
      ),
    );
  }

  // 主題選擇選項
  Widget _themeModeItem(Icon icon, String mode, context) {
    // Provider 狀態修改方式二：1. Consumer<ThemeProvider>(builder:)
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) => InkWell(
        onTap: () {
          // Provider 狀態修改方式二：2. 調用
          themeProvider.toggleChangeTheme(mode);
        },
        child: Container(
          padding: EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 0),
          child: ListTile(
            leading: icon,
            title: Container(
              // 縮小 leading 和 title之的間隔
              // transform: Matrix4.translationValues(-20, 0.0, 0.0),
              child: Text(ThemeProvider.getThemeModeName(mode, context)),
            ),
            // trailing: Opacity(
            //   opacity: themeProvider.themeMode == mode ? 1 : 0,
            //   child: Icon(Icons.done),
            // ),
            trailing: themeProvider.themeMode == mode ? Icon(Icons.done) : null,
          ),
        ),
      ),
    );
  }
}

extension on ThemeData {
  get buttonColor => null;
}
