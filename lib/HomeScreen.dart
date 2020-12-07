import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_app/DailyTask.dart';
import 'package:task_app/Drawer.dart';
import 'package:task_app/Firebase.dart';
import 'package:task_app/Notifications.dart';
import 'package:task_app/Widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({
    Key key,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scafoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    NotificationsPlugin.notificationsPlugins.init(context);
  }

  Widget mess(double width, String title) {
    return Text("  $title",
        style: TextStyle(
            color: Colors.blue[900],
            fontSize: width / 17,
            fontWeight: FontWeight.w500));
  }

  Widget mess1(double width, String title) {
    return Text("$title",
        style: TextStyle(
            color: Colors.blue[900],
            fontSize: width / 22,
            fontWeight: FontWeight.w500));
  }

  Widget tasks(double width) {
    return Row(
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: taskcollection
              .doc(auth.currentUser.uid)
              .collection('totaltask')
              .snapshots(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.data != null) {
              if (snapshot.data.docs.length != 0 &&
                  snapshot.data.docs != null) {
                dstotaltasK = snapshot.data.docs.last;
                return Text("   ${snapshot.data.docs.length} out of ",
                    style: TextStyle(
                      color: Colors.purple,
                      fontSize: width / 27,
                    ));
              } else {
                return Text("   0 out of ",
                    style: TextStyle(
                      color: Colors.purple,
                      fontSize: width / 27,
                    ));
              }
            } else {
              return Text("   0 out of ",
                  style: TextStyle(
                    color: Colors.purple,
                    fontSize: width / 27,
                  ));
            }
          },
        ),
        StreamBuilder<QuerySnapshot>(
          stream: taskcollection
              .doc(auth.currentUser.uid)
              .collection('totaltaskdone')
              .snapshots(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.data != null) {
              if (snapshot.data.docs.length != 0 &&
                  snapshot.data.docs != null) {
                dstotaltaskdone = snapshot.data.docs.last;

                return Text("${snapshot.data.docs.length} Task completed",
                    style: TextStyle(
                      color: Colors.purple,
                      fontSize: width / 27,
                    ));
              } else {
                return Text("0 Task completed",
                    style: TextStyle(
                      color: Colors.purple,
                      fontSize: width / 27,
                    ));
              }
            } else {
              return Text("0 Task completed",
                  style: TextStyle(
                    color: Colors.purple,
                    fontSize: width / 27,
                  ));
            }
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      endDrawer: DRAWER(),
      key: _scafoldKey,
      body: Column(
        children: [
          SizedBox(
            height: height / 14,
          ),
          Container(
            height: height / 10,
            alignment: Alignment.centerLeft,
            width: width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: width / 1.25,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "   Hey, ${auth.currentUser.displayName}",
                    style: TextStyle(
                        fontSize: width / 15, fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  height: height / 10,
                  width: width / 5.5,
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                      icon: Icon(
                        Icons.more_horiz,
                        size: width / 11,
                      ),
                      onPressed: () =>
                          _scafoldKey.currentState.openEndDrawer()),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            child: Text(
              "    Let's make this day productive...",
              style: TextStyle(fontSize: width / 22, color: Colors.grey),
            ),
          ),
          SizedBox(
            height: height / 30,
          ),
          Material(
            borderRadius: BorderRadius.circular(15),
            color: Color.fromRGBO(252, 238, 243, 1),
            elevation: 5,
            child: Container(
              height: height / 3.5,
              width: MediaQuery.of(context).size.width / 1.1,
              child: Row(
                children: [
                  Container(
                    height: height / 3.5,
                    width: MediaQuery.of(context).size.width / 1.8,
                    child: Column(
                      children: [
                        SizedBox(
                          height: height / 34,
                        ),
                        Container(
                            width: double.infinity,
                            alignment: Alignment.centerLeft,
                            child: StreamBuilder<QuerySnapshot>(
                              stream: taskcollection
                                  .doc(auth.currentUser.uid)
                                  .collection('totaltask')
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshots) {
                                return StreamBuilder<QuerySnapshot>(
                                    stream: taskcollection
                                        .doc(auth.currentUser.uid)
                                        .collection('totaltaskdone')
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.data != null) {
                                        if (snapshot.data.docs.length != 0 &&
                                            snapshot.data.docs != null) {
                                          int percent = 0;
                                          percent = (snapshot.data.docs.length *
                                                          100) ~/
                                                      snapshots
                                                          .data.docs.length ==
                                                  0
                                              ? 1
                                              : snapshot.data.docs.length;

                                          return Column(
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                child:
                                                    Builder(builder: (context) {
                                                  if (percent == 100) {
                                                    return mess(width,
                                                        "Congratulatons !");
                                                  } else if (percent >= 75) {
                                                    return mess(
                                                        width, "Hurrah !");
                                                  } else if (percent >= 50) {
                                                    return mess(
                                                        width, "Keep doing");
                                                  } else if (percent >= 25) {
                                                    return mess(
                                                        width, "Keep it up");
                                                  } else {
                                                    return mess(
                                                        width, "Let's Start");
                                                  }
                                                }),
                                              ),
                                              SizedBox(
                                                height: height / 90,
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2,
                                                alignment: Alignment.centerLeft,
                                                child:
                                                    Builder(builder: (context) {
                                                  if (percent == 100) {
                                                    return mess1(width,
                                                        "You have completed all taskes");
                                                  } else if (percent >= 75) {
                                                    return mess1(width,
                                                        "You are almost there");
                                                  } else if (percent >= 50) {
                                                    return mess1(width,
                                                        "You have completed half of tasks");
                                                  } else if (percent >= 25) {
                                                    return mess1(width,
                                                        "You have to work hard");
                                                  } else {
                                                    return mess1(width,
                                                        "lets's complete taskes");
                                                  }
                                                }),
                                              ),
                                            ],
                                          );
                                        } else {
                                          return Column(
                                            children: [
                                              Text(
                                                  snapshots.data.docs.length !=
                                                          0
                                                      ? "   Let's Start"
                                                      : "   Add Task !!",
                                                  style: TextStyle(
                                                      color: Colors.blue[900],
                                                      fontSize: width / 17,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                              SizedBox(
                                                height: height / 30,
                                              ),
                                              Text(
                                                  snapshots.data.docs.length !=
                                                          0
                                                      ? "   let's completed taskes"
                                                      : "  Create a task to see stats",
                                                  style: TextStyle(
                                                      color: Colors.blue[900],
                                                      fontSize: width / 22,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ],
                                          );
                                        }
                                      } else {
                                        return Column(
                                          children: [
                                            Text(
                                                snapshots.data.docs.length != 0
                                                    ? "   Let's Start"
                                                    : "   Add Task !!",
                                                style: TextStyle(
                                                    color: Colors.blue[900],
                                                    fontSize: width / 17,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                            Text(
                                                snapshots.data.docs.length != 0
                                                    ? "   let's completed taskes"
                                                    : "  Create a task to see stats",
                                                style: TextStyle(
                                                    color: Colors.blue[900],
                                                    fontSize: width / 22,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ],
                                        );
                                      }
                                    });
                              },
                            )),
                        SizedBox(height: height / 19),
                        Container(
                          height: height / 12,
                          width: width / 1.9,
                          alignment: Alignment.centerLeft,
                          child: tasks(width),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      height: height / 3.3,
                      width: width / 2.85,
                      child: StreamBuilder<QuerySnapshot>(
                          stream: taskcollection
                              .doc(auth.currentUser.uid)
                              .collection('totaltask')
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> s) {
                            return StreamBuilder<QuerySnapshot>(
                              stream: taskcollection
                                  .doc(auth.currentUser.uid)
                                  .collection('totaltaskdone')
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.data != null) {
                                  if (snapshot.data.docs.length != 0 &&
                                      snapshot.data.docs != null) {
                                    int percent = 0;

                                    percent =
                                        (snapshot.data.docs.length * 100) ~/
                                                    s.data.docs.length ==
                                                0
                                            ? 1
                                            : s.data.docs.length;

                                    return Container(
                                      child: Builder(builder: (context) {
                                        if (percent == 100) {
                                          return Image.asset(
                                              "asset/astronaut.png");
                                        } else if (percent >= 75) {
                                          return Image.asset(
                                              "asset/rocket.png");
                                        } else if (percent >= 50) {
                                          return Image.asset(
                                              "asset/dashboard.png");
                                        } else if (percent >= 25) {
                                          return Image.asset("asset/thumb.png");
                                        } else {
                                          return Image.asset("asset/s.png");
                                        }
                                      }),
                                    );
                                  } else {
                                    return Container(
                                      child: Image.asset(s.data.docs.length != 0
                                          ? "asset/s.png"
                                          : "asset/e.png"),
                                    );
                                  }
                                } else {
                                  return Container(
                                    child: Image.asset("asset/e.png"),
                                  );
                                }
                              },
                            );
                          }))
                ],
              ),
            ),
          ),
          Container(
            height: height / 15,
            alignment: Alignment.bottomLeft,
            width: width,
            child: Text(
              '   Daliy Progress',
              style:
                  TextStyle(fontSize: width / 16, fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            height: height / 2.5,
            width: width,
            child: GridView.count(
              crossAxisCount: 2,
              children: [
                DaliyProgress(
                  name: "Personal",
                  collection: "task",
                ),
                DaliyProgress(
                  name: "Work",
                  collection: "task1",
                ),
                DaliyProgress(
                  name: "Health",
                  collection: "task2",
                ),
                DaliyProgress(
                  name: "Social",
                  collection: "task3",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class DaliyProgress extends StatelessWidget {
  String name, collection;
  int percent;

  DaliyProgress({this.name, this.collection, this.percent});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => DailyTask(
                      title: name,
                      collection: collection,
                    )));
      },
      child: Container(
        height: height / 8,
        width: width / 3,
        alignment: Alignment.center,
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          child: Container(
            height: height / 4.5,
            width: width / 2.4,
            child: Column(
              children: [
                Container(
                  height: height / 20,
                  width: width / 1.2,
                  alignment: Alignment.bottomCenter,
                  child: Row(children: [
                    StreamBuilder<QuerySnapshot>(
                        stream: taskcollection
                            .doc(auth.currentUser.uid)
                            .collection(collection)
                            .snapshots(),
                        builder:
                            (BuildContext c, AsyncSnapshot<QuerySnapshot> s) {
                          return StreamBuilder<QuerySnapshot>(
                              stream: taskcollection
                                  .doc(auth.currentUser.uid)
                                  .collection(collection)
                                  .doc(auth.currentUser.displayName)
                                  .collection('todocomplete')
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.data != null) {
                                  if (snapshot.data.docs.length != 0 &&
                                      snapshot.data.docs != null) {
                                    int percent = 0;

                                    percent =
                                        (snapshot.data.docs.length * 100) ~/
                                            (s.data.docs.length == 0
                                                ? 1
                                                : s.data.docs.length);

                                    print(percent);

                                    return Text(
                                      "  $percent%",
                                      style: TextStyle(
                                          fontSize: width / 22,
                                          color: Colors.blue),
                                    );
                                  } else {
                                    return Text("   0%",
                                        style: TextStyle(
                                            fontSize: width / 22,
                                            color: Colors.blue));
                                  }
                                } else {
                                  return Text("   0%",
                                      style: TextStyle(
                                          fontSize: width / 22,
                                          color: Colors.blue));
                                }
                              });
                        }),
                    SizedBox(
                      width: width / 4.5,
                    ),
                    Container(
                      height: height / 45,
                      width: width / 18,
                      decoration: BoxDecoration(
                          color: Colors.blue, shape: BoxShape.circle),
                    ),
                  ]),
                ),
                Container(
                  height: height / 18,
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "   $name",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                    alignment: Alignment.center,
                    width: width / 2,
                    height: height / 18,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: taskcollection
                          .doc(auth.currentUser.uid)
                          .collection(collection)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data.docs.length != 0) {
                            return Text("${snapshot.data.docs.length} Task");
                          } else {
                            return Text(" 0 Task");
                          }
                        } else if (snapshot.hasError) {
                          return Text(" 0 Task");
                        } else {
                          return Text("0 Task");
                        }
                      },
                    )),
                Container(
                  height: height / 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: height / 30,
                        width: width / 5,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.blue[100],
                        ),
                        child: StreamBuilder<QuerySnapshot>(
                            stream: taskcollection
                                .doc(auth.currentUser.uid)
                                .collection(collection)
                                .doc(auth.currentUser.displayName)
                                .collection('todocomplete')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data.docs.length != 0) {
                                  return ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: 1,
                                      itemBuilder: (context, index) {
                                        documentSnapshotcompleted =
                                            snapshot.data.docs[index];

                                        return Container(
                                          height: height / 30,
                                          width: width / 5,
                                          alignment: Alignment.center,
                                          child: Text(
                                            "${snapshot.data.docs.length} Complete",
                                            style: TextStyle(
                                                color: Colors.blue[900]),
                                          ),
                                        );
                                      });
                                } else {
                                  return Text(" 0 Completed ",
                                      style: TextStyle(
                                          fontSize: width / 32,
                                          color: Colors.blue[900]));
                                }
                              } else if (snapshot.hasError) {
                                return Text(" 0 completed ",
                                    style: TextStyle(
                                        color: Colors.blue[900],
                                        fontSize: width / 32));
                              } else {
                                return Text(" 0 Completed ",
                                    style: TextStyle(
                                        fontSize: width / 32,
                                        color: Colors.blue[900]));
                              }
                            }),
                      ),
                      Container(
                          height: height / 30,
                          width: width / 7,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.red[100],
                          ),
                          child: StreamBuilder<QuerySnapshot>(
                              stream: taskcollection
                                  .doc(auth.currentUser.uid)
                                  .collection(collection)
                                  .doc(auth.currentUser.displayName)
                                  .collection('todoleft')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  if (snapshot.data.docs.length != 0) {
                                    return ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: 1,
                                        itemBuilder: (context, index) {
                                          documentSnapshotleft =
                                              snapshot.data.docs[index];
                                          return Container(
                                            height: height / 30,
                                            width: width / 7,
                                            alignment: Alignment.center,
                                            child: Text(
                                                "${snapshot.data.docs.length} left",
                                                style: TextStyle(
                                                    color: Colors.red[900],
                                                    fontSize: width / 30)),
                                          );
                                        });
                                  } else {
                                    return Text("0 Left",
                                        style: TextStyle(
                                            color: Colors.red[900],
                                            fontSize: width / 30));
                                  }
                                } else if (snapshot.hasError) {
                                  return Text("0 Left",
                                      style: TextStyle(
                                          color: Colors.red[900],
                                          fontSize: width / 30));
                                } else {
                                  return Text("0 Left",
                                      style: TextStyle(
                                          color: Colors.red[900],
                                          fontSize: width / 30));
                                }
                              })),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
