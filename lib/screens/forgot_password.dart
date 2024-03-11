import 'package:blogapp/components/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  TextEditingController emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String email = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (String value) {
                        setState(() {
                          email = value;
                        });
                      },
                      validator: (value) {
                        return value!.isEmpty ? 'Enter email' : null;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: RoundButton(
                        title: 'Recover Password',
                        onPress: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              showSpinner = true;
                            });
                            try {
                              await _auth.sendPasswordResetEmail(
                                email: emailController.text.toString(),
                              );
                              setState(() {
                                showSpinner = false;
                              });
                              toastMessage(
                                  'Please check your email, a reset link has been sent to you via email');
                            } catch (e) {
                              print(e);
                              toastMessage(e.toString());
                              setState(() {
                                showSpinner = false;
                              });
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void toastMessage(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.red,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
