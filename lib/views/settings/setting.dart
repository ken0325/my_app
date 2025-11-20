import 'package:flutter/material.dart';
import 'package:my_app/views/settings/widgets/account_info.dart';
import 'package:my_app/views/settings/widgets/common_settings.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Setting')),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              AccountInfo(),
              SizedBox(height: 5),
              CommonSettings(),
              SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }
}
