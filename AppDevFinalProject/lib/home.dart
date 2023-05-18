import 'package:flutter/material.dart';
import './globals.dart' as globals;
import 'package:firebase_auth/firebase_auth.dart';

//Home Page
class HomePage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          children: [Text("It's nice to see you again ${FirebaseAuth.instance.currentUser!.displayName}!")],
        ));
  }
}
