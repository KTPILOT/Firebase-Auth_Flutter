import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_demo/auth/authenticate.dart';
import 'package:flutter_firebase_demo/ui/register/register.dart';
import 'package:flutter_firebase_demo/ui/theme.dart';
import 'package:provider/provider.dart';


String id ='';

class Data extends StatefulWidget {
  const Data({Key? key}) : super(key: key);

  @override
  _DataState createState() => _DataState();
}

class _DataState extends State<Data> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
            stream: AuthService.readUserData(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text("Something went wrong");
              } else if (snapshot.hasData) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.75,
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  decoration: BoxDecoration(
                    color: ThemeType.DARK == Provider.of<ThemeState>(context).theme ? Colors.grey[700] : Colors.lightBlue.shade200,
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  padding: const EdgeInsets.only(
                      top: 15, left: 10, right: 10, bottom: 15),
                  child: ListView.separated(
                      itemBuilder: (context, index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              margin: const EdgeInsets.only(top: 0),
                              height: MediaQuery.of(context).size.height * 0.15,
                              width: MediaQuery.of(context).size.width * 0.7,
                              padding: const EdgeInsets.only(left: 15, top: 10),
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: Text(
                                          'Name : ${snapshot.data!.docs[index]['name']}',
                                          style: const TextStyle(fontSize: 16),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        )),
                                        Expanded(
                                            child: Text(
                                          'Email : ${snapshot.data!.docs[index]['email']}',
                                          style: const TextStyle(fontSize: 16),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        )),
                                        Expanded(
                                            child: Text(
                                          'DOB : ${snapshot.data!.docs[index]['dob']}',
                                          style: const TextStyle(fontSize: 16),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        )),
                                        Expanded(
                                            child: Text(
                                          'Password : ${snapshot.data!.docs[index]['password']}',
                                          style: const TextStyle(fontSize: 16),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 5),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                    onPressed: () {

                                      setState(() {
                                        id = snapshot.data!.docs[index].id;


                                        // UserModel(
                                        //   password: snapshot.data!.docs[index]['password'],
                                        //   name: snapshot.data!.docs[index]['name'],
                                        //   email : snapshot.data!.docs[index]['email'],
                                        //   dob: snapshot.data!.docs[index]['dob'],
                                        // );

                                        name.text =
                                            snapshot.data!.docs[index]['name'];
                                        email.text =
                                            snapshot.data!.docs[index]['email'];
                                        password.text = snapshot
                                            .data!.docs[index]['password'];
                                        confirmPassword.text = snapshot
                                            .data!.docs[index]['password'];
                                        dateController.text =
                                            snapshot.data!.docs[index]['dob'];
                                        registration = false;
                                      });
                                      print(snapshot.data!.docs[index].data());
                                      DefaultTabController.of(context)!.animateTo(1);

                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      size: 30,
                                    )),
                                const SizedBox(height: 10),
                                IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text("Alert!",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                            content: const Text(
                                              "Do you want to delete record for these user?",
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  setState(() {});
                                                  AuthService.delete(
                                                      docId: snapshot.data!
                                                          .docs[index].id);
                                                },
                                                child: const Text(
                                                  "ok",
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                  "cancel",
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                ),
                                              )
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      size: 30,
                                    )),
                              ],
                            )
                          ],
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 10);
                      },
                      itemCount: snapshot.data!.docs.length),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {});
        },
        backgroundColor: Colors.green[600],
        child: const Icon(Icons.wifi_protected_setup_rounded),
      ),
    );
  }
}
