import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:blogapp/components/round_button.dart';
import 'package:blogapp/screens/forgot_password.dart';
import 'package:blogapp/screens/homescreen.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Login',
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
            ),
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
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: TextFormField(
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (String value) {
                          setState(() {
                            password = value;
                          });
                        },
                        validator: (value) {
                          return value!.isEmpty ? 'Enter password' : null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 30),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForgotPasswordScreen(),
                            ),
                          );
                        },
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text('Forgot Password?'),
                        ),
                      ),
                    ),
                    RoundButton(
                      title: 'Login',
                      onPress: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            showSpinner = true;
                          });
                          try {
                            final userCredential =
                                await _auth.signInWithEmailAndPassword(
                              email: email.trim(),
                              password: password.trim(),
                            );
                            if (userCredential.user != null) {
                              print('Success');
                              toastMessage("Success");
                              setState(() {
                                showSpinner = false;
                              });
                              // If the login is successful, navigate to the home screen.
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomeScreen(),
                                ),
                              );
                            }
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
