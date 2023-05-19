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

  @override
  void initState() {
    super.initState();
    itemStream = itemCollection.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Items',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Here are the items that you can create that will allow you to add in your lists!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: itemStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child:
                          CircularProgressIndicator(color: globals.mainColor));
                }

                final List<QueryDocumentSnapshot> documents =
                    snapshot.data!.docs;
                final List<Item> items = documents
                    .map((doc) => Item.fromSnapshot(
                        doc as DocumentSnapshot<Map<String, dynamic>>))
                    .toList();

                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];

                    return Column(
                      children: [
                        ListTile(
                          iconColor: globals.mainColor,
                          tileColor: globals.mainColor.withOpacity(0.1),
                          title: Text(
                            "${item.itemName}",
                            style: TextStyle(fontSize: 19),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Type: ${item.itemType}",
                                style: TextStyle(
                                    fontSize: 14, fontStyle: FontStyle.italic),
                              ),
                              Text(
                                "${item.itemCost.toString()}\$",
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  editNewItem(context, item);
                                },
                                icon: Icon(Icons.edit),
                              ),
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: Text(
                                          "Are you sure you want to delete?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () async {
                                            globals.db
                                                .deleteItem(item.itemName);
                                            Navigator.pop(context);
                                          },
                                          child: Text('Delete',
                                              style: TextStyle(
                                                  color: globals.mainColor)),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('Cancel',
                                              style: TextStyle(
                                                  color: globals.mainColor)),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                icon: Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ),
                        Divider(color: globals.mainColor),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addNewItem(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void addNewItem(BuildContext context) {
    TextEditingController name = TextEditingController();
    TextEditingController type = TextEditingController();
    TextEditingController cost = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
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
                    labelText: 'Item Name',
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: TextField(
                  controller: type,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Item Type',
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: TextField(
                  controller: cost,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Item Cost',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  double itemCost = double.tryParse(cost.text) ?? 0.0;
                  globals.db.createItem(Item(
                    itemName: name.text,
                    itemType: type.text,
                    itemCost: itemCost,
                  ));
                  Navigator.of(context).pop();
                },
                child: Text('Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void editNewItem(BuildContext context, Item item) {
    TextEditingController name = TextEditingController(text: item.itemName);
    TextEditingController type = TextEditingController(text: item.itemType);
    TextEditingController cost =
        TextEditingController(text: item.itemCost.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
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
                    labelText: 'Item Name',
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: TextField(
                  controller: type,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Item Type',
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: TextField(
                  controller: cost,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Item Cost',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  double itemCost = double.tryParse(cost.text) ?? 0.0;
                  globals.db.updateItem(
                      item.itemName,
                      Item(
                        itemName: name.text,
                        itemType: type.text,
                        itemCost: itemCost,
                      ));
                  Navigator.of(context).pop();
                },
                child: Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
