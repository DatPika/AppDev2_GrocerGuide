import 'dbhelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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



class Item {
  final String itemName;
  final String itemType;
  final double itemCost; 
  
  Item({
    required this.itemName,
    required this.itemType,
    required this.itemCost,
  });

  Map<String, dynamic> toJson() => {
    'itemName': itemName,
    'itemType': itemType,
    'itemCost': itemCost, 
  };

  factory Item.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return Item(
      itemName: data["itemName"],
      itemType: data["itemType"],
      itemCost: data['itemCost']?.toDouble(), 
    );
  }
}


class ItemsList {
  final String type;
  final String itemListTitle;
  final List<Item> itemList;
  double totalCost;

  ItemsList({
    required this.type,
    required this.itemListTitle,
    required this.itemList,
    this.totalCost = 0,
  }) {
    _calculateTotalCost();
  }

  void _calculateTotalCost() {
    totalCost = 0;
    itemList.forEach((e) {
      if (e.itemCost != null) {
        totalCost += e.itemCost!;
      }
    });
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    'itemListTitle': itemListTitle,
    'itemList': itemList.map((e) => e.toJson()).toList(),
    'totalCost': totalCost,
  };

  factory ItemsList.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    final itemList = (data['itemList'] as List<dynamic>)
        .map((item) => Item(
      itemName: item['itemName'],
      itemType: item['itemType'],
      itemCost: item['itemCost']?.toDouble() ?? 0.0,
    ))
        .toList();

    final totalCost = data['totalCost'] != null ? data['totalCost'].toDouble() : 0.0;

    return ItemsList(
      itemListTitle: data['itemListTitle'],
      type: data['type'],
      itemList: itemList,
      totalCost: totalCost,
    );
  }
}


class RecipiesList {
  final String title;
  final String description;
  final String instructions;
  final String imageURL;
  final ItemsList itemsList;

  RecipiesList({
    required this.title,
    required this.description,
    required this.instructions,
    required this.imageURL,
    required this.itemsList,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'instructions': instructions,
    'imageURL': imageURL,
    'itemsList': itemsList.toJson(),
  };

  factory RecipiesList.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    final itemsListData = data['itemsList'] as Map<String, dynamic>;
    final itemListData = itemsListData['itemList'] as List<dynamic>;

    final itemList = itemListData
        .map((item) => Item(
      itemName: item['itemName'],
      itemType: item['itemType'],
      itemCost: item['itemCost']?.toDouble() ?? 0.0,
    ))
        .toList();

    final itemsList = ItemsList(
      type: itemsListData['type'],
      itemListTitle: itemsListData['itemListTitle'],
      itemList: itemList,
      totalCost: itemsListData['totalCost']?.toDouble() ?? 0.0,
    );

    return RecipiesList(
      title: data['title'],
      description: data['description'],
      instructions: data['instructions'],
      imageURL: data['imageURL'],
      itemsList: itemsList,
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
