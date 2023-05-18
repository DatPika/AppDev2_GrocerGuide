import 'package:flutter/material.dart';
import 'Model.dart';
import './item_list.dart';
import 'globals.dart' as globals;

class ItemListsWidget extends StatefulWidget {
  final List<ItemsList> itemLists;
  ItemsList? selectedList;
  Function(ItemsList) onListSelected;

  ItemListsWidget({
    required this.itemLists,
    this.selectedList,
    required this.onListSelected,
  });

  @override
  _ItemListsWidgetState createState() => _ItemListsWidgetState();
}

class _ItemListsWidgetState extends State<ItemListsWidget> {
  List<Item> itemList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: globals.mainColor,
          title: Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context, widget.selectedList);
                  },
                  icon: Icon(Icons.arrow_back)
              ),
              Text('Item Lists'),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.itemLists.length,
                itemBuilder: (context, index) {
                  final list = widget.itemLists[index];

                  return ListTile(
                    title: Text(list.itemListTitle),
                    leading: SizedBox(
                      width: 100,
                      child: RadioListTile(
                        groupValue: widget.selectedList,
                        activeColor: globals.mainColor,
                        value: list,
                        onChanged: (value) {
                          setState(() {
                            widget.selectedList = value as ItemsList?;
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                List<Item> selectedItems = [];
                List<Item> existingItems = [];

                Future<void> loadItems() async {
                  List<Item> items = await globals.db.allItems();
                  setState(() {
                    existingItems = items;
                  });
                }

                loadItems();

                TextEditingController itemListTitle = TextEditingController();
                TextEditingController type = TextEditingController();
                TextEditingController totalCost = TextEditingController();

                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Text("Add new List"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: itemListTitle,
                          decoration: InputDecoration(
                            labelText: 'List Title',
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: type,
                          decoration: InputDecoration(
                            labelText: 'List Type',
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () async {
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
                        child: Text(
                          'Save',
                          style: TextStyle(color: globals.mainColor),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: globals.mainColor),
                        ),
                      ),
                    ],
                  ),
                );
              },
              child: Text("Add new List"),
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
