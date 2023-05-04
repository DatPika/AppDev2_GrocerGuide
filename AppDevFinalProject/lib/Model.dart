import 'dbhelper.dart';

class Item{
  final String itemName;
  final String itemType;
  double? itemCost = 0;

  Item({required this.itemName,required this.itemType, this.itemCost});

  Map<String, dynamic> toJson() => {
    'itemName' : itemName,
    'itemType' : itemType,
    'itemCost' : itemCost
  };
}

class ItemsList{
  final String type;
  final String itemListTitle;
  final List<Item> itemList;
  double totalCost = 0;

  _calculateTotalcost(){
    itemList.forEach((e) {
      if(e.itemCost != null){
        totalCost += double.parse(e.itemCost.toString());
      }
    });
  }
  ItemsList({required this.type, required this.itemListTitle,required this.itemList}){
    _calculateTotalcost();
  }

  Map<String, dynamic> toJson() => {

    'type' : type,
    'itemListTitle' : itemListTitle,
    'itemList' : itemList.map((e) => e.toJson()).toList(),
    'totalCost' : totalCost
  };
}

class RecipiesList extends ItemsList{
  final String imageId;
  final String instructions;

  RecipiesList({required String type, required String itemListTitle,required List<Item> itemList, required this.imageId,required this.instructions})
      : super(type: type, itemListTitle: itemListTitle, itemList: itemList);

  Map<String, dynamic> toJson() => {
    'type' : type,
    'itemListTitle' : itemListTitle,
    'itemList' : itemList.map((e) => e.toJson()).toList(),
    'totalCost' : totalCost,
    'imageId' : imageId,
    'instructions' : instructions
  };
}

class StoresList extends ItemsList {
  final String storeName;

  StoresList({required String type, required String itemListTitle,required List<Item> itemList, required this.storeName})
      : super(type: type, itemListTitle: itemListTitle, itemList: itemList);

  Map<String, dynamic> toJson() => {
    'type' : type,
    'itemListTitle' : itemListTitle,
    'itemList' : itemList.map((e) => e.toJson()).toList(),
    'totalCost' : totalCost,
    'storeName' : storeName
  };
}

class User {
  final String username;
  final String password;

  User({required this.username,required this.password});

  Map<String, dynamic> toJson() => {
    'username' : username,
    'password' : password,
  };
}
