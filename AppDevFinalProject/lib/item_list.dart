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
  void updateQuantity(Item item, int quantity) {
    setState(() {
      item.quantity = quantity;
      int index = widget.selectedItems.indexWhere((selectedItem) =>
          selectedItem.itemName == item.itemName &&
          selectedItem.itemType == item.itemType);

      if (index != -1) {
        // If the item already exists, update its quantity
        widget.selectedItems[index] = item;
      } else {
        // If the item is not found, add it to selectedItems
        widget.selectedItems.add(item);
      }
    });
  }

  void initState() {
    super.initState();
    widget.selectedItems.forEach((element) {
      print(element.itemName);
    });
    // List<Item> bob = widget.selectedItems;
    // widget.selectedItems.clear();
    // widget.selectedItems.addAll(bob);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: globals.mainColor,
          title: Text('Select Items'),
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
                    subtitle: Text('Quantity: ${item.quantity}'),
                    leading: Checkbox(
                      activeColor: globals.mainColor,
                      value: widget.selectedItems.contains(item),
                      //can be isCheched
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
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            if (item.quantity > 1) {
                              updateQuantity(item, item.quantity - 1);
                            }
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            updateQuantity(item, item.quantity + 1);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Done"))
          ],
        ));
  }
}
