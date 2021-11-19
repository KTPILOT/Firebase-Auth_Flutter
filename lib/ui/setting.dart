import 'package:flutter/material.dart';
import 'package:flutter_firebase_demo/ui/theme.dart';
import 'package:provider/provider.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Mode"),
      ),
      body: Center(
        child: ListTile(
          title: const Text("Dark Mode"),
          trailing: Switch(value: Provider.of<ThemeState>(context, listen: false).theme == ThemeType.DARK,
              onChanged: (value) {
                  setState(() {
                    Provider.of<ThemeState>(context ,listen: false).theme = value ? ThemeType.DARK : ThemeType.LIGHT;
                  });
              }),
        )
      ),
    );
  }
}
