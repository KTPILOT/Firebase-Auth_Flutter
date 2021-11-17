import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {

  String name;
  String email;
  String password;
  String dob;
  String? referenceId;

  UserModel({this.referenceId ,required this.password,
    required this.dob, required this.email,required this.name});

  factory UserModel.fromSnapShot(DocumentSnapshot snapshot){
    final userModel = UserModel.fromJson(snapshot.data() as Map<String,dynamic>);
    userModel.referenceId = snapshot.reference.id;
    return userModel;
  }

  factory UserModel.fromJson(Map<String,dynamic> json) => _userModelfromJson(json);
  Map<String,dynamic> toJson() => _userModeltoJson(this);
}


UserModel _userModelfromJson(Map<String, dynamic> json) {
  return UserModel(
    dob: json['dob'] as String,
    email: json['email'] as String,
    name: json['name'] as String,
    password: json['password'] as String,
  );
}

Map<String,dynamic> _userModeltoJson(UserModel data) => <String, dynamic>{
  'name' : data.name,
  'email' : data.email,
  'dob' : data.dob,
  'password' : data.password,
};
