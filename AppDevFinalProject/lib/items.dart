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
                                              print(snapshot.data![index].itemCost);
                                            },
                                            icon: Icon(Icons.edit)
                                        ),

                                        IconButton(
                                            onPressed: () {
                                              globals.db.deleteItem(snapshot.data![index].itemName);
                                              Navigator.pop(context);  // pop current page
                                              Navigator.pushNamed(context, "MyHomePage");
                                            },
                                            icon: Icon(Icons.delete)
                                        ),
                                      ],
                                    ),
                                  )
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
                    TextEditingController name = TextEditingController();
                    TextEditingController type = TextEditingController();
                    TextEditingController cost = TextEditingController();

                    showDialog(context: context, builder: (BuildContext context) => new AlertDialog(
                      title: Text("Add new Item"),
                      content: Container(
                        child: Column(
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
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        ElevatedButton(
                            onPressed: () {
                              if (double.parse(cost.text) > 0){
                                globals.db.createItem(Item(itemName: name.text, itemType: type.text, itemCost: double.parse(cost.text)));
                              }
                              else{
                                globals.db.createItem(Item(itemName: name.text, itemType: type.text));
                              }
                              Navigator.of(context).pop();
                            },
                            child: Text('Add')
                        )
                      ],
                    )
                    );
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
