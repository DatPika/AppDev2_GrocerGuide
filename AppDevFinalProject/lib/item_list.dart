import 'package:flutter/material.dart';
import 'Model.dart';
import 'globals.dart' as globals;

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

