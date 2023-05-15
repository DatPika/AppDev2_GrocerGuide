import 'dbhelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'globals.dart' as globals;

int getIntOrDefault(dynamic value) {
  return value is int ? value : 0;
}

int getDoubleOrDefault(dynamic value) {
  return value;
}

String getStringOrDefault(dynamic value) {
  return value is String ? value : '';
}

List<Item> getItemList(dynamic value){
  return value;
}



class Item{
  final String itemName;
  final String itemType;
  double itemCost;

  Item({required this.itemName,required this.itemType, this.itemCost = 0});


  Map<String, dynamic> toJson() => {
    'itemName' : itemName,
    'itemType' : itemType,
    'itemCost' : itemCost
  };

  factory Item.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    return Item(itemName: data!["itemName"], itemType: data!["itemType"], itemCost: data!['itemCost']);
  }
}

class ItemsList{
  final String type;
  final String itemListTitle;
  final List<Item> itemList;
  double totalCost = 0;

  _calculateTotalcost(){
    itemList.forEach((e) {
      if(e.itemCost != null){
        totalCost += double.parse(e.itemCost.toString());
      }
    });
  }
  ItemsList({required this.type, required this.itemListTitle,required this.itemList, this.totalCost = 0}){
    _calculateTotalcost();
  }

  Map<String, dynamic> toJson() => {

    'type' : type,
    'itemListTitle' : itemListTitle,
    'itemList' : itemList.map((e) => e.toJson()).toList(),
    'totalCost' : totalCost
  };



  factory ItemsList.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {

    final data = document.data();
    print(data);

    return ItemsList(
        itemListTitle: data!['itemListTitle'],
        type: data!['type'],
        itemList: data!['itemList'],
        totalCost: data!['totalCost']
    );
  }
}

class RecipiesList extends ItemsList{
  final String imageId;
  final String instructions;

  RecipiesList({required String type, required String itemListTitle,required List<Item> itemList, required this.imageId,required this.instructions})
      : super(type: type, itemListTitle: itemListTitle, itemList: itemList);

  Map<String, dynamic> toJson() => {
    'type' : type,
    'itemListTitle' : itemListTitle,
    'itemList' : itemList.map((e) => e.toJson()).toList(),
    'totalCost' : totalCost,
    'imageId' : imageId,
    'instructions' : instructions
  };

  factory RecipiesList.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return RecipiesList(
      itemListTitle: getStringOrDefault(data["itemListTitle"]),
      imageId: getStringOrDefault(data["imageId"]),
      instructions: getStringOrDefault(data["instructions"]),
      type: getStringOrDefault(data["type"]),
      itemList: getItemList(data["itemList"]),
    );
  }
}

class StoresList extends ItemsList {
  final String storeName;

  StoresList({required String type, required String itemListTitle,required List<Item> itemList, required this.storeName})
      : super(type: type, itemListTitle: itemListTitle, itemList: itemList);

  Map<String, dynamic> toJson() => {
    'type' : type,
    'itemListTitle' : itemListTitle,
    'itemList' : itemList.map((e) => e.toJson()).toList(),
    'totalCost' : totalCost,
    'storeName' : storeName
  };

  factory StoresList.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return StoresList(
      itemListTitle: getStringOrDefault(data["itemListTitle"]),
      storeName: getStringOrDefault(data["storeName"]),
      type: getStringOrDefault(data["type"]),
      itemList: getItemList(data["itemList"]),
    );
  }

}

class UserA {
  String username = "";
  String email = "";
  String password = "";

  UserA({required this.username,required this.email, required this.password});

  UserA.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
  }



  factory UserA.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return UserA(
      username: getStringOrDefault(data["username"]),
      email: getStringOrDefault(data["email"]),
      password: getStringOrDefault(data["password"]),
    );
  }

  Map<String, dynamic> toJson() => {
    'username' : username,
    'email' : email,
    'password' : password,
  };

}
