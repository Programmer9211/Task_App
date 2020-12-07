import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'Firebase.dart';

// ignore: must_be_immutable
class CreateTask extends StatefulWidget {
  bool isupdate;
  DocumentSnapshot ds;
  String collection;

  CreateTask(this.isupdate, this.ds, this.collection);

  @override
  _CreateTaskState createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeydes = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    title.dispose();
    description.dispose();
  }

  DateTime dateNow = DateTime.now();
  TimeOfDay timeNow = TimeOfDay.now();
  TimeOfDay timeNow1 = TimeOfDay.now();
  TimeOfDay time = TimeOfDay.now();

  selectTime(bool isfirst) async {
    final picked = await showTimePicker(context: context, initialTime: timeNow);

    if (picked != null && picked != timeNow)
      setState(() {
        if (isfirst == true) {
          timeNow = picked;
        } else {
          timeNow1 = picked;
        }
      });
  }

  selectDate() async {
    final picked = await showDatePicker(
        context: context,
        initialDate: dateNow,
        firstDate: DateTime(2020),
        lastDate: DateTime(2050));

    if (picked != null && picked != dateNow)
      setState(() {
        dateNow = picked;
      });
  }

  void addTask() {
    if (_formKey.currentState.validate() &&
        _formKeydes.currentState.validate()) {
      if (timeNow == timeNow1) {
        _scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text('Time Not be Same')));
      } else if (timeNow.minute > timeNow1.minute &&
          timeNow.hour > timeNow1.hour) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text('End time Mustt Be Greator than Starting time')));
      } else {
        if (widget.isupdate == false) {
          taskcollection
              .doc(auth.currentUser.uid)
              .collection(widget.collection)
              .add({
            'task': title.text,
            'time': DateTime.now(),
            'des': description.text,
            'date': dateNow.toString().split(' ')[0],
            'hour': timeNow.hour,
            'min': timeNow.minute,
            'hours': timeNow1.hour,
            "mins": timeNow1.minute,
            'inittime': timeNow.format(context),
            'endtime': timeNow1.format(context),
            'timeNow': time.format(context),
            'isDone': false,
            'color': 0xFFE53935,
            'status': "Pending"
          });

          taskcollection
              .doc(auth.currentUser.uid)
              .collection(widget.collection)
              .doc(auth.currentUser.displayName)
              .collection('todoleft')
              .add({'isDone': false});

          taskcollection
              .doc(auth.currentUser.uid)
              .collection('totaltask')
              .add({'done': true});
        } else if (widget.isupdate == true) {
          taskcollection
              .doc(auth.currentUser.uid)
              .collection(widget.collection)
              .doc(widget.ds.id)
              .update({
            'task': title.text,
            'time': DateTime.now(),
            'des': description.text,
            'date': dateNow.toString().split(' ')[0],
            'hour': timeNow.hour,
            'min': timeNow.minute,
            'inittime': timeNow.format(context),
            'endtime': timeNow1.format(context),
            'timeNow': time.format(context),
          });
        }

        Navigator.pop(context);
      }

      print("Added");
    }

    print("Error");
  }

  Widget forms(
      String name, TextEditingController controller, Key key, Color color) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Form(
      key: key,
      child: Container(
        alignment: Alignment.bottomCenter,
        height: height / 10,
        width: width / 1.13,
        child: Theme(
          data: ThemeData(
            primaryColor: color,
            primaryColorDark: color,
          ),
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
                hintText: name,
                hintStyle: TextStyle(color: color, fontSize: 22)),
            style: TextStyle(color: color, fontSize: 18),
            validator: (val) {
              if (val.isEmpty || val == null) {
                return color == Colors.white
                    ? "Title not be empty"
                    : "Description not be empty";
              }
              return null;
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color.fromRGBO(47, 103, 214, 1),
      body: Container(
        child: SingleChildScrollView(
            child: Column(
          children: [
            SizedBox(height: height / 10),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.isupdate == false
                        ? "   Create New Task"
                        : "   Update Task",
                    style: TextStyle(
                        fontSize: 27,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                  IconButton(
                      color: Colors.white,
                      tooltip: "Close",
                      icon: Icon(
                        Icons.clear,
                        color: Colors.white,
                        size: 27,
                      ),
                      onPressed: () => Navigator.pop(context))
                ],
              ),
            ),
            SizedBox(
              height: height / 24,
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                '     Title',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            ),
            forms("Enter Title Here", title, _formKey, Colors.white),
            SizedBox(
              height: height / 20,
            ),
            Container(
              height: height / 18,
              alignment: Alignment.topLeft,
              child: Text(
                '     Date',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              height: height / 10,
              width: width / 1.13,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "$dateNow".split(' ')[0],
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.date_range,
                            color: Colors.white,
                          ),
                          onPressed: () => selectDate())
                    ],
                  ),
                  Divider(
                    thickness: 2,
                    color: Colors.white,
                  )
                ],
              ),
            ),
            SizedBox(
              height: height / 27,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              height: height / 2.4,
              width: width / 1.05,
              child: Column(
                children: [
                  SizedBox(
                    height: height / 30,
                  ),
                  Container(
                    height: height / 22,
                    alignment: Alignment.topLeft,
                    child: Text(
                      '   Time',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    height: height / 10,
                    width: width / 1.13,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => selectTime(true),
                              child: Text(
                                "${timeNow.format(context)}  to  ",
                                style: TextStyle(fontSize: 22),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => selectTime(false),
                              child: Text(
                                "${timeNow1.format(context)}",
                                style: TextStyle(fontSize: 22),
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.black,
                          thickness: 2,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: height / 35,
                    alignment: Alignment.topLeft,
                    child: Text(
                      '   Description',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  forms("Description", description, _formKeydes, Colors.black),
                  RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      color: Color.fromRGBO(47, 103, 214, 1),
                      child: Text(
                        "Create Task",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      onPressed: addTask),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }
}
