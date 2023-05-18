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

    return Container(
      child: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<ItemsList>>(
              future: getAllItemsList(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  print(snapshot);
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (c, index) {
                        return CardBuild(list: snapshot.data![index]);
                      },
                    );
                  }
                }

                return Center(
                    child: CircularProgressIndicator(color: globals.mainColor));
              },
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              List<Item> selectedItems = [];
              List<Item> existingItems = [];
              List<Item> itemList = [];

              Future<void> loadItems() async {
                List<Item> items = await globals.db.allItems();
                setState(() {
                  existingItems = items;
                });
              }

              loadItems();


              TextEditingController storeName = TextEditingController();
              TextEditingController totalCost = TextEditingController();

              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Text("Add Store List"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: storeName,
                        decoration: InputDecoration(
                          labelText: 'Store List Title',
                        ),
                      ),

                      SizedBox(height: 10,),

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
                          itemListTitle: storeName.text,
                          type: "",
                          itemList: selectedItems,
                          totalCost: double.tryParse(totalCost.text) ?? 0.0,
                        );
                        globals.db.insertStoreList(StoresList(storeName: storeName.text.trim(), itemsList: itemList)).whenComplete(() {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, "MyHomePage");
                        });
                      },
                      child: Text('Save', style: TextStyle(color: globals.mainColor),),
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
            child: Text("Add new Store"),
          )

        ],
      ),

    );
  }
}

class ListDetails extends StatefulWidget {
  final ItemsList itemsList;
  const ListDetails({Key? key, required this.itemsList}) : super(key: key);

  @override
  State<ListDetails> createState() => _ListDetailsState();
}

class _ListDetailsState extends State<ListDetails> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


class CardBuild extends StatefulWidget {
  final ItemsList list;
  const CardBuild({Key? key, required this.list}) : super(key: key);

  @override
  State<CardBuild> createState() => _CardBuildState();
}

class _CardBuildState extends State<CardBuild> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ExpansionTile(
            textColor: globals.mainColor,
            iconColor: globals.mainColor,
            leading: Icon(Icons.list_alt_outlined),
            title: Text(
              widget.list.itemListTitle,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            initiallyExpanded: _isExpanded,
            onExpansionChanged: (expanded) {
              setState(() {
                _isExpanded = expanded;
              });
            },
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.list.itemList.length,
                itemBuilder: (context, index) {
                  final item = widget.list.itemList[index];
                  return ListTile(
                    leading: Text(
                      '${index + 1}.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    title: Text(
                      "${item.itemName}: " + "\$" + "${item.itemCost}",
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  'Total Price: \$${widget.list.totalCost.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  ElevatedButton(
                      onPressed: () async{
                        List<Item> selectedItems = [];
                        List<Item> existingItems = widget.list.itemList;
                        List<Item> itemList = [];

                        Future<void> loadItems() async {
                          List<Item> items = await globals.db.allItems();
                          setState(() {
                            existingItems = items;
                          });
                        }

                        loadItems();


                        TextEditingController storeName = TextEditingController(text: widget.list.itemListTitle);
                        TextEditingController totalCost = TextEditingController();

                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text("Add List"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: storeName,
                                  decoration: InputDecoration(
                                    labelText: 'List Title',
                                  ),
                                ),

                                SizedBox(height: 10,),

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
                                    itemListTitle: storeName.text,
                                    type: "",
                                    itemList: selectedItems,
                                    totalCost: double.tryParse(totalCost.text) ?? 0.0,
                                  );
                                  globals.db.insertStoreList(StoresList(storeName: storeName.text.trim(), itemsList: itemList)).whenComplete(() {
                                    Navigator.pop(context);
                                    Navigator.pushNamed(context, "MyHomePage");
                                  });
                                },
                                child: Text('Save', style: TextStyle(color: globals.mainColor),),
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
                      child: Text("Edit")
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text("Are you sure you want to delete"),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  globals.db.deleteItemsList(widget.list.itemListTitle);
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
                      child: Text("Delete")
                  ),
                ],
              )
            ],
          ),
        ],
      ),
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
          backgroundColor: globals.mainColor,
          title: Text('Item List'),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.itemList.length,
                itemBuilder: (context, index) {
                  final item = widget.itemList[index];
                  bool isChecked = widget.selectedItems.contains(item);

                  return ListTile(
                    title: Text(item.itemName),
                    leading: Checkbox(
                      activeColor: globals.mainColor,
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
            ),
            ElevatedButton(
                onPressed: () {
                  addNewItem(context);
                },
                child: Text("Add new Item")
            )
          ],
        )
    );
  }
}

void addNewItem(BuildContext context) {
  TextEditingController name = TextEditingController();
  TextEditingController type = TextEditingController();
  TextEditingController cost = TextEditingController();

  showDialog(context: context, builder: (BuildContext context) => new AlertDialog(
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
                if (double.parse(cost.text) > 0){
                  globals.db.createItem(Item(itemName: name.text, itemType: type.text, itemCost: double.parse(cost.text)));
                }
                else{
                  globals.db.createItem(Item(itemName: name.text, itemType: type.text, itemCost: 0.0));
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
