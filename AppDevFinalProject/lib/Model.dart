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
  final double totalCost;

  ItemsList({required this.type, required this.itemListTitle,required this.itemList,required this.totalCost});

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

  RecipiesList({required String type, required String itemListTitle,required List<Item> itemList,required double totalCost, required this.imageId,required this.instructions})
      : super(type: type, itemListTitle: itemListTitle, itemList: itemList, totalCost: totalCost);

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

  StoresList({required String type, required String itemListTitle,required List<Item> itemList,required double totalCost, required this.storeName})
      : super(type: type, itemListTitle: itemListTitle, itemList: itemList, totalCost: totalCost);

  Map<String, dynamic> toJson() => {
    'type' : type,
    'itemListTitle' : itemListTitle,
    'itemList' : itemList.map((e) => e.toJson()).toList(),
    'totalCost' : totalCost,
    'storeName' : storeName
  };
}
