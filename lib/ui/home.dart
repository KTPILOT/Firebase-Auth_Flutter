import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_demo/auth/authenticate.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("User Profile", style: TextStyle(color: Colors.black),),
        actions: [
          IconButton(icon: const Icon(Icons.logout, color: Colors.black,), onPressed: () async {
            showDialog(
              context: context,
              builder: (context) {
                if(AuthService().auth.currentUser == null) {
                  return AlertDialog(title:const Text("Alert!",
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w700)),
                    content: const Text(
                      "No user login found",
                      style: TextStyle(fontSize: 16),
                    ),
                    actions: [TextButton(onPressed: () {
                      Navigator.pop(context);
                    }, child:const  Text("ok", style: TextStyle(
                        fontSize: 15
                    ),),)
                    ],
                  );
                }
                else {
                  return AlertDialog(title: const Text("Alert!",
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w700)),
                    content: const Text(
                      "Do you want to logout user?",
                      style: TextStyle(fontSize: 16),
                    ),
                    actions: [TextButton(onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        FirebaseAuth.instance.signOut();
                      });
                    }, child: const Text("ok", style: TextStyle(
                        fontSize: 15
                    ),),),

                      TextButton(onPressed: () {
                        Navigator.pop(context);
                      }, child:const Text("cancel", style: TextStyle(
                          fontSize: 15
                      ),),)
                    ],
                  );
                }
              },
            );
          },)
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(30),
        height: MediaQuery.of(context).size.height * 0.15,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
      color: Colors.lightBlue.shade200,
      borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        padding: const EdgeInsets.only(left: 20 ,right: 20, top: 20),
           child: StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('userCollection').snapshots(),
      builder: (context, snapshot) {
        if(AuthService().auth.currentUser == null){
          return const Text("Please Login", style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w600
          ),);
        }
        else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('User Name : ${AuthService().auth
                  .currentUser!.displayName}',
                  style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 10),
              Text("User Email ID : ${ AuthService().auth
                  .currentUser!.email}",
                  style: const TextStyle(fontSize: 20)),
            ],
          );
        }
      }
        ),
      ),
    );
  }
}
