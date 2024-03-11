import 'dart:async';
import 'package:blogapp/screens/homescreen.dart';
import 'package:blogapp/screens/option_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _redirectToNextScreen();
  }

  void _redirectToNextScreen() {
    final user = auth.currentUser;
    Timer(
      Duration(seconds: 3),
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => user != null ? HomeScreen() : OptionScreen(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width * 0.3,
              image: AssetImage('images/logo.png'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Blog',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 40.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
