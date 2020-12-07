import 'package:flutter/material.dart';
import 'package:task_app/Firebase.dart';

class Dialoges extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        "Signout",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      ),
      content: Text(
        "Do you really want to sign out",
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
      ),
      actions: [
        FlatButton(
          child: Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        ),
        FlatButton(
          child: Text("OK"),
          onPressed: () => signout(context),
        ),
      ],
    );
  }
}
