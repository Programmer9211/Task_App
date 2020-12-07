import 'dart:async';
import 'package:task_app/Widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:task_app/CreateTask.dart';

import '../Firebase.dart';

class ChatRoom extends StatefulWidget {
  ChatRoom({Key key}) : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  int time = DateTime.now().hour;
  bool isaddingtodo = false;

  List<String> message = List<String>();

  List<bool> isMe = List<bool>();

  List<String> suggesion = [
    "Add task for me",
    "Sign out me",
    " Window",
    "Hehe",
    "YoYo",
    "Dont Know"
  ];

  String greeting;

  void checktime() {
    if (time < 12) {
      greeting = "Good Morning";
    } else if (time >= 12 && time <= 17) {
      greeting = "Good Afternoon";
    } else {
      greeting = "Good Evening";
    }
  }

  void send() {
    Timer(Duration(seconds: 1), () {
      if (!mounted) {
        return;
      }
      setState(() {
        message
            .add("$greeting ${auth.currentUser.displayName}, My Name is Bot");
        isMe.add(false);
      });
      _speak(message[0]);
    });

    Timer(Duration(seconds: 4), () {
      if (!mounted) {
        return;
      }

      setState(() {
        message.add("How can i help You");
        isMe.add(false);
      });
      _speak(message[1]);
    });
  }

  @override
  void initState() {
    super.initState();
    checktime();
    send();
    initializeTts();
  }

  @override
  void dispose() {
    super.dispose();
    _stop();
    _inputmessage.dispose();
  }

  TextEditingController _inputmessage = TextEditingController();

  void add(String reply) {
    Timer(Duration(milliseconds: 200), () {
      if (!mounted) {
        return;
      }
      setState(() {
        message.add(reply);
        isMe.add(true);
      });
      listen();
    });
  }

  void answer(String reply) {
    if (!mounted) {
      return;
    }
    Timer(Duration(milliseconds: 800), () {
      setState(() {
        message.add(reply);
        isMe.add(false);
      });
      _speak(reply);
    });
  }

  void listen() {
    String mess = message.last.toLowerCase();

    if (mess == "hello" || mess == "hi" || mess == "hi bot") {
      answer("Hello, My Name is Bot");
    } else if (mess == "add task for me" ||
        mess == "personal" ||
        mess == "work" ||
        mess == "health" ||
        mess == "social") {
      if (mess == "add task for me") {
        answer(
          "Ok",
        );
        answer(
            "In which collection you want to add task \nPersonal\nWork\nHealth\nSocial");
      } else if (mess == "personal") {
        Timer(Duration(seconds: 1), () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CreateTask(false, null, 'task'),
              ));
        });
      } else if (mess == "work") {
        Timer(Duration(seconds: 1), () {
          answer("Ok, Here we go...");
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CreateTask(false, null, 'task1'),
              ));
        });
      } else if (mess == "health") {
        answer("Ok, Here we go...");
        Timer(Duration(seconds: 1), () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CreateTask(false, null, 'task2'),
              ));
        });
      } else {
        answer("Ok, Here we go...");
        Timer(Duration(seconds: 1), () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CreateTask(false, null, 'task3'),
              ));
        });
      }
    } else if (mess == "sign me out") {
      answer(
        "Done ${auth.currentUser.displayName} !!",
      );
      Timer(Duration(seconds: 2), () => signout(context));
    } else if (mess == "") {
      answer("....");
    } else {
      answer(
        "Sorry I can't Understand your question",
      );
    }
  }

  FlutterTts _flutterTts;

  initializeTts() {
    _flutterTts = FlutterTts();

    _flutterTts.setStartHandler(() {
      setState(() {
        //isPlaying = true;
      });
    });

    _flutterTts.setCompletionHandler(() {
      setState(() {
        //isPlaying = false;
      });
    });

    _flutterTts.setErrorHandler((err) {
      setState(() {
        print("error occurred: " + err);
        //isPlaying = false;
      });
    });

    _flutterTts.setSpeechRate(0.88);

    _flutterTts.setPitch(0.90);
  }

  Future _speak(String text) async {
    if (text != null && text.isNotEmpty) {
      var result = await _flutterTts.speak(text);
      if (result == 1)
        setState(() {
          //isPlaying = true;
        });
    }
  }

  Future _stop() async {
    var result = await _flutterTts.stop();
    if (result == 1)
      setState(() {
        //isPlaying = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Room"),
      ),
      body: Container(
        height: height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: height / 1.42,
                width: double.infinity,
                child: message == null
                    ? Container()
                    : ListView.builder(
                        itemCount: message.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.only(right: 20, left: 20),
                            margin: EdgeInsets.symmetric(vertical: 8),
                            alignment: isMe[index] == false
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                            width: double.infinity,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 16),
                              decoration: BoxDecoration(
                                  color: isMe[index] == false
                                      ? Colors.grey
                                      : Colors.blue,
                                  borderRadius: isMe[index] == false
                                      ? BorderRadius.only(
                                          topRight: Radius.circular(15),
                                          topLeft: Radius.circular(15),
                                          bottomRight: Radius.circular(15))
                                      : BorderRadius.only(
                                          topRight: Radius.circular(15),
                                          topLeft: Radius.circular(15),
                                          bottomLeft: Radius.circular(15))),
                              child: Text(message[index],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  )),
                            ),
                          );
                        }),
              ),
              Container(
                  alignment: Alignment.center,
                  height: height / 12.5,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: suggesion.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            if (index == 0) {
                              add(
                                "Add task for me",
                              );
                            } else if (index == 1) {
                              add(
                                "Sign me out",
                              );
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 4, right: 4),
                              child: Container(
                                  height: height / 20,
                                  padding: EdgeInsets.all(8),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.blue)),
                                  child: Text(
                                    suggesion[index],
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  )),
                            ),
                          ),
                        );
                      })),
              Container(
                height: height / 10,
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                        child:
                            textField(_inputmessage, "Type a message", null)),
                    IconButton(
                        icon: Icon(
                          Icons.send,
                          //color: Colors.white,
                        ),
                        onPressed: () {
                          FocusScopeNode currentFocus = FocusScope.of(context);

                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }

                          if (isaddingtodo == true) {
                            taskcollection
                                .doc(auth.currentUser.uid)
                                .collection('task')
                                .add({
                              'task': _inputmessage.text,
                              'time': DateTime.now()
                            });

                            FocusScopeNode currentFocus =
                                FocusScope.of(context);

                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }

                            add(_inputmessage.text);
                            _inputmessage.clear();

                            answer(
                              "Task added Sucessfully",
                            );

                            setState(() {
                              isaddingtodo = false;
                            });
                          } else {
                            add(
                              _inputmessage.text,
                            );
                            _inputmessage.clear();
                          }
                        })
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
