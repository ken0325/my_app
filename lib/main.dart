import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_app/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:my_app/provider/locale_provider.dart';
import 'package:my_app/provider/theme_provider.dart';
import 'views/categoryManage.dart';
import 'views/home.dart';
import 'views/setting.dart';
import 'views/addTransaction.dart';
// import 'views/addCategory.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiProvider 用於管理多個 Provider
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider 用於對 ChangeNotifier 進行監聽
        ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider<LocaleProvider>(
          create: (context) => LocaleProvider(),
        ),
      ],

      // 透過 Consumer2 來組合同時監聽兩個結果，<>內的物件數量與 Consumer 後面的數字一致
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

                // 語言列表方式一：自動取得所有語言列表
                supportedLocales: AppLocalizations.supportedLocales,

                // 語言列表方式二：自動取得並設定一個預設語言
                // supportedLocales: [
                //   const Locale('en', ''),
                //   // ...S.delegate.supportedLocales
                //   ...AppLocalizations.supportedLocales
                // ],

                // 語言列表方式三：手動新增語言列表
                // supportedLocales: [
                //   const Locale('zh', 'CN'),
                //   const Locale('en', 'US'),
                // ],

                // localeListResolutionCallback: (locale, supportedLocales) {
                //   print(locale);
                //   return null;
                // },

                // 插件目前不完善手動處理簡繁體
                // 也用來處理 zh 和 zh_CN 這樣有兩個不同名字的語言
                // localeResolutionCallback: (locale, supportLocales) {
                //   // 中文 簡繁體處理
                //   if (locale?.languageCode == 'zh') {
                //     if (locale?.scriptCode == 'Hant') {
                //       return const Locale('zh', 'HK'); // 繁體
                //     } else {
                //       return const Locale('zh', 'CN'); // 簡體
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

                // 取得目前的語言
                locale: Provider.of<LocaleProvider>(
                  context,
                  listen: false,
                ).locale,

                title: 'myApp',

                onGenerateTitle: (context) {
                  return "myApp";
                },

                // 深色、淺色主題選擇的第一種方式
                // theme: themeProvider.darkMode ? dark_mode : light_mode,
                // theme: ThemeData(
                //   primarySwatch: Colors.blue,
                //   visualDensity: VisualDensity.adaptivePlatformDensity,
                //   useMaterial3: true,
                //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
                //   fontFamily: 'Roboto',
                // ),
                theme: ThemeData(
                  brightness: Brightness.light,
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: Colors.blue,
                    brightness: Brightness.light,
                  ),
                  useMaterial3: true,
                ),

                // 深色、淺色主題選擇的第二種方式的第一個選項
                themeMode: themeProvider.getThemeMode(
                  Provider.of<ThemeProvider>(context, listen: false).themeMode,
                ),

                // 深色、淺色主題選擇的第二種方式的第二個選項, 少了這個上面的第一個選項不起作用
                darkTheme: ThemeData(
                  brightness: Brightness.dark,
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: Colors.blue,
                    brightness: Brightness.dark,
                  ),
                  useMaterial3: true,
                ),

                // 設定文字大小不隨系統設定改變
                builder: (context, widget) {
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: widget!,
                  );
                },

                // 路由, 轉頁
                routes: {
                  "home": (context) => HomeScreen(),
                  "setting": (context) => SettingScreen(),
                  "addTransaction": (context) => AddTransactionScreen(isUpdate: false,),
                  // "addCategory": (context) => AddCategoryScreen(),
                  "categoryManage": (context) => CategoryManageScreen(),
                },
                debugShowCheckedModeBanner: false,

                // 首頁
                home: HomeScreen(),
              );
            },
      ),
    );
  }
}
