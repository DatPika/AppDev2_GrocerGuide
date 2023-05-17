import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Model.dart';
import 'globals.dart' as globals;


class RecipiesPage extends StatefulWidget {
  const RecipiesPage({Key? key}) : super(key: key);

  @override
  State<RecipiesPage> createState() => _RecipiesPageState();
}

class _RecipiesPageState extends State<RecipiesPage> {

  CollectionReference recipeCollection = globals.db.firestore.collection('recipiesList');
  late Stream<QuerySnapshot> itemStream;

  Future<List<RecipiesList>> getAllRecipe() async {
    print("bob");
    return await globals.db.allRecipies();
  }

  @override
  void initState() {
    super.initState();
    itemStream = recipeCollection.snapshots();

  }

  @override
  Widget build(BuildContext context) {
    recipeCollection.get();
    recipeCollection.snapshots();
    return Scaffold(
      body: FutureBuilder<List<RecipiesList>>(
        future: getAllRecipe(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            print(snapshot);
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (c, index) {
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Image.network(
                          snapshot.data![index].imageURL,
                          width: 400,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                        Padding(
                            padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Text(
                                snapshot.data![index].title,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                snapshot.data![index].description,
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                },
                                child: const Text('More'),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            }
          }

          return Center(
              child: CircularProgressIndicator(color: globals.mainColor));
        },
      )
    );
  }
}
