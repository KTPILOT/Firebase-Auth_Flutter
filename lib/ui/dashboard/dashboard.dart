
import 'package:flutter/material.dart';
import 'package:flutter_firebase_demo/ui/data.dart';
import 'package:flutter_firebase_demo/ui/home.dart';
import 'package:flutter_firebase_demo/ui/login.dart';
import 'package:flutter_firebase_demo/ui/register/register.dart';
import 'package:flutter_firebase_demo/ui/setting.dart';
import 'package:flutter_firebase_demo/ui/theme.dart';
import 'package:provider/provider.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen(this.indexSelected, {Key? key,required this.isRegistration}) : super(key: key);

  final bool? isRegistration;
  final int indexSelected;

  Future<void> onGoBack() async{
    return;
  }

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {

  // Future<void> onGoBack() async {
  //     setState(() {
  //       Provider.of<ThemeState>(context, listen: false).theme == ThemeType.LIGHT ? ThemeType.LIGHT :ThemeType.DARK;
  //     });
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 4,
        initialIndex: widget.indexSelected,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            elevation :0,
            title: const Text("User Integration"),
            bottom: const TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.shield)),
                  Tab(icon: Icon(Icons.person)),
                  Tab(icon: Icon(Icons.people)),
                  Tab(icon: Icon(Icons.home)),
                ]),
            actions: [IconButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder:(context) => const Setting(),));
            }, icon: Icon(Icons.settings))],
          ),
          body:   TabBarView(
            children: [ const Login(), registration == true ? const Register(flag: 0) :
            const Register(flag: 1),  const Data(),  const Home()],
          ),
        ),
      ),
    );
  }
}