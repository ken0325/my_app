import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_app/l10n/app_localizations.dart';
import 'package:my_app/provider/locale_provider.dart';
import 'package:my_app/provider/theme_provider.dart';


// class CommonSettings extends StatefulWidget {
//   const CommonSettings({Key? key}) : super(key: key);

//   @override
//   _CommonSettingsState createState() => _CommonSettingsState();
// }

// class _CommonSettingsState extends State<CommonSettings> {

class CommonSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // 使用 MediaQuery 获取屏幕宽度
      width: MediaQuery.of(context).size.width,
      child: Column(
        // 交叉轴对齐方式
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 15, top: 10),
            child: Text(AppLocalizations.of(context)!.settings),
          ),
          SizedBox(height: 10),
          Container(
            child: ExpansionTile(
              title: Row(
                // 主轴对齐方式
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
                // system: 表示主题模式跟随系统
                _themeModeItem(Icon(Icons.sync), 'system', context),
                // dark: 深色模式
                _themeModeItem(Icon(Icons.brightness_2), 'dark', context),
                // light：浅色模式
                _themeModeItem(Icon(Icons.wb_sunny_outlined), 'light', context),
              ],
            ),
          ),
          Container(
            child: ExpansionTile(
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
                // '': 表示 语言跟随系统
                _languageItem('', context),
                // 'zh': 表示(简体)中文
                _languageItem('zh', context),
                // 'zhtw': 表示(简体)中文
                _languageItem('zh_TW', context),
                // 'en': 表示 English
                _languageItem('en', context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 多语言设置选项
  Widget _languageItem(String lang, context) {
    return InkWell(
      onTap: () {
        // Provider 状态修改方式一：
        Provider.of<LocaleProvider>(
          context,
          listen: false,
        ).toggleChangeLocale(lang);
      },
      child: Container(
        padding: EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 0),
        child: Container(
          // 添加 ListTile 选中项的背景颜色
          decoration: new BoxDecoration(
            color: Provider.of<LocaleProvider>(context).language == lang
                ? Theme.of(context).buttonColor
                : null,
          ),
          child: ListTile(
            leading: Icon(Icons.drag_handle),
            title: Container(
              // 缩小 leading 和 title之的间隔
              transform: Matrix4.translationValues(-20, 0.0, 0.0),
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

  // 主题选择选项
  Widget _themeModeItem(Icon icon, String mode, context) {
    // Provider 状态修改方式二：1. Consumer<ThemeProvider>(builder:)
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) => InkWell(
        onTap: () {
          // Provider 状态修改方式二：2. 调用
          themeProvider.toggleChangeTheme(mode);
        },
        child: Container(
          padding: EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 0),
          child: ListTile(
            leading: icon,
            title: Container(
              // 缩小 leading 和 title之的间隔
              transform: Matrix4.translationValues(-20, 0.0, 0.0),
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
