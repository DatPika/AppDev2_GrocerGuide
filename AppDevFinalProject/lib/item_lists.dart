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
                  icon: Icon(Icons.arrow_back)),
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
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text("Done"),
            )
          ],
        ));
  }
}
