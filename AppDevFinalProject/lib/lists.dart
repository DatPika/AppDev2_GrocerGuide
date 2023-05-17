import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Model.dart';
import 'globals.dart' as globals;

class ListsPage extends StatefulWidget {
  const ListsPage({Key? key}) : super(key: key);

  @override
  State<ListsPage> createState() => _ListsPageState();
}

class _ListsPageState extends State<ListsPage> {
  CollectionReference itemCollection =
      globals.db.firestore.collection('itemsList');
  late Stream<QuerySnapshot> itemStream;
  List<Item> existingItems = [];
  List<Item> itemList = [];


  Future<List<ItemsList>> getAllItemsList() async {
    return await globals.db.allItemsList();
  }

  @override
  void initState() {
    super.initState();
    itemStream = itemCollection.snapshots();

    Future<void> loadItems() async {
      List<Item> items = await globals.db.allItems();
      setState(() {
        existingItems = items;
      });
    }

    loadItems();
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
              child: FutureBuilder<List<ItemsList>>(
            future: getAllItemsList(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // print(getAllItemsList());
                print(snapshot);
                if (snapshot.hasData) {
                  // print(getAllItemsList());
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (c, index) {
                      // print(snapshot.data![index].itemListTitle);
                      return Column(
                        children: [
                          ListTile(
                            iconColor: globals.mainColor,
                            tileColor: globals.mainColor.withOpacity(0.1),
                            title: Text(
                                "Name: ${snapshot.data![index].itemListTitle}"),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(snapshot.data![index].type),
                                Text(
                                    snapshot.data![index].totalCost.toString()),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    onPressed: () {}, icon: Icon(Icons.edit)),
                                IconButton(
                                    onPressed: () {
                                      globals.db.deleteItemsList(
                                          snapshot.data![index].itemListTitle);
                                      Navigator.pop(
                                          context); // pop current page
                                      Navigator.pushNamed(
                                          context, "MyHomePage");
                                    },
                                    icon: Icon(Icons.delete)),
                              ],
                            ),
                          )
                        ],
                      );
                    },
                  );
                }
              }

              return Center(
                  child: CircularProgressIndicator(color: globals.mainColor));
            },
          )),
          ElevatedButton(
              style: ButtonStyle(),
              onPressed: () async {
                List<Item> selectedItems = [];
                TextEditingController itemListTitle = TextEditingController();
                TextEditingController type = TextEditingController();
                TextEditingController totalCost = TextEditingController();

                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Text("Add Item List"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: itemListTitle,
                          decoration: InputDecoration(
                            labelText: 'Item List Title',
                          ),
                        ),
                        TextField(
                          controller: type,
                          decoration: InputDecoration(
                            labelText: 'Type',
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              // Your existing code here

                              // Navigate to ItemListWidget and pass necessary data
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ItemListWidget(
                                    itemList: existingItems,
                                    selectedItems: selectedItems,
                                    onItemsSelected: (selectedItems) {
                                      setState(() {
                                        itemList = selectedItems;
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                            child: Text("Select items"))
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          final itemList = ItemsList(
                            itemListTitle: itemListTitle.text,
                            type: type.text,
                            itemList: selectedItems,
                            totalCost: double.tryParse(totalCost.text) ?? 0.0,
                          );
                          globals.db.insertItemsList(itemList).whenComplete(() {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, "MyHomePage");
                          });
                        },
                        child: Text('Save'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'),
                      ),
                    ],
                  ),
                );
              },
              child: Text(
                'Add List',
                style: TextStyle(fontSize: 24, color: Colors.white),
              )),
        ],
      )),
    );
  }
}
class ItemListWidget extends StatefulWidget {
  final List<Item> itemList;
  final List<Item> selectedItems;
  final Function(List<Item>) onItemsSelected;

  const ItemListWidget({
    required this.itemList,
    required this.selectedItems,
    required this.onItemsSelected,
  });

  @override
  _ItemListWidgetState createState() => _ItemListWidgetState();
}

class _ItemListWidgetState extends State<ItemListWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item List'),
      ),
      body: ListView.builder(
        itemCount: widget.itemList.length,
        itemBuilder: (context, index) {
          final item = widget.itemList[index];
          bool isChecked = widget.selectedItems.contains(item);

          return ListTile(
            title: Text(item.itemName),
            leading: Checkbox(
              value: isChecked,
              onChanged: (value) {
                setState(() {
                  if (value!) {
                    widget.selectedItems.add(item);
                  } else {
                    widget.selectedItems.remove(item);
                  }
                  widget.onItemsSelected(widget.selectedItems);
                });
              },
            ),
          );
        },
      ),
    );
  }
}
