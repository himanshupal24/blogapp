import 'package:blogapp/components/round_button.dart';
import 'package:blogapp/screens/login.dart';
import 'package:blogapp/screens/signin.dart';
import 'package:flutter/material.dart';

class OptionScreen extends StatefulWidget {
  const OptionScreen({Key? key}) : super(key: key);

  @override
  State<OptionScreen> createState() => _OptionScreenState();
}

class _OptionScreenState extends State<OptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image(image: AssetImage("images/user.png")),
              SizedBox(height: 30),
              RoundButton(
                title: "Log In",
                onPress: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LogIn()));
                },
              ),
              const SizedBox(height: 20.0),
              RoundButton(
                title: "Register",
                onPress: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignIn()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
