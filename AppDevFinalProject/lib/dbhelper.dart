import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Model.dart';

class DatabaseHelper {
  final firestore = FirebaseFirestore.instance;

  DatabaseHelper();

  Future<bool> signIn(TextEditingController id, TextEditingController password,
      BuildContext context) async {
    try {
      var usertype =
          await firestore.collection('users').doc(id.text.trim()).get();
      if (usertype.exists) {
        UserA a = UserA.fromFirestore(usertype);
        print(a.email);
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: a.email, password: password.text.trim());

        await FirebaseAuth.instance.currentUser?.updateDisplayName(id.text.trim());
        return true;
      }
    } on FirebaseAuthException catch (e) {
      // var u = new Utils();
      // return u.showSnackBar(e.message);
      final snackBar = SnackBar(
        content: Text(e.message.toString()),
        backgroundColor: Colors.red,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    return false;
  }

  Future<bool> signUp(TextEditingController id, TextEditingController email,
      TextEditingController password, BuildContext context) async {
    try {
      var usertype =
          await firestore.collection('users').doc(id.text.trim()).get();
      if (!usertype.exists) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email.text.trim(), password: password.text.trim());
        createUser(UserA(
            username: id.text.trim(),
            email: email.text.trim(),
            password: password.text.trim()));
        return true;
      }
    } on FirebaseAuthException catch (e) {
      final snackBar = SnackBar(
        content: Text(e.message.toString()),
        backgroundColor: Colors.red,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    return false;
  }

  createUser(UserA user) async {
    try {
      if (firestore.collection('users').doc(user.username).get().toString() !=
          user.username) {
        await firestore
            .collection('users')
            .doc(user.username)
            .set(user.toJson());
      } else {
        print('already exists');
      }
    } catch (e) {
      print(e);
    }
  }

  readUser(String username) async {
    DocumentSnapshot documentSnapshot;
    try {
      documentSnapshot =
          await firestore.collection('users').doc(username).get();
      return UserA.fromFirestore(documentSnapshot);
    } catch (e) {
      print(e);
    }
  }

  // getPass(String username){
  //   DocumentSnapshot documentSnapshot;
  //   try {
  //     documentSnapshot =
  //         await firestore.collection('users').doc(username).get();
  //     print(documentSnapshot.data()username);
  //   } catch (e){
  //     print(e);
  //   }
  // }

  updateUser(UserA user) async {
    try {
      firestore.collection('users').doc(user.username).update(user.toJson());
    } catch (e) {
      print(e);
    }
  }

  deleteUser(String username) async {
    try {
      firestore.collection('users').doc(username).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<List<Item>> allItem() async {
    final snapshot = await firestore.collection('items').get();
    final itemData = snapshot.docs.map((e) => Item.fromSnapshot(e)).toList();
    return itemData;
  }

  Future<List<ItemsList>> allItemsList() async {
    final snapshot = await firestore.collection('itemsList').get();
    final itemData =
        snapshot.docs.map((e) => ItemsList.fromSnapshot(e)).toList();
    return itemData;
  }

  Future<List<RecipiesList>> allRecipies() async {
    final snapshot = await firestore.collection('recipiesList').get();
    final itemData =
        snapshot.docs.map((e) => RecipiesList.fromSnapshot(e)).toList();
    return itemData;
  }

  Future<List<StoresList>> allStores() async {
    final snapshot = await firestore.collection('storesList').get();
    final itemData =
      snapshot.docs.map((e) => StoresList.fromSnapshot(e)).toList();
    return itemData;
  }

  Future<Item> allItemFromList(
      DocumentSnapshot<Map<String, dynamic>> document) async {
    final itemData = Item.fromSnapshot(document);
    return itemData;
  }

  createItem(Item item) async {
    try {
      if (firestore.collection('items').doc(item.itemName).get().toString() !=
          item.itemName) {
        await firestore
            .collection('items')
            .doc(item.itemName)
            .set(item.toJson());
      } else {
        print('already exists');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<int> itemsLength() async {
    return await firestore.collection('items').snapshots().length;
  }

  Future<int> listsLength() async {
    return await firestore.collection('itemsList').snapshots().length;
  }

  Future<int> recipiesLength() async {
    return await firestore.collection('recipiesList').snapshots().length;
  }

  Future<int> storesLength() async {
    return await firestore.collection('storesList').snapshots().length;
  }

  readItem(String itemName) async {
    DocumentSnapshot documentSnapshot;
    try {
      documentSnapshot =
          await firestore.collection('items').doc(itemName).get();
      print(documentSnapshot.data());
    } catch (e) {
      print(e);
    }
  }

  updateItem(String ogName, Item item) async {
    try {
      firestore.collection('items').doc(ogName).delete();
      firestore.collection('items').doc(item.itemName).set(item.toJson());
    } catch (e) {
      print(e);
    }
  }

  deleteItem(String itemName) async {
    try {
      firestore.collection('items').doc(itemName).delete();
    } catch (e) {
      print(e);
    }
  }

  createItemsList(ItemsList itemsList) async {
    try {
      await firestore
          .collection('itemsList')
          .doc(itemsList.itemListTitle)
          .set(itemsList.toJson());
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
    } catch (e) {
      print(e);
    }
  }

  updateItemsList(String ogName, ItemsList itemsList) async {
    try {
      // firestore
      //     .collection('itemsList')
      //     .doc(itemsList.itemListTitle)
      //     .update(itemsList.toJson());
      firestore.collection('itemsList').doc(ogName).delete();
      firestore.collection('itemsList').doc(itemsList.itemListTitle).set(itemsList.toJson());


    } catch (e) {
      print(e);
    }
  }

  Future<List<Item>> getItemsListByName(String ogName, ItemsList itemsList) async {
    try {
      await firestore.collection('itemsList').doc(ogName).delete();
      await firestore.collection('itemsList').doc(itemsList.itemListTitle).set(itemsList.toJson());

      // Retrieve the updated items list from Firestore
      final snapshot = await firestore.collection('itemsList').doc(itemsList.itemListTitle).get();
      if (snapshot.exists) {
        final data = snapshot.data();
        if (data != null && data['itemList'] != null) {
          // Convert the retrieved data to a List of Item objects
          final itemList = List<Item>.from(data['itemList'].map((item) => Item.fromSnapshot(item)));
          return itemList;
        }
      }
    } catch (e) {
      print(e);
    }

    return []; // Return an empty list if there is an error or no data
  }




  deleteItemsList(String temsListName) async {
    try {
      firestore.collection('itemsList').doc(temsListName).delete();
    } catch (e) {
      print(e);
    }
  }

  createRecipiesList(RecipiesList recipiesList) async {
    try {
      await firestore
          .collection('recipiesList')
          .doc(recipiesList.title)
          .set(recipiesList.toJson());
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
    } catch (e) {
      print(e);
    }
  }

  updateRecipiesList(RecipiesList recipiesList) async {
    try {
      firestore
          .collection('recipiesList')
          .doc(recipiesList.title)
          .update(recipiesList.toJson());
    } catch (e) {
      print(e);
    }
  }

  deleteRecipiesList(String temsListName) async {
    try {
      firestore.collection('recipiesList').doc(temsListName).delete();
    } catch (e) {
      print(e);
    }
  }

  createStoresList(StoresList storesList) async {
    try {
      await firestore
          .collection('storesList')
          .doc(storesList.storeName)
          .set(storesList.toJson());
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
    } catch (e) {
      print(e);
    }
  }

  updateStoresList(String ogName,StoresList storesList) async {
    try {
      // firestore
      //     .collection('storesList')
      //     .doc(storesList.storeName)
      //     .update(storesList.toJson());

      firestore.collection('storesList').doc(ogName).delete();
      firestore.collection('storesList').doc(storesList.storeName).set(storesList.toJson());
    } catch (e) {
      print(e);
    }
  }

  deleteStoresList(String storesListName) async {
    try {
      firestore.collection('storesList').doc(storesListName).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<List<Item>> allItems() async {
    try {
      final QuerySnapshot snapshot = await firestore.collection('items').get();
      final List<Item> items = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final itemName = data['itemName'] as String?;
        final itemType = data['itemType'] as String?;
        final itemCost = data['itemCost'] as double?;
        return Item(
          itemName: itemName ?? '',
          itemType: itemType ?? '',
          itemCost: itemCost ?? 0.0,
        );
      }).toList();
      return items;
    } catch (e) {
      print('Error fetching items: $e');
      return [];
    }
  }

  insertItemsList(ItemsList itemsList) async {
    try {
      await firestore.collection('itemsList').doc(itemsList.itemListTitle).set(
            itemsList.toJson(),
          );
    } catch (e) {
      print(e);
    }
  }
  insertStoreList(StoresList StoresList) async {
    try {
      await firestore.collection('storesList').doc(StoresList.storeName).set(
        StoresList.toJson(),
          );
    } catch (e) {
      print(e);
    }
  }
}
// class Utils {
//   final messengerKey = GlobalKey<ScaffoldMessengerState>();
//   showSnackBar(String? text){
//     if (text == null) return;
//
//
//
//     messengerKey.currentState!..removeCurrentSnackBar()..showSnackBar(snackBar);
//
//   }
// }
