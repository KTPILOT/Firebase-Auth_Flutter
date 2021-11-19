import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_demo/model/user_model.dart';
import 'package:flutter_firebase_demo/ui/dashboard/dashboard.dart';
import 'package:flutter_firebase_demo/ui/theme.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ChangeNotifierProvider<ThemeState>(
    create: (BuildContext context) => ThemeState(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme:Provider.of<ThemeState>(context,listen: false).theme == ThemeType.DARK ? ThemeData.dark() : ThemeData.light(),
      home: const DashBoardScreen(1, isRegistration: true),
    );
  }
}
