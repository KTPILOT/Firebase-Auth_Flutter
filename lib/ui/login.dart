import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_demo/auth/authenticate.dart';
import 'package:flutter_firebase_demo/main.dart';

class Login extends StatefulWidget {
 const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController emailController =  TextEditingController();
  TextEditingController passwordLogin =  TextEditingController();

  bool textRegister = false;
  bool textRegister2 = false;
  bool textLogin = false;

  DateTime date = DateTime.now();
  final _key = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: _key,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.34,
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            color: Colors.lightBlue.shade200,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          padding:const  EdgeInsets.only(top: 20, bottom: 30, left: 20, right: 20),
          child: Column(
            children: [
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(hintText: 'Enter Your Email'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value!.isEmpty ||
                      !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                          .hasMatch(value)) {
                    return "Enter Valid Email";
                  }
                },
              ),
              TextFormField(
                controller: passwordLogin,
                decoration: InputDecoration(
                    hintText: 'Enter Your Password',
                    suffix: IconButton(
                      icon: Icon(
                        Icons.remove_red_eye,
                        color: Colors.lightBlue.shade400,
                      ),
                      onPressed: () {
                        setState(() {
                          textLogin = !textLogin;
                        });
                      },
                    )),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter Your Password";
                  }
                  if (value.length < 5) {
                    return "Enter Correct Password";
                  }
                  return null;
                },
                obscureText: !textLogin,
              ),
              const SizedBox(height: 15),
              InkWell(
                onTap: () async {
                  if(_key.currentState!.validate()) {
                     await Firebase.initializeApp();
                    User? user = await AuthService().signInUsingEmailPassword(
                        email: emailController.text, password: passwordLogin.text);
                    if (user != null) {
                      showDialog(
                        context: context,
                        builder: (context) =>
                            AlertDialog(title: const Text("Welcome!",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w700)),
                              content: Text(
                                "Hello ${user.displayName}",
                                style: const TextStyle(fontSize: 16),
                              ),
                              actions: [TextButton(onPressed: () {
                                Navigator.pop(context);

                                DefaultTabController.of(context)!.animateTo(3);

                                // Navigator.pushReplacement(context,
                                //     MaterialPageRoute(
                                //       builder: (context) =>  const MyHomePage(3, isRegistration: false),));
                              }, child: const Text("ok", style: TextStyle(
                                  fontSize: 15
                              ),),)
                              ],
                            ),
                      );
                    }
                    else {
                      showDialog(
                        context: context,
                        builder: (context) =>
                            Dialog(
                                child: SizedBox(
                                    height: MediaQuery
                                        .of(context)
                                        .size
                                        .height * 0.2,
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width * 0.7,
                                    child: const Center(
                                        child: Text(
                                          "User not found",
                                          style: TextStyle(fontSize: 20),
                                        )))),
                      );
                    }
                  }
                },
                child: Container(
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 10, left: 15, right: 15),
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
