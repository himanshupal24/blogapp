// import 'package:blogapp/screens/option_screen.dart';
import 'package:blogapp/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDt87o5AkAsgwy2FsLXYobn_bubQKwoz2Y",
      authDomain: "blog-app-92375.firebaseapp.com",
      databaseURL: "https://blog-app-92375.firebaseio.com",
      projectId: "blog-app-92375",
      storageBucket: "blog-app-92375.appspot.com",
      messagingSenderId: "58869624903",
      appId: "1:58869624903:android:6f21ffd360d054c087c162",
      measurementId: "G-YV587XN7X2",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blog App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}
