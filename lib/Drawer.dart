import 'package:task_app/Assistent/chatroom.dart';
import 'package:task_app/Dialoges.dart';
import 'package:task_app/Firebase.dart';
import 'package:flutter/material.dart';

class DRAWER extends StatelessWidget {
  Widget tiles(String title, IconData icon, Function onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 8,
      ),
      child: Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(18),
        child: ListTile(
          onTap: onTap,
          leading: Icon(
            icon,
          ),
          title: Text(
            title,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: [
        UserAccountsDrawerHeader(
            decoration: BoxDecoration(
                color: Colors.blue[800],
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10))),
            currentAccountPicture: ClipOval(
              child: Icon(
                Icons.account_circle,
                color: Colors.white,
                size: 70,
              ),
            ),
            accountName: Text(
              auth.currentUser.displayName,
              style: TextStyle(fontSize: 18),
            ),
            accountEmail: Text(
              auth.currentUser.email,
              style: TextStyle(fontSize: 16),
            )),
        tiles(
            "Chat with assisatance",
            Icons.chat,
            () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => ChatRoom()))),
        tiles(
            "Sign out",
            Icons.account_balance_wallet,
            () =>
                showDialog(context: context, builder: (context) => Dialoges())),
      ],
    ));
  }
}
