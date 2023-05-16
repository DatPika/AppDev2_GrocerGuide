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
  CollectionReference itemColloction = globals.db.firestore.collection('itemsList');
  late Stream<QuerySnapshot> itemStream;

  Future<List<ItemsList>> getAllItemsList() async {
    return await globals.db.allItemsList();
  }

  @override
  void initState() {
    super.initState();
    itemStream = itemColloction.snapshots();
  }
  @override
  Widget build(BuildContext context) {
    itemColloction.get();
    itemColloction.snapshots();
    return Scaffold(
      body: Center(
          child: Column(
            children: [
              Expanded(
                  child: FutureBuilder<List<ItemsList>>(
                    future: getAllItemsList(),
                    builder: (context, snapshot){
                      if(snapshot.connectionState == ConnectionState.done){
                        print(getAllItemsList());
                        if (snapshot.hasData){
                          print(getAllItemsList());
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (c, index) {
                              print(snapshot.data![index].itemListTitle);
                              return Column(
                                children: [
                                  ListTile(
                                    iconColor: globals.mainColor,
                                    tileColor: globals.mainColor.withOpacity(0.1),
                                    title: Text("Name: ${snapshot.data![index].itemListTitle}"),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(snapshot.data![index].type),
                                        Text(snapshot.data![index].totalCost.toString()),
                                      ],
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                            },
                                            icon: Icon(Icons.edit)
                                        ),

                                        IconButton(
                                            onPressed: () {
                                              globals.db.deleteItemsList(snapshot.data![index].itemListTitle);
                                              Navigator.pop(context);  // pop current page
                                              Navigator.pushNamed(context, "MyHomePage");
                                            },
                                            icon: Icon(Icons.delete)
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              );
                            },
                          );
                        }
                      }

                      return Center(child: CircularProgressIndicator(color: globals.mainColor,));
                    },
                  )
              ),

              ElevatedButton(
                  style: ButtonStyle(),
                  onPressed: (){

                  },
                  child: Text(
                    'Add List',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  )),
            ],
          )
      ),
    );
  }
}