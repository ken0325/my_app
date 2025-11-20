import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_app/l10n/app_localizations.dart';

import 'package:provider/provider.dart';
import 'package:my_app/provider/locale_provider.dart';
import 'package:my_app/provider/theme_provider.dart';

import 'package:my_app/views/home.dart';
import 'package:my_app/views/settings/setting.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiProvider 用于管理多个 Provider
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider 用于对 ChangeNotifier 进行监听
        ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider(),
        ),
        // ChangeNotifierProvider 用于对 ChangeNotifier 进行监听
        ChangeNotifierProvider<LocaleProvider>(
          create: (context) => LocaleProvider(),
        ),
      ],

      // 通过 Consumer2 来组合同时监听两个结果，<>内的对象数量与 Consumer 后面的数字一致
      child: Consumer2<ThemeProvider, LocaleProvider>(
        builder:
            (
              context,
              ThemeProvider themeProvider,
              LocaleProvider localeProvider,
              child,
            ) {
              return MaterialApp(
                localizationsDelegates: [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ],

                // 语言列表方式一：自动获取所有语言列表
                supportedLocales: AppLocalizations.supportedLocales,

                // 语言列表方式二：自动获取并设置一个默认语言
                // supportedLocales: [
                //   const Locale('en', ''),
                //   // ...S.delegate.supportedLocales
                //   ...AppLocalizations.supportedLocales
                // ],
                // 语言列表方式三：手动添加语言列表
                // supportedLocales: [
                //   const Locale('zh', 'CN'),
                //   const Locale('en', 'US'),
                // ],

                // localeListResolutionCallback: (locale, supportedLocales) {
                //   print(locale); // 在控制台显示当前语言
                //                return null;
                // },

                // 插件目前不完善手动处理简繁体
                // 也用于处理 zh 和 zh_CN 这样有两个不同名字的语言
                // localeResolutionCallback: (locale, supportLocales) {
                //   // 中文 简繁体处理
                //   if (locale?.languageCode == 'zh') {
                //     if (locale?.scriptCode == 'Hant') {
                //       return const Locale('zh', 'HK'); //繁体
                //     } else {
                //       return const Locale('zh', 'CN'); //简体
                //     }
                //   }
                //   return null;
                // },
                localeResolutionCallback: (locale, supportedLocales) {
                  for (var supportedLocale in supportedLocales) {
                    if (supportedLocale.languageCode == locale?.languageCode) {
                      return supportedLocale;
                    }
                    if (locale?.languageCode == "zh" &&
                        locale?.scriptCode == "Hant") {
                      return Locale('zh', 'TW');
                    }
                  }
                  return supportedLocales.first;
                },

                // 获取 当前的语言
                locale: Provider.of<LocaleProvider>(
                  context,
                  listen: false,
                ).locale,

                title: 'xAPP',
                // 生成应用标题
                onGenerateTitle: (context) {
                  return "appName";
                },

                // 深色、浅色主题选择 的第一种方式
                // theme: themeProvider.darkMode ? dark_mode : light_mode,
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                ),

                // 深色、浅色主题选择 的第二种方式的第一个选项
                themeMode: themeProvider.getThemeMode(
                  Provider.of<ThemeProvider>(context, listen: false).themeMode,
                ),

                // 深色、浅色主题选择 的第二种方式的第二个选项, 少了这个上面的第一个选项不起作用
                darkTheme: ThemeData(brightness: Brightness.dark),

                // 设置文字大小不随系统设置改变
                builder: (context, widget) {
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: widget!,
                  );
                },
                routes: {"setting": (context) => SettingScreen()},
                debugShowCheckedModeBanner: false,
                home: HomeScreen(),
              );
            },
      ),
    );
  }
}
