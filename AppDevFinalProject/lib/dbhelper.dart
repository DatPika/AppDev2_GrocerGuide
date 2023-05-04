import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Model.dart';

class DatabaseHelper{
  final firestore = FirebaseFirestore.instance;
  DatabaseHelper();

  // createUser(User user) async{
  //   try {
  //     if (firestore.collection('users').doc(user.username).get().toString() != user.username){
  //       await firestore.collection('users').doc(user.username).set(
  //           user.toJson()
  //       );
  //
  //     }
  //     else{
  //       print('already exists');
  //     }
  //
  //   } catch (e) {
  //     print(e);
  //   }
  // }
  //
  // readUser(String username) async {
  //   DocumentSnapshot documentSnapshot;
  //   try {
  //     documentSnapshot =
  //     await firestore.collection('users').doc(username).get();
  //     print(documentSnapshot.data());
  //   } catch (e){
  //     print(e);
  //   }
  // }
  //
  // // getPass(String username){
  // //   DocumentSnapshot documentSnapshot;
  // //   try {
  // //     documentSnapshot =
  // //         await firestore.collection('users').doc(username).get();
  // //     print(documentSnapshot.data()username);
  // //   } catch (e){
  // //     print(e);
  // //   }
  // // }
  //
  // updateUser(User user) async {
  //   try {
  //     firestore.collection('users').doc(user.username).update(user.toJson());
  //   } catch (e) {
  //     print(e);
  //   }
  // }
  //
  // deleteUser(String username) async {
  //   try {
  //     firestore.collection('users').doc(username).delete();
  //   } catch (e){
  //     print(e);
  //   }
  // }

  createItem(Item item) async{
    try {
      if (firestore.collection('items').doc(item.itemName).get().toString() != item.itemName){
        await firestore.collection('items').doc(item.itemName).set(
            item.toJson()
        );

      }
      else{
        print('already exists');
      }

    } catch (e) {
      print(e);
    }
  }

  readItem(String itemName) async {
    DocumentSnapshot documentSnapshot;
    try {
      documentSnapshot =
      await firestore.collection('items').doc(itemName).get();
      print(documentSnapshot.data());
    } catch (e){
      print(e);
    }
  }

  updateItem(Item item) async {
    try {
      firestore.collection('items').doc(item.itemName).update(item.toJson());
    } catch (e) {
      print(e);
    }
  }

  deleteItem(String itemName) async {
    try {
      firestore.collection('items').doc(itemName).delete();
    } catch (e){
      print(e);
    }
  }

  createItemsList(ItemsList itemsList) async{
    try {
      await firestore.collection('itemsList').doc(itemsList.itemListTitle).set(
          itemsList.toJson()
      );
    } catch (e) {
      print(e);
    }
  }

  readItemsList(String itemsListName) async {
    DocumentSnapshot documentSnapshot;
    try {
      documentSnapshot =
      await firestore.collection('itemsList').doc(itemsListName).get();
      print(documentSnapshot.data());
    } catch (e){
      print(e);
    }
  }

  updateItemsList(ItemsList itemsList) async {
    try {
      firestore.collection('itemsList').doc(itemsList.itemListTitle).update(itemsList.toJson());
    } catch (e) {
      print(e);
    }
  }

  deleteItemsList(String temsListName) async {
    try {
      firestore.collection('itemsList').doc(temsListName).delete();
    } catch (e){
      print(e);
    }
  }
    createRecipiesList(RecipiesList recipiesList) async{
    try {
      await firestore.collection('recipiesList').doc(recipiesList.itemListTitle).set(
          recipiesList.toJson()
      );
    } catch (e) {
      print(e);
    }
  }

  readRecipiesList(String itemsListName) async {
    DocumentSnapshot documentSnapshot;
    try {
      documentSnapshot =
      await firestore.collection('recipiesList').doc(itemsListName).get();
      print(documentSnapshot.data());
    } catch (e){
      print(e);
    }
  }

  updateRecipiesList(RecipiesList recipiesList) async {
    try {
      firestore.collection('recipiesList').doc(recipiesList.itemListTitle).update(recipiesList.toJson());
    } catch (e) {
      print(e);
    }
  }

  deleteRecipiesList(String temsListName) async {
    try {
      firestore.collection('recipiesList').doc(temsListName).delete();
    } catch (e){
      print(e);
    }
  }

  createStoresList(StoresList storesList) async{
    try {
      await firestore.collection('storesList').doc(storesList.itemListTitle).set(
          storesList.toJson()
      );
    } catch (e) {
      print(e);
    }
  }

  readStoresList(String storesListName) async {
    DocumentSnapshot documentSnapshot;
    try {
      documentSnapshot =
      await firestore.collection('storesList').doc(storesListName).get();
      print(documentSnapshot.data());
    } catch (e){
      print(e);
    }
  }

  updateStoresList(StoresList storesList) async {
    try {
      firestore.collection('storesList').doc(storesList.itemListTitle).update(storesList.toJson());
    } catch (e) {
      print(e);
    }
  }

  deleteStoresList(String storesListName) async {
    try {
      firestore.collection('storesList').doc(storesListName).delete();
    } catch (e){
      print(e);
    }
  }

}