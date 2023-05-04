import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Model.dart';
import 'dbhelper.dart';

var i = Item(itemName: "corn", itemType: 'vegetable', itemCost: 50);
var i2 = Item(itemName: "pita", itemType: 'bread');
var i3 = Item(itemName: "apple", itemType: 'fruit', itemCost: 50);
var i4 = Item(itemName: "chips", itemType: 'not good', itemCost: 50);
late List<Item> itemList = [i, i2, i3, i4];

var d = Item(itemName: "corn", itemType: 'vegetable', itemCost: 10);
var d2 = Item(itemName: "pita", itemType: 'bread', itemCost: 10);
var d3 = Item(itemName: "apple", itemType: 'fruit', itemCost: 10);
var d4 = Item(itemName: "chips", itemType: 'not good', itemCost: 10);
late List<Item> itemList2 = [d, d2, d3, d4];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

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
  final db = new DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Firestore CRUD'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:<Widget> [
            
            // ElevatedButton(onPressed: () {
            //   db.createItem(i);
            // }, child: Text('Create'),),
            // ElevatedButton(onPressed: () {
            //   db.readItem("Pita");
            // }, child: Text('Read'),),
            // ElevatedButton(onPressed: () {
            //   db.updateItem(Item(itemName: "Pita", itemType: "Not Bread", itemCost: 3.22));
            // }, child: Text('Update'),),
            // ElevatedButton(onPressed: () {
            //   db.deleteItem('Pita');
            // }, child: Text('Delete'),),
            
            // ElevatedButton(onPressed: () {
            //   db.createItemsList(ItemsList(type: 'food', itemListTitle: 'foodToBuy', itemList: itemList));
            // }, child: Text('create list'),),
            //
            // ElevatedButton(onPressed: () {
            //   db.readItemsList('foodToBuy');
            // }, child: Text('read list'),),
            //
            // ElevatedButton(onPressed: () {
            //   db.updateItemsList(ItemsList(type: 'food', itemListTitle: 'foodToBuy', itemList: itemList2));
            // }, child: Text('update list'),),
            //
            // ElevatedButton(onPressed: () {
            //   db.deleteItemsList('foodToBuy');
            // }, child: Text('delete list'),),
            //
            // ElevatedButton(onPressed: () {
            //   db.createRecipiesList(RecipiesList(imageId: "hehhehe",instructions: "1. eat \n 2. eat \n 3. eat" ,type: 'food', itemListTitle: 'foodToBuy', itemList: itemList));
            // }, child: Text('create recipies list'),),
            //
            // ElevatedButton(onPressed: () {
            //   db.readRecipiesList('foodToBuy');
            // }, child: Text('read recipies list'),),
            //
            // ElevatedButton(onPressed: () {
            //   db.updateRecipiesList(RecipiesList(imageId: "hohohohhehe",instructions: "1. eat \n 2. eat \n 3. eat" ,type: 'food', itemListTitle: 'foodToBuy', itemList: itemList2));
            // }, child: Text('update recipies list'),),
            //
            // ElevatedButton(onPressed: () {
            //   db.deleteRecipiesList('foodToBuy');
            // }, child: Text('delete recipies list'),),
            //

            ElevatedButton(onPressed: () {
              db.createStoresList(StoresList(storeName: "hehhehe" ,type: 'food', itemListTitle: 'foodToBuy', itemList: itemList));
            }, child: Text('create Stores list'),),

            ElevatedButton(onPressed: () {
              db.readStoresList('foodToBuy');
            }, child: Text('read Stores list'),),

            ElevatedButton(onPressed: () {
              db.updateStoresList(StoresList(storeName: "hohohohhehe",type: 'food', itemListTitle: 'foodToBuy', itemList: itemList2));
            }, child: Text('update Stores list'),),

            ElevatedButton(onPressed: () {
              db.deleteStoresList('foodToBuy');
            }, child: Text('delete Stores list'),),

          ],
        ),
      ),
    );
  }
}
