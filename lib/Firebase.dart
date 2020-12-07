import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_app/HomeScreen.dart';
import 'package:task_app/LoginPage.dart';
import 'package:flutter/material.dart';

FirebaseAuth auth = FirebaseAuth.instance;
final taskcollection = FirebaseFirestore.instance.collection('tasks');

void signIn(String email, String password, BuildContext context,
    GlobalKey<ScaffoldState> _scaffoldkey) async {
  try {
    final User user = (await auth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;

    if (user != null) {
      if (!user.emailVerified) {
        await user.sendEmailVerification();
      }

      print("${auth.currentUser.providerData}\n");
    }

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => HomeScreen()));
  } catch (e) {
    switch (e.message) {
      case 'There is no user record corresponding to this identifier. The user may have been deleted.':
        _scaffoldkey.currentState.showSnackBar(
            SnackBar(content: Text("No User Found Please Create Account")));
        break;
      case 'The password is invalid or the user does not have a password.':
        _scaffoldkey.currentState
            .showSnackBar(SnackBar(content: Text("Invalid email or password")));
        break;
      case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
        _scaffoldkey.currentState.showSnackBar(
            SnackBar(content: Text("Check your internet connection")));
        break;
      // ...
      default:
        _scaffoldkey.currentState
            .showSnackBar(SnackBar(content: Text("Unexpected error occured")));
    }
  }
}

void signUp(String email, String password, String userName,
    BuildContext context) async {
  final User user = (await auth.createUserWithEmailAndPassword(
          email: email, password: password))
      .user;

  if (user != null) {
    if (!user.emailVerified) {
      await user.sendEmailVerification();
    }

    await user.updateProfile(displayName: userName);

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => HomeScreen()));
  }
}

void signout(BuildContext context) async {
  await auth.signOut();
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (_) => LoginPage()));
}
