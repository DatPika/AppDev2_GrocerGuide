import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Model.dart';
import 'globals.dart' as globals;
import 'dbhelper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

var i = Item(itemName: "corn", itemType: 'vegetable', itemCost: 50);
var i2 = Item(itemName: "pita", itemType: 'bread', itemCost: 0);
var i3 = Item(itemName: "apple", itemType: 'fruit', itemCost: 50);
var i4 = Item(itemName: "chips", itemType: 'not good', itemCost: 50);
var i5 = Item(itemName: "beverage", itemType: 'water', itemCost: 50);
var i6 = Item(itemName: "beverage", itemType: 'wine', itemCost: 50);
late List<Item> itemList = [i, i2, i3, i4];

var d = Item(itemName: "corn", itemType: 'vegetable', itemCost: 10);
var d2 = Item(itemName: "pita", itemType: 'bread', itemCost: 10);
var d3 = Item(itemName: "apple", itemType: 'fruit', itemCost: 10);
var d4 = Item(itemName: "chips", itemType: 'not good', itemCost: 10);
late List<Item> itemList2 = [d, d2, d3, d4];

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'firebase demo',
      theme: ThemeData(
          primarySwatch: Colors.blue
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Firestore CRUD'),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            ElevatedButton(onPressed: () {
              globals.db.createItem(i5);
            }, child: Text('Create'),),
            ElevatedButton(onPressed: () {
              globals.db.readItem("Pita");
            }, child: Text('Read'),),
            ElevatedButton(onPressed: () {
              globals.db.updateItem(i6);
            }, child: Text('Update'),),
            ElevatedButton(onPressed: () {
              globals.db.deleteItem('Pita');
            }, child: Text('Delete'),),

            ElevatedButton(onPressed: () {
              globals.db.createItemsList(ItemsList(type: 'food', itemListTitle: 'foodToBuy', itemList: itemList));
            }, child: Text('create list'),),

            ElevatedButton(onPressed: () {
              globals.db.readItemsList('foodToBuy');
            }, child: Text('read list'),),

            ElevatedButton(onPressed: () {
              globals.db.updateItemsList(ItemsList(type: 'food', itemListTitle: 'foodToBuy', itemList: itemList2));
            }, child: Text('update list'),),

            ElevatedButton(onPressed: () {
              globals.db.deleteItemsList('foodToBuy');
            }, child: Text('delete list'),),

            // ElevatedButton(onPressed: () {
            //   globals.db.createRecipiesList(RecipiesList(imageId: "hehhehe",instructions: "1. eat \n 2. eat \n 3. eat" ,type: 'food', itemListTitle: 'foodToBuy', itemList: itemList));
            // }, child: Text('create recipies list'),),
            //
            // ElevatedButton(onPressed: () {
            //   globals.db.readRecipiesList('foodToBuy');
            // }, child: Text('read recipies list'),),
            //
            // ElevatedButton(onPressed: () {
            //   globals.db.updateRecipiesList(RecipiesList(imageId: "hohohohhehe",instructions: "1. eat \n 2. eat \n 3. eat" ,type: 'food', itemListTitle: 'foodToBuy', itemList: itemList2));
            // }, child: Text('update recipies list'),),
            //
            // ElevatedButton(onPressed: () {
            //   globals.db.deleteRecipiesList('foodToBuy');
            // }, child: Text('delete recipies list'),),


            ElevatedButton(onPressed: () {
              globals.db.createStoresList(StoresList(storeName: 'store3', itemsList: ItemsList(type: 'potato', itemListTitle: 'coolTitle', itemList: itemList)));
            }, child: Text('create Stores list'),),

            ElevatedButton(onPressed: () {
              globals.db.readStoresList('foodToBuy');
            }, child: Text('read Stores list'),),

            // ElevatedButton(onPressed: () {
            //   globals.db.updateStoresList(StoresList(storeName: "hohohohhehe",type: 'food', itemListTitle: 'foodToBuy', itemList: itemList2));
            // }, child: Text('update Stores list'),),

            ElevatedButton(onPressed: () {
              globals.db.deleteStoresList('foodToBuy');
            }, child: Text('delete Stores list'),),
          ],
        ),
      ),
    );
  }
}
