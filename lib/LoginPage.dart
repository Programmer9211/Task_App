import 'package:task_app/Firebase.dart';
import 'package:task_app/HomeScreen.dart';
import 'package:flutter/material.dart';

import 'Widget.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return auth.currentUser == null
        ? Scaffold(
            key: _scaffoldKey,
            body: Form(
                key: _formKey,
                child: Card(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          height: height / 4,
                          width: double.infinity,
                          alignment: Alignment.bottomCenter,
                          child: ClipOval(
                            child: Icon(
                              Icons.lock,
                              size: 70,
                              color: Color.fromRGBO(61, 50, 111, 1),
                            ),
                          ),
                        ),
                        Container(
                          height: height / 8,
                          width: double.infinity,
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            "   Login...",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w500,
                              color: Color.fromRGBO(61, 50, 111, 1),
                            ),
                          ),
                        ),
                        Container(
                          height: height / 12,
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: Text(
                            "   Sign in to continue",
                            style: TextStyle(
                              fontSize: 16,
                              color: Color.fromRGBO(61, 50, 111, 1),
                            ),
                          ),
                        ),
                        textField(_email, "Email", null),
                        textField(_password, "Password", null),
                        SizedBox(
                          height: height / 10,
                        ),
                        RaisedButton(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          color: Color.fromRGBO(61, 50, 111, 1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            " Login ",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    " Signing in Please Wait...",
                                  ),
                                  CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                  ),
                                ],
                              )));

                              signIn(_email.text.trim(), _password.text.trim(),
                                  context, _scaffoldKey);
                            }
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        GestureDetector(
                          onTap: () => Navigator.push(context,
                              MaterialPageRoute(builder: (_) => SignInPage())),
                          child: Text(
                            "New User? Create Account",
                            style: TextStyle(
                              fontSize: 18,
                              color: Color.fromRGBO(61, 50, 111, 1),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height / 7.7,
                        ),
                      ],
                    ),
                  ),
                )),
          )
        : HomeScreen();
  }
}

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      body: Form(
          key: _formKey,
          child: Card(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: height / 4,
                    width: double.infinity,
                    alignment: Alignment.bottomCenter,
                    child: ClipOval(
                      child: Icon(
                        Icons.lock,
                        size: 70,
                        color: Color.fromRGBO(61, 50, 111, 1),
                      ),
                    ),
                  ),
                  Container(
                    height: height / 8,
                    width: double.infinity,
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      "Create New Account...",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(61, 50, 111, 1),
                      ),
                    ),
                  ),
                  Container(
                    height: height / 12,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(
                      "Sign up to continue",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromRGBO(61, 50, 111, 1),
                      ),
                    ),
                  ),
                  textField(_name, "Full Name", 10),
                  textField(_email, "Email", null),
                  textField(_password, "Password", null),
                  SizedBox(
                    height: height / 18,
                  ),
                  RaisedButton(
                    color: Color.fromRGBO(61, 50, 111, 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      "SignUp",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        signUp(_email.text.trim(), _password.text.trim(),
                            _name.text.trim(), context);

                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                            duration: Duration(minutes: 1),
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text("Creating Account Please Wait..."),
                                CircularProgressIndicator()
                              ],
                            )));
                      }
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      "Already have an account? Sign in",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromRGBO(61, 50, 111, 1),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height / 10,
                  )
                ],
              ),
            ),
          )),
    );
  }
}
