import 'package:Twitter_Clone/signup.dart';
import 'package:Twitter_Clone/utils/variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var passwordcontroller = TextEditingController();
  var emailcontroller = TextEditingController();
  login() {
    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailcontroller.text, password: passwordcontroller.text);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome to flutter clone",
              style: mystyle(30, Colors.white, FontWeight.w600),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Login",
              style: mystyle(30, Colors.white, FontWeight.w600),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: 60,
              height: 60,
              child: Image.asset('images/logo.png'),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                controller: emailcontroller,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: "Email",
                  labelStyle: mystyle(15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                controller: passwordcontroller,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: "Password",
                  labelStyle: mystyle(15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () => login(),
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    "Login",
                    style: mystyle(20, Colors.black, FontWeight.w700),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Dont have account",
                  style: mystyle(20),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Signup(),
                    ),
                  ),
                  child: Text(
                    "Regster!",
                    style: mystyle(20, Colors.red, FontWeight.w700),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
