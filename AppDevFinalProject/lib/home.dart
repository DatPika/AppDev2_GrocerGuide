import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Model.dart';
import './globals.dart' as globals;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ItemsList? selectedItemsList;
  List<Item> items = [];
  List<bool> checkedItems = [];

  @override
  void initState() {
    super.initState();
    // Load the initial items list when the widget is initialized
    loadItemsList(null); // Pass null as the initial value
  }

  Future<void> loadItemsList(ItemsList? itemsList) async {
    if (itemsList != null) {
      setState(() {
        selectedItemsList = itemsList;
        items = selectedItemsList!.itemList;
        checkedItems = List<bool>.filled(items.length, false);
      });
    }
  }

  Future<List<ItemsList>> getAllItemsList() async {
    return await globals.db.allItemsList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: Text(
              "Welcome back, ${FirebaseAuth.instance.currentUser!.displayName}!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: globals.mainColor),
          ),
          Container(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              "Recent lists!",
              style: TextStyle(
                fontSize: 20,
              ),
              textAlign: TextAlign.start,
            ),
            alignment: Alignment.topLeft,
          ),
          MyDropdown(onOptionSelected: loadItemsList),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isChecked = checkedItems[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text('${index + 1}'),
                  ),
                  title: Text(item.itemName),
                  trailing: Checkbox(
                    value: isChecked,
                    onChanged: (bool? newValue) {
                      setState(() {
                        checkedItems[index] = newValue ??
                            false; // Update the checked state for the item
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MyDropdown extends StatefulWidget {
  final Function(ItemsList) onOptionSelected; // Accept a callback function

  MyDropdown({required this.onOptionSelected});

  @override
  _MyDropdownState createState() => _MyDropdownState();
}

class _MyDropdownState extends State<MyDropdown> {
  int selectedOptionIndex = 0;
  List<ItemsList> dropdownOptions = [];

  Future<List<ItemsList>> getAllItemsList() async {
    return await globals.db.allItemsList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ItemsList>>(
      future: getAllItemsList(),
      builder: (context, snapshot) {
        try {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return DropdownButton<int>(
              value: selectedOptionIndex,
              items: [
                DropdownMenuItem<int>(
                  value: 0,
                  child: Text('Loading...'),
                ),
              ],
              onChanged: (int? newIndex) {
                setState(() {
                  selectedOptionIndex = newIndex!;
                });
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            dropdownOptions = snapshot.data!;
            return DropdownButton<int>(
              value: selectedOptionIndex,
              items: dropdownOptions.asMap().entries.map((entry) {
                final index = entry.key;
                final option = entry.value;
                return DropdownMenuItem<int>(
                  value: index,
                  // Use the index as the value instead of duplicate values
                  child: Text(option.itemListTitle),
                );
              }).toList(),
              onChanged: (int? newIndex) {
                setState(() {
                  selectedOptionIndex = newIndex!;
                });
                widget.onOptionSelected(dropdownOptions[
                    selectedOptionIndex]); // Call the callback function
              },
            );
          }
        } catch (e, stackTrace) {
          return DropdownButton(items: null, onChanged: null);
        }
      },
    );
  }
}
