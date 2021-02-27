import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:ungfunny/states/my_service.dart';
import 'package:ungfunny/states/register.dart';
import 'package:ungfunny/utility/dialog.dart';

class Authen extends StatefulWidget {
  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  String email, password;
  double screen;
  bool normalScreen = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkStatus();
  }

  Future<Null> checkStatus() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) {
        if (event != null) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => MyService(),
              ),
              (route) => false);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    screen = MediaQuery.of(context).size.width;
    if (screen > 1000) {
      normalScreen = false;
    }
    print('screen = $screen');
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/wall.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: normalScreen ? 300 : screen - 200,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white54),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildContainerLogo(),
                  buildTextAppName(),
                  buildContainerUser(),
                  buildContainerPassword(),
                  // buildContainerLogin(),
                   progressButton(),
                  buildTextButton()
                 
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextButton buildTextButton() {
    return TextButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Register(),
            ));
      },
      child: Text('New Register'),
    );
  }

  Container buildContainerLogin() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: normalScreen ? 250 : 500,
      child: ElevatedButton(
        onPressed: () {
          checkSpace();
        },
        child: Text('Login'),
      ),
    );
  }

  Widget progressButton() {
    Map<ButtonState, Widget> stateWidgets = {
      ButtonState.idle: Text('Idel'),
      ButtonState.loading: Text('Loading'),
      ButtonState.fail: Text('Fail'),
      ButtonState.success: Text('Success'),
    };

    Map<ButtonState, Color> stateColors = {
      ButtonState.idle: Colors.red,
      ButtonState.loading: Colors.yellow,
      ButtonState.fail: Colors.blue,
      ButtonState.success: Colors.green,
    };

    return ProgressButton(
      stateWidgets: stateWidgets,
      stateColors: stateColors,state: ButtonState.idle,
      onPressed: () {},
    );
  }

  void checkSpace() {
    if (email == null ||
        email.isEmpty ||
        password == null ||
        password.isEmpty) {
      normalDialog(context, 'Have Space ? Please Fill Every Blank');
    } else {
      checkAuthen();
    }
  }

  Container buildContainerUser() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: normalScreen ? 250 : 500,
      child: TextField(
        onChanged: (value) => email = value.trim(),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'User :',
          prefixIcon: Icon(Icons.email),
        ),
      ),
    );
  }

  Container buildContainerPassword() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: normalScreen ? 250 : 500,
      child: TextField(
        onChanged: (value) => password = value.trim(),
        obscureText: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Password :',
          prefixIcon: Icon(Icons.lock),
        ),
      ),
    );
  }

  Container buildTextAppName() => Container(
        margin: EdgeInsets.only(top: 16),
        child: Text(
          'Ung Funny',
          style: TextStyle(
            fontSize: normalScreen ? 22 : 44,
            color: Colors.pink.shade900,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.italic,
          ),
        ),
      );

  Container buildContainerLogo() {
    return Container(
      width: normalScreen ? 120 : 240,
      child: Image.asset('images/logo.png'),
    );
  }

  Future<Null> checkAuthen() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => MyService(),
            ),
            (route) => false);
      }).catchError((value) {
        normalDialog(context, value.message);
      });
    });
  }
}
