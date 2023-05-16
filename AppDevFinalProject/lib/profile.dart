import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './globals.dart' as globals;

//Profile Page
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile page"),
        backgroundColor: globals.mainColor,
      ),
      body:       Center(
        child: Column(
          children: [
            Container(
              height: 320,
              width: 230,
              child: Icon(
                Icons.account_circle_rounded,
                size: 230,
              ),
              decoration:
              BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
              alignment: Alignment.center,
            ),
            Text(FirebaseAuth.instance.currentUser!.email.toString(), style: TextStyle(fontSize: 20)),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {},

              child: Text(
                'Update Profile',
                style: TextStyle(color: Colors.black),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(primary: Colors.red),
              child: Text(
                'Sign out',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}