import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Widget textField(TextEditingController controller, String text, int maxlength) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
    child: Theme(
      data: ThemeData(
        primaryColor: Color.fromRGBO(61, 50, 111, 1),
      ),
      child: TextFormField(
        controller: controller,
        maxLength: maxlength,
        decoration: InputDecoration(
            hintText: text,
            hintStyle: TextStyle(
                color: Color.fromRGBO(61, 50, 111, 1),
                fontSize: 18,
                fontWeight: FontWeight.w500)),
        validator: (val) {
          if (val.isEmpty || val == null) {
            return "Please Enter Correct Field";
          }
          return null;
        },
      ),
    ),
  );
}

DocumentSnapshot documentSnapshotleft;
DocumentSnapshot documentSnapshotcompleted;
DocumentSnapshot dstotaltasK;
DocumentSnapshot dstotaltaskdone;
