// ignore_for_file: avoid_print

import 'package:assingment/sign_up.dart';
import 'package:assingment/task.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

TextEditingController email = TextEditingController();

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController password = TextEditingController();

    Future login() async {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email.text, password: password.text);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const Task()));
        password.clear();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
      }
    }

    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(children: [
            Container(
                padding: const EdgeInsets.fromLTRB(15.0, 110, 00, 0),
                child: const Text(
                  "Hello",
                  style: TextStyle(
                      fontSize: 80.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                )),
            Container(
                padding: const EdgeInsets.fromLTRB(16, 175, 00, 0),
                child: const Text(
                  "There",
                  style: TextStyle(
                      fontSize: 80.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                )),
            Container(
                padding: const EdgeInsets.fromLTRB(220.0, 175, 00, 0),
                child: const Text(
                  ".",
                  style: TextStyle(
                      fontSize: 80.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                )),
            Container(
                padding: const EdgeInsets.only(top: 335, left: 20, right: 20),
                child: Column(children: <Widget>[
                  TextFormField(
                    controller: email,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                        hintText: 'abd@gmail.com',
                        hintStyle: TextStyle(color: Colors.black),
                        labelText: 'Email',
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.green,
                          size: 25,
                        ),
                        labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.green,
                        ))),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: password,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.green,
                          size: 25,
                        ),
                        labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.green,
                        ))),
                    obscureText: true,
                  ),
                ])),
          ]),
          const SizedBox(
            height: 5,
          ),
          Container(
              alignment: const Alignment(1, 0),
              padding: const EdgeInsets.only(top: 15, left: 20),
              child: InkWell(
                onTap: () {},
                child: const Text(
                  'Forgot Password',
                  style: TextStyle(
                    color: Colors.green,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    decoration: TextDecoration.underline,
                  ),
                ),
              )),
          const SizedBox(
            height: 40,
          ),
          Material(
            borderRadius: BorderRadius.circular(20),
            shadowColor: Colors.greenAccent,
            color: Colors.green,
            elevation: 7.0,
            child: SizedBox(
              height: 40,
              child: TextButton(
                onPressed: () {
                  login();
                },
                child: const Center(
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Material(
            borderRadius: BorderRadius.circular(20),
            shadowColor: Colors.greenAccent,
            color: Colors.green,
            elevation: 7.0,
            child: SizedBox(
              height: 40,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => const SignUp()));
                },
                child: const Center(
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
