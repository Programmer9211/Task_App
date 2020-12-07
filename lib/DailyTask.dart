import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_app/CreateTask.dart';
import 'package:task_app/Widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Notifications.dart';

import 'Firebase.dart';

// ignore: must_be_immutable
class DailyTask extends StatefulWidget {
  String title, collection;

  DailyTask({this.title, this.collection});

  @override
  _DailyTaskState createState() => _DailyTaskState();
}

class _DailyTaskState extends State<DailyTask> {
  List<DateAndTime> dayDate;
  List<String> months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "July",
    "Aug",
    "Sept",
    "Oct",
    "Nov",
    "Dec"
  ];

  final date = DateTime.now();

  @override
  void initState() {
    super.initState();
    dayDate = initList();
    NotificationsPlugin.notificationsPlugins.init(context);
  }

  List<DateAndTime> initList() {
    List<DateAndTime> initDateDay = List<DateAndTime>();

    for (int i = -2; i <= 3; i++) {
      initDateDay.add(DateAndTime(
          DateFormat('EE').format(DateTime.now().add(Duration(days: i))),
          DateTime.now().add(Duration(days: i)).day.toString(),
          Colors.blue[900]));
    }

    return initDateDay;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: size.height / 15,
          ),
          Container(
            alignment: Alignment.centerLeft,
            width: size.width / 1.05,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: size.width / 1.8,
                  child: Text(
                    widget.title,
                    style: TextStyle(
                        fontSize: size.width / 15, fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  width: size.width / 2.6,
                  height: size.height / 18,
                  alignment: Alignment.center,
                  child: RaisedButton(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: Colors.blue[900], width: 2)),
                      child: Text(
                        "Create New Task",
                        style: TextStyle(
                            fontSize: size.width / 26,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue[900]),
                      ),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  CreateTask(false, null, widget.collection)))),
                )
              ],
            ),
          ),
          Container(
            height: size.height / 15,
            width: size.width / 1.05,
            alignment: Alignment.centerLeft,
            child: Text(
              "${months[date.month - 1]}, ${date.year}",
              style: TextStyle(
                  fontSize: size.width / 20, fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            height: size.height / 7,
            width: size.width,
            alignment: Alignment.bottomCenter,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return DateTile(
                    position: index,
                    daydate: dayDate,
                  );
                }),
          ),
          Container(
            height: size.height / 19,
            width: size.width / 1.05,
            alignment: Alignment.centerLeft,
            child: Text(
              "Upcoming Tasks",
              style: TextStyle(
                  fontSize: size.width / 17, fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            height: size.height / 1.7,
            width: size.width,
            child: StreamBuilder<QuerySnapshot>(
                stream: taskcollection
                    .doc(auth.currentUser.uid)
                    .collection(widget.collection)
                    .orderBy('inittime')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.docs.length != 0 &&
                        snapshot.data.docs != null) {
                      return ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot ds = snapshot.data.docs[index];

                            NotificationsPlugin.notificationsPlugins
                                .showNotificationSchedule(
                                    ds, snapshot.data.docs.length);

                            NotificationsPlugin.notificationsPlugins
                                .showNotificationScheduleEnd(
                                    ds, snapshot.data.docs.length);

                            return ShowTask(
                              ds: ds,
                              collection: widget.collection,
                              //timeNow: ds['timeNow'],
                            );
                          });
                    } else {
                      return Container(
                          height: size.height / 8,
                          width: size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  height: size.height / 7,
                                  width: size.width / 2.9,
                                  child: Image.asset("asset/e.png")),
                              Container(
                                  height: size.height / 15,
                                  alignment: Alignment.bottomCenter,
                                  child: Text(
                                    "  Add Task",
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w500),
                                  )),
                            ],
                          ));
                    }
                  } else {
                    return Container(
                      height: 50,
                      width: double.infinity,
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class DateTile extends StatelessWidget {
  int position;
  List<DateAndTime> daydate;

  DateTile({this.position, this.daydate});

  final date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
      child: GestureDetector(
        onTap: () {
          var da = date.weekday;
          print(position);
          print(da);
        },
        child: Container(
          height: size.height / 11,
          width: size.width / 6.3,
          decoration: BoxDecoration(
              color: daydate[position].date == date.day.toString()
                  ? Colors.blue[900]
                  : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 2.0, color: Colors.blue[900])),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                daydate[position].day,
                style: TextStyle(
                    fontSize: size.width / 22.5,
                    color: daydate[position].date == date.day.toString()
                        ? Colors.white
                        : Colors.blue[900]),
              ),
              Text(
                daydate[position].date,
                style: TextStyle(
                    fontSize: size.width / 19,
                    fontWeight: FontWeight.w600,
                    color: daydate[position].date == date.day.toString()
                        ? Colors.white
                        : Colors.black),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ShowTask extends StatelessWidget {
  DocumentSnapshot ds;
  String collection;

  ShowTask({this.ds, @required this.collection});

  void value2() {
    taskcollection
        .doc(auth.currentUser.uid)
        .collection(collection)
        .doc(ds.id)
        .delete();

    taskcollection
        .doc(auth.currentUser.uid)
        .collection('totaltask')
        .doc(dstotaltasK.id)
        .delete();

    if (ds['isDone'] == false) {
      taskcollection
          .doc(auth.currentUser.uid)
          .collection(collection)
          .doc(auth.currentUser.displayName)
          .collection('todoleft')
          .doc(documentSnapshotleft.id)
          .delete();
    } else if (ds['isDone'] == true) {
      taskcollection
          .doc(auth.currentUser.uid)
          .collection(collection)
          .doc(auth.currentUser.displayName)
          .collection('todocomplete')
          .doc(documentSnapshotcompleted.id)
          .delete();

      taskcollection
          .doc(auth.currentUser.uid)
          .collection('totaltaskdone')
          .doc(dstotaltaskdone.id)
          .delete();

      taskcollection
          .doc(auth.currentUser.uid)
          .collection('totaltask')
          .doc(dstotaltasK.id)
          .delete();
    }
  }

  void value3() {
    if (ds['isDone'] == false) {
      taskcollection
          .doc(auth.currentUser.uid)
          .collection(collection)
          .doc(auth.currentUser.displayName)
          .collection('todocomplete')
          .add({"isDone": false});

      taskcollection
          .doc(auth.currentUser.uid)
          .collection('totaltaskdone')
          .add({"done": true});

      taskcollection
          .doc(auth.currentUser.uid)
          .collection(collection)
          .doc(auth.currentUser.displayName)
          .collection('todoleft')
          .doc(documentSnapshotleft.id)
          .delete();

      taskcollection
          .doc(auth.currentUser.uid)
          .collection(collection)
          .doc(ds.id)
          .update({'isDone': true, 'color': 0xFF4CAF50, 'status': "Completed"});
    } else if (ds['isDone'] == true) {
      taskcollection
          .doc(auth.currentUser.uid)
          .collection(collection)
          .doc(auth.currentUser.displayName)
          .collection('todoleft')
          .add({"isDone": true});

      taskcollection
          .doc(auth.currentUser.uid)
          .collection(collection)
          .doc(auth.currentUser.displayName)
          .collection('todocomplete')
          .doc(documentSnapshotcompleted.id)
          .delete();

      taskcollection
          .doc(auth.currentUser.uid)
          .collection('totaltaskdone')
          .doc(dstotaltaskdone.id)
          .delete();

      taskcollection
          .doc(auth.currentUser.uid)
          .collection(collection)
          .doc(ds.id)
          .update({'isDone': false, 'color': 0xFFE53935, 'status': "Pending"});
    }
  }

  void onTap(value, BuildContext context) {
    if (value == 1) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => CreateTask(true, ds, collection)));
    } else if (value == 2) {
      value2();
    } else if (value == 3) {
      value3();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        height: size.height / 4,
        width: size.width,
        child: Row(
          children: [
            Container(
              height: size.height / 5,
              width: size.width / 4.8,
              alignment: Alignment.topCenter,
              child: Container(
                height: size.height / 18,
                width: size.width / 4.8,
                alignment: Alignment.center,
                child: Text(
                  ds['timeNow'],
                  style: TextStyle(
                      fontSize: size.width / 28, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              height: size.height / 4,
              width: size.width / 1.32,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(width: 2.0, color: Color(ds['color']))),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    height: size.height / 18,
                    child: Row(
                      children: [
                        SizedBox(
                          width: size.width / 30,
                        ),
                        Container(
                          height: size.height / 45,
                          width: size.width / 18,
                          decoration: BoxDecoration(
                              color: Color(ds['color']),
                              shape: BoxShape.circle),
                        ),
                        SizedBox(
                          width: size.width / 1.9,
                          child: Text(
                            "   ${ds['inittime']} - ${ds['endtime']}",
                            style: TextStyle(
                                fontSize: size.width / 30,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        PopupMenuButton(
                            onSelected: (value) {
                              onTap(value, context);
                            },
                            itemBuilder: (context) => [
                                  PopupMenuItem(
                                      value: 1,
                                      child: Text(
                                        "Update",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      )),
                                  PopupMenuItem(
                                      value: 2,
                                      child: Text("Delete",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500))),
                                  PopupMenuItem(
                                      value: 3,
                                      child: Text(
                                          ds['isDone'] == true
                                              ? "Mark as Pending"
                                              : "Mark as Done",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500)))
                                ])
                      ],
                    ),
                  ),
                  Container(
                      alignment: Alignment.topLeft,
                      height: size.width / 12.5,
                      child: Text(
                        "    ${ds['task']}",
                        style: TextStyle(
                            fontSize: size.width / 20,
                            fontWeight: FontWeight.w500),
                      )),
                  Container(
                    alignment: Alignment.topLeft,
                    height: size.height / 15.5,
                    child: Text(
                      "      ${ds['des']}",
                      style: TextStyle(
                          fontSize: size.width / 26,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Divider(
                    thickness: 2,
                    color: Color(ds['color']),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    height: size.height / 25,
                    child: Row(
                      children: [
                        SizedBox(
                          width: size.width / 20,
                        ),
                        Text(
                          "Status :",
                          style: TextStyle(
                              fontSize: size.width / 26,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          " ${ds['status']}   ",
                          style: TextStyle(
                              fontSize: size.width / 26,
                              fontWeight: FontWeight.w500),
                        ),
                        Container(
                          height: size.height / 45,
                          width: size.width / 20,
                          decoration: BoxDecoration(
                              color: Color(ds['color']),
                              shape: BoxShape.circle),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DateAndTime {
  String day;
  String date;
  Color color;

  DateAndTime(this.day, this.date, this.color);
}
