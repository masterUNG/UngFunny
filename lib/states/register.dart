import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ungfunny/models/user_model.dart';
import 'package:ungfunny/utility/dialog.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String name, email, password;

  Container buildContainerName() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: 250,
      child: TextField(
        onChanged: (value) => name = value.trim(),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Name :',
          prefixIcon: Icon(Icons.fingerprint),
        ),
      ),
    );
  }

  Container buildContainerEmail() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: 250,
      child: TextField(
        onChanged: (value) => email = value.trim(),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Email :',
          prefixIcon: Icon(Icons.email),
        ),
      ),
    );
  }

  Container buildContainerPassword() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: 250,
      child: TextField(
        onChanged: (value) => password = value.trim(),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Password :',
          prefixIcon: Icon(Icons.lock),
        ),
      ),
    );
  }

  Future<Null> registerAndInsertData() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        String uid = value.user.uid;
        print('Register Success uid = $uid');

        UserModel model =
            UserModel(email: email, name: name, password: password);
        Map<String, dynamic> data = model.toMap();

        await FirebaseFirestore.instance
            .collection('user')
            .doc(uid)
            .set(data)
            .then(
              (value) => Navigator.pop(context),
            );
      }).catchError((value) {
        normalDialog(context, value.message);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('name = $name, email = $email, password = $password');
          if (name == null ||
              name.isEmpty ||
              email == null ||
              email.isEmpty ||
              password == null ||
              password.isEmpty) {
            normalDialog(context, 'มีช่อง ? กรุณากรอกทุกช่อง คะ');
          } else {
            registerAndInsertData();
          }
        },
        child: Text('Regis'),
      ),
      appBar: AppBar(
        title: Text('New Registor'),
      ),
      body: Center(
        child: Column(
          children: [
            buildContainerName(),
            buildContainerEmail(),
            buildContainerPassword(),
          ],
        ),
      ),
    );
  }
}
