// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_demo/model/user_model.dart';

class AuthService {
  static String? userid;


  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user;

  Future<User?> registerUsingEmailPassword({
    required String name,
    required String date,
    required String email,
    required String password}
  ) async {

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
      user!.updateDisplayName(name);
      await user!.reload();
      user = auth.currentUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    return user;
  }

// For signing in an user (have already registered)
   Future<User?> signInUsingEmailPassword({
    required String email,
    required String password,
  }) async {
     try {
     UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

     user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided.');
      }
    }catch(e){
       print(e);
     }
     return user;
  }

  static Stream<QuerySnapshot> readUserData(){
    CollectionReference collection = FirebaseFirestore.instance.collection('userCollection');

    return collection.snapshots();
  }

  static Future<void> update({
    required String name,
    required String date,
    required String email,
    required String password,
    String? docId,
    // required String confirmPassword,
}) async{
    DocumentReference documentReference = FirebaseFirestore.instance.collection('userCollection').doc(docId);
    Map<String,dynamic> data = <String,dynamic>{
      "name" : name,
      "dob" : date,
      "email" : email,
      "password": password,
    };
    await documentReference.update(data).whenComplete(() => print("updated item"));
  }


  static Future<void> updateUser(UserModel model) async{
    await FirebaseFirestore.instance.collection('userCollection').doc(model.referenceId).update(model.toJson());
  }


  static Future<void> delete({
  required String docId
}) async{
    DocumentReference reference = FirebaseFirestore.instance.collection('userCollection').doc(docId);
    await reference.delete().whenComplete(() => print('record Deleted'));
  }

  void deleteUser() async{
    FirebaseAuth.instance.currentUser!.delete();
  }

}
