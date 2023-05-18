import 'package:flutter/material.dart';
import 'Model.dart';
import 'globals.dart' as globals;

class ItemListsWidget extends StatefulWidget {
  final List<ItemsList> itemLists;
  var selectedList;
  final Function(ItemsList) onListSelected;

  ItemListsWidget({
    required this.itemLists,
    this.selectedList,
    required this.onListSelected,
  });

  @override
  _ItemListsWidgetState createState() => _ItemListsWidgetState();
}

class _ItemListsWidgetState extends State<ItemListsWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: globals.mainColor,
          title: Text('Item Lists'),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.itemLists.length,
                itemBuilder: (context, index) {
                  final list = widget.itemLists[index];
                  bool isChecked = (widget.selectedList == list);

                  return ListTile(
                    title: Text(list.itemListTitle),
                    leading: SizedBox(
                      width: 100,
                      child: RadioListTile(
                        groupValue: widget.itemLists,
                        activeColor: globals.mainColor,
                        value: list.itemList,
                        onChanged: (value) {
                          setState(() {
                            if (isChecked) {
                              widget.selectedList = list;
                            }
                            widget.onListSelected(widget.selectedList);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  addNewList(context);
                },
                child: Text("Add new List")
            )
          ],
        )
    );
  }
}

void addNewList(BuildContext context) {
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