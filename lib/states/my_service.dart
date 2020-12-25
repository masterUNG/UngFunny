import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ungfunny/models/user_model.dart';
import 'package:ungfunny/states/authen.dart';
import 'package:ungfunny/states/information.dart';
import 'package:ungfunny/states/show_ebook.dart';

class MyService extends StatefulWidget {
  @override
  _MyServiceState createState() => _MyServiceState();
}

class _MyServiceState extends State<MyService> {
  UserModel model;
  Widget currentWidget = ShowEbook();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findDataLogin();
  }

  Future<Null> findDataLogin() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) async {
        String uid = event.uid;
        // print('uid = $uid');
        await FirebaseFirestore.instance
            .collection('user')
            .doc(uid)
            .snapshots()
            .listen((event) {
          // print('event form Firestore = ${event.toString()}');
          setState(() {
            model = UserModel.fromMap(event.data());
          });
          // print('name = ${model.name}');
        });
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(model == null ? 'Service for => ' : model.name),
      ),
      drawer: Drawer(
        child: Stack(
          children: [
            Column(
              children: [
                buildUserAccountsDrawerHeader(),
                buildListTileShowEbook(),
                buildListTileInformation(),
              ],
            ),
            buildSignOut(context),
          ],
        ),
      ),
      body: currentWidget,
    );
  }

  ListTile buildListTileShowEbook() => ListTile(
        leading: Icon(Icons.import_contacts),
        title: Text('Show Ebook'),
        subtitle: Text('Show List All Ebook'),
        onTap: () {
          Navigator.pop(context);
          setState(() {
            currentWidget = ShowEbook();
          });
        },
      );

  ListTile buildListTileInformation() => ListTile(
        leading: Icon(Icons.info),
        title: Text('Information'),
        subtitle: Text('Show Information Logined'),
        onTap: () {
          Navigator.pop(context);
          setState(() {
            currentWidget = Informaion();
          });
        },
      );

  UserAccountsDrawerHeader buildUserAccountsDrawerHeader() {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/wall.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      accountName: Text(
        model == null ? '' : model.name,
        style: TextStyle(
          color: Colors.pink.shade700,
        ),
      ),
      accountEmail: Text(
        model == null ? '' : model.email,
        style: TextStyle(color: Colors.blue.shade700),
      ),
      currentAccountPicture: Image.asset('images/logo.png'),
    );
  }

  Widget buildSignOut(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ListTile(
          onTap: () async {
            await Firebase.initializeApp().then((value) async {
              await FirebaseAuth.instance
                  .signOut()
                  .then((value) => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Authen(),
                      ),
                      (route) => false));
            });
          },
          tileColor: Colors.red.shade700,
          leading: Icon(
            Icons.exit_to_app,
            color: Colors.white,
          ),
          title: Text(
            'Sing Out',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
