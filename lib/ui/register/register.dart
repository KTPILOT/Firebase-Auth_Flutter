import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_demo/auth/authenticate.dart';
import 'package:flutter_firebase_demo/model/user_model.dart';
import 'package:flutter_firebase_demo/ui/data.dart';


TextEditingController email = TextEditingController();
TextEditingController name = TextEditingController();
TextEditingController password = TextEditingController();
TextEditingController confirmPassword = TextEditingController();
TextEditingController dateController = TextEditingController();

bool? registration;

class Register extends StatefulWidget {
  const Register({Key? key, required this.flag}) : super(key: key);
  final int flag;

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final userRef = FirebaseFirestore.instance.collection('userCollection');
  //
  // TextEditingController email = TextEditingController();
  // TextEditingController name = TextEditingController();
  // TextEditingController password = TextEditingController();
  // TextEditingController confirmPassword = TextEditingController();
  // TextEditingController dateController = TextEditingController();

  // final UserModel model = UserModel.fromSnapShot(snapshot);

  bool textRegister = false;
  bool textRegister2 = false;

  DateTime date = DateTime.now();
  final GlobalKey<FormState> _keyA = GlobalKey<FormState>();

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Center(
      child: SingleChildScrollView(
        child: Container(
            height: MediaQuery.of(context).size.height * 0.58,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              color: Colors.lightBlue.shade200,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Form(
              key: _keyA,
              child: Column(
                children: [
                  TextFormField(
                    controller: name,
                    decoration:
                        const InputDecoration(hintText: 'Enter Your Name'),
                  ),
                  TextFormField(
                    controller: email,
                    decoration:
                        const InputDecoration(hintText: 'Enter Your Email'),
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
                    readOnly: true,
                    controller: dateController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter a Date';
                      }
                      if (date.millisecondsSinceEpoch >
                          DateTime.now().millisecondsSinceEpoch -
                              568128182355) {
                        return 'You must be 18 years old';
                      }
                    },
                    onTap: () {
                      _showDate(context);
                    },
                    decoration: const InputDecoration(
                      hintText: "Date Of Birth",
                    ),
                  ),
                  TextFormField(
                    controller: password,
                    decoration: InputDecoration(
                        hintText: 'Enter Your Password',
                        suffix: IconButton(
                          icon: Icon(
                            Icons.remove_red_eye,
                            color: Colors.lightBlue.shade400,
                          ),
                          onPressed: () {
                            setState(() {
                              textRegister = !textRegister;
                            });
                          },
                        )),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter Your Password";
                      }
                      if (value.length < 4) {
                        return "Enter Correct Password";
                      }
                      return null;
                    },
                    obscureText: !textRegister,
                  ),
                  TextFormField(
                    controller: confirmPassword,
                    decoration: InputDecoration(
                        hintText: 'Re-Enter Your Password',
                        suffix: IconButton(
                          icon: Icon(
                            Icons.remove_red_eye,
                            color: Colors.lightBlue.shade400,
                          ),
                          onPressed: () {
                            setState(() {
                              textRegister2 = !textRegister2;
                            });
                          },
                        )),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter Your Password";
                      }
                      if (confirmPassword.text != password.text) {
                        return "Password Not Match";
                      }
                      return null;
                    },
                    obscureText: !textRegister2,
                  ),
                  const SizedBox(height: 15),
                  InkWell(
                    onTap: () async {
                      if (_keyA.currentState!.validate()) {
                        if (registration == false) {

                          await Firebase.initializeApp();

                          final updateUser = UserModel(password: password.text, referenceId: id,
                              dob: dateController.text, email: email.text, name: name.text);

                          await AuthService.updateUser(updateUser);

                          // await AuthService.update(name: name.text,
                          //     date: dateController.text,
                          //     email: email.text, password: password.text);

                          DefaultTabController.of(context)!.animateTo(2);

                          // Navigator.pushReplacement(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => const MyHomePage(2,
                          //             isRegistration: true)));

                          setState((){
                            clear();
                            registration = true;
                          });

                        } else {
                          await Firebase.initializeApp();
                          User? user = await AuthService()
                              .registerUsingEmailPassword(
                                  name: name.text,
                                  email: email.text,
                                  date: dateController.text,
                                  password: password.text);

                          if (user != null) {


                            DefaultTabController.of(context)!.animateTo(2);

                            // Navigator.pushReplacement(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => const MyHomePage(2,
                            //             isRegistration: true)));

                            Map<String, dynamic> userDataMap = {
                              'email': email.text.trim(),
                              'name': name.text.trim(),
                              'password': password.text.trim(),
                              'dob': dateController.text.trim()
                            };
                            userRef.doc(user.uid).set(userDataMap);
                          }
                          setState((){
                            clear();
                          });
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
                        child: Text(
                          registration == false ? "Update" : "Register",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                        )),
                  )
                ],
              ),
            )),
      ),
    );
  }

  _showDate(BuildContext context) async {
    final pick = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(1950),
        lastDate: DateTime(2025));
    if (pick != null && pick != date) {
      setState(() {
        date = pick;
        var selectedDate =
            "${pick.toLocal().day}/${pick.toLocal().month}/${pick.toLocal().year}";
        dateController.text = selectedDate;
      });
    }
  }
  void clear(){
    name.clear();
    email.clear();
    password.clear();
    confirmPassword.clear();
    dateController.clear();
  }
}
