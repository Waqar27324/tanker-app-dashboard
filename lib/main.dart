import 'package:dashboard/globalVariables.dart';
import 'package:dashboard/pages/loginpage.dart';
import 'package:flutter/material.dart';
import 'pages/main_page.dart';

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'db2',
    options: Platform.isIOS
        ? const FirebaseOptions(
            googleAppID: '1:297855924061:ios:c6de2b69b03a5be8',
            gcmSenderID: '297855924061',
            databaseURL: 'https://flutterfire-cd2f7.firebaseio.com',
          )
        : const FirebaseOptions(
            googleAppID: '1:207159721562:android:be13415285dba6b64f6263',
            apiKey: '1:207159721562:android:be13415285dba6b64f6263',
            databaseURL: 'https://waterapp-7cf2d.firebaseio.com',
          ),
  );
  currentUser = await FirebaseAuth.instance.currentUser();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dashboard',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: (currentUser != null) ? MainPage() : LoginPage(),
    );
  }
}
