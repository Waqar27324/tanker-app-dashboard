import 'package:connectivity/connectivity.dart';
import 'package:dashboard/brand_colors.dart';
import 'package:dashboard/pages/main_page.dart';
import 'package:dashboard/pages/registrationpage.dart';
import 'package:dashboard/taxi_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/progress_indicator.dart';

class LoginPage extends StatefulWidget {
  static const String id = 'login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  FirebaseAuth auth = FirebaseAuth.instance;

  void showSnackBar(String title) {
    final snackbar = SnackBar(
      content: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15),
      ),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  void login() async {
    // code to show custom loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => ProgressDialog(
        'Logging You In',
      ),
    );

    // code to signin connection
    final FirebaseUser user = (await auth
            .signInWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    )
            .catchError((ex) {
      Navigator.pop(context);
      PlatformException pE = ex;
      showSnackBar(pE.message);
    }))
        .user;

    if (user != null) {
      DatabaseReference newuserRef =
          FirebaseDatabase.instance.reference().child('managers/${user.uid}');

      newuserRef.once().then((DataSnapshot snapshot) {
        if (snapshot != null) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MainPage(),
              ));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
              image: AssetImage("images/loginfour.jpg"), fit: BoxFit.cover)),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 70,
                  ),
                  Image(
                    alignment: Alignment.center,
                    width: 150.0,
                    height: 100.0,
                    image: AssetImage('images/logostwo.png'),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    'Sign in as a Manager',
                    style: TextStyle(fontSize: 25, fontFamily: 'Brand-Bold'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(23.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Enter your email',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 10.0),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Enter your password',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 10.0),
                          ),
                        ),
                        SizedBox(
                          height: 140,
                        ),
                        TaxiButton(
                          title: 'LOGIN',
                          color: BrandColors.colorGreen,
                          onPressed: () async {
                            var connRes =
                                await Connectivity().checkConnectivity();

                            if (connRes != ConnectivityResult.mobile &&
                                connRes != ConnectivityResult.wifi) {
                              showSnackBar(
                                  'Please check your connection and try again');
                              return;
                            }

                            if (!emailController.text.contains('@')) {
                              showSnackBar('Please provide a valid email');
                              return;
                            }
                            if (passwordController.text.length < 8) {
                              showSnackBar(
                                  'Please enter atleast 8 digits password ');
                              return;
                            }
                            login();
                          },
                        ),
                      ],
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegistrationPage(),
                          ));
                    },
                    child: Text(
                      'Don\'t have an account, sign up here',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
