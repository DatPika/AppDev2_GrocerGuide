import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseHelper{
  static final firestore = FirebaseFirestore.instance;


  DatabaseHelper();

  create() async{
    try {
      await firestore.collection('users').doc('testuser').set({
        'firstname' : 'John',
        'lastname' : 'Lick',
      });
    } catch (e) {
      print(e);
    }
  }

  read() async {
    DocumentSnapshot documentSnapshot;
    try {
      documentSnapshot =
      await firestore.collection('users').doc('testuser').get();
      print(documentSnapshot.data());
    } catch (e){
      print(e);
    }
  }

  update() async {
    try {
      firestore.collection('users').doc('testuser').update({
        'firstname' : 'Viggo'
      });
    } catch (e) {
      print(e);
    }
  }

  delete() async {
    try {
      firestore.collection('users').doc('testuser').delete();
    } catch (e){
      print(e);
    }
  }
}