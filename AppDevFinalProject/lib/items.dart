import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Model.dart';
import 'globals.dart' as globals;

class ItemsPage extends StatefulWidget {
  const ItemsPage({Key? key}) : super(key: key);

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  CollectionReference itemCollection = globals.db.firestore.collection('items');
  late Stream<QuerySnapshot> itemStream;

  Future<List<Item>> getAllItem() async {
    return await globals.db.allItem();
  }

  @override
  void initState() {
    super.initState();
    itemStream = itemCollection.snapshots();
  }
  @override
  Widget build(BuildContext context) {
    itemCollection.get();
    itemCollection.snapshots();
    return Scaffold(
      body: Center(
          child: Column(
            children: [
              Expanded(
                  child: FutureBuilder<List<Item>>(
                    future: getAllItem(),
                    builder: (context, snapshot){
                      if(snapshot.connectionState == ConnectionState.done){
                        if (snapshot.hasData){
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (c, index) {
                              return Column(
                                children: [
                                  ListTile(
                                    iconColor: globals.mainColor,
                                    tileColor: globals.mainColor.withOpacity(0.1),
                                    title: Text("Name: ${snapshot.data![index].itemName}"),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(snapshot.data![index].itemType),
                                        Text(snapshot.data![index].itemCost.toString()),
                                      ],
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              editNewItem(context, snapshot.data![index].itemName, snapshot.data![index].itemType, snapshot.data![index].itemCost);
                                            },
                                            icon: Icon(Icons.edit)
                                        ),

                                        IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) => AlertDialog(
                                                  title: Text("Are you sure you want to delete"),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () async {
                                                        globals.db.deleteItem(snapshot.data![index].itemName);
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text('Delete', style: TextStyle(color: globals.mainColor),),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text('Cancel', style: TextStyle(color: globals.mainColor),),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            icon: Icon(Icons.delete)
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    color: globals.mainColor,)
                                ],
                              );
                            },
                          );
                        }
                      }
                      return Center(child: CircularProgressIndicator(color: globals.mainColor));
                    },
                  )
              ),

              ElevatedButton(
                  style: ButtonStyle(),
                  onPressed: () async{
                    addNewItem(context);
                  },
                  child: Text(
                    'Add Item',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  )),
            ],
          )
      ),
    );
  }
}

void addNewItem(BuildContext context) {
  TextEditingController name = TextEditingController();
  TextEditingController type = TextEditingController();
  TextEditingController cost = TextEditingController();

  showDialog(context: context, builder: (BuildContext context) =>
  new AlertDialog(
    title: Text("Add new Item"),
    content: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: TextField(
              controller: name,
              decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Item Name'
              ),

            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: TextField(
              controller: type,
              decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Item Type'
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: TextField(
                controller: cost,
                decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Item Cost'
                ),
                keyboardType: TextInputType.number
            ),
          ),
          ElevatedButton(
              onPressed: () {
                if (double.parse(cost.text) > 0) {
                  globals.db.createItem(Item(itemName: name.text,
                      itemType: type.text,
                      itemCost: double.parse(cost.text)));
                }
                else {
                  globals.db.createItem(Item(
                      itemName: name.text, itemType: type.text, itemCost: 0.0));
                }
                Navigator.of(context).pop();
              },
              child: Text('Add')
          )
        ],
      ),
    ),
  )
  );
}

void editNewItem(BuildContext context, String name1, String type1, double cost1) {
  TextEditingController name = TextEditingController(text: name1);
  TextEditingController type = TextEditingController(text: type1);
  TextEditingController cost = TextEditingController(text: cost1.toString());

  showDialog(context: context, builder: (BuildContext context) => new AlertDialog(
    title: Text("Edit Item"),
    content: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: TextField(
              controller: name,
              decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Item Name'
              ),

            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: TextField(
              controller: type,
              decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Item Type'
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: TextField(
                controller: cost,
                decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Item Cost'
                ),
                keyboardType: TextInputType.number
            ),
          ),
          ElevatedButton(
              onPressed: () {
                if (double.parse(cost.text) > 0){
                  globals.db.updateItem(name1, Item(itemName: name.text, itemType: type.text, itemCost: double.parse(cost.text)));
                }
                else{
                  globals.db.createItem(Item(itemName: name.text, itemType: type.text, itemCost: 0.0));
                }
                Navigator.of(context).pop();
              },
              child: Text('Update')
          )
        ],
      ),
    ),
  )
  );
}