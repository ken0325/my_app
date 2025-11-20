import 'package:flutter/material.dart';
import 'package:my_app/l10n/app_localizations.dart';

// class AccountInfoScreen extends StatefulWidget {
//   const AccountInfoScreen({Key? key}) : super(key: key);

//   @override
//   _AccountInfoScreenState createState() => _AccountInfoScreenState();
// }

// class _AccountInfoScreenState extends State<AccountInfoScreen> {

class AccountInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(top: 80, bottom: 50),
      child: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        radius: 50,
        child: Text(
          AppLocalizations.of(context)!.login,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

