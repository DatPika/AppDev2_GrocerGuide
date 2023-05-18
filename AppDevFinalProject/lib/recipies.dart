import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Model.dart';
import './item_lists.dart';
import 'globals.dart' as globals;

class RecipiesPage extends StatefulWidget {
  const RecipiesPage({Key? key}) : super(key: key);

  @override
  State<RecipiesPage> createState() => _RecipiesPageState();
}

class _RecipiesPageState extends State<RecipiesPage> {
  CollectionReference recipeCollection =
      globals.db.firestore.collection('recipiesList');
  late Stream<QuerySnapshot> itemStream;
  List<ItemsList> existingLists = [];
  List<ItemsList> itemLists = [];

  Future<List<RecipiesList>> getAllRecipe() async {
    return await globals.db.allRecipies();
  }

  @override
  void initState() {
    super.initState();
    itemStream = recipeCollection.snapshots();

    Future<void> loadItems() async {
      List<ItemsList> lists = await globals.db.allItemsList();
      setState(() {
        existingLists = lists;
      });
    }

    loadItems();
  }

  @override
  Widget build(BuildContext context) {
    recipeCollection.get();
    recipeCollection.snapshots();
    return Scaffold(
        body: Center(
          child: Column(
            children: [
              Expanded(
                child: FutureBuilder<List<RecipiesList>>(
                  future: getAllRecipe(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
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
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => RecipeDetailPage(
                                                  recipe: snapshot.data![index],
                                                ),
                                              ),
                                            );
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
              ),
              ElevatedButton(
                style: ButtonStyle(),
                onPressed: () async {
                  ItemsList? selectedList;
                  List<ItemsList> existingLists = [];
                  ItemsList list;

                  Future<void> loadLists() async {
                    List<ItemsList> lists = await globals.db.allItemsList();
                    setState(() {
                      existingLists = lists;
                    });
                  }

                  loadLists();

                  TextEditingController title = TextEditingController();
                  TextEditingController description = TextEditingController();
                  TextEditingController instructions = TextEditingController();
                  TextEditingController imageURL = TextEditingController(text: 'https://media-cldnry.s-nbcnews.com/image/upload/rockcms/2022-03/plant-based-food-mc-220323-02-273c7b.jpg');

                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: Text("Add Recipe"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: title,
                            decoration: InputDecoration(
                              labelText: 'Title',
                            ),
                          ),
                          TextField(
                            controller: description,
                            decoration: InputDecoration(
                              labelText: 'Desciption',
                            ),
                          ),
                          TextField(
                            controller: instructions,
                            decoration: InputDecoration(
                              labelText: 'Instructions',
                            ),
                          ),
                          TextFormField(
                            controller: imageURL,
                            decoration: InputDecoration(
                              labelText: 'Image URL',
                            ),
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                // Navigate to ItemListWidget and pass necessary data
                                selectedList = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ItemListsWidget(
                                      itemLists: existingLists,
                                      selectedList: selectedList ?? existingLists[0],
                                      onListSelected: (selectedList) {
                                        setState(() {
                                          list = selectedList;
                                        });
                                      },
                                    ),
                                  ),
                                );
                                print(selectedList!.itemListTitle);
                              },
                              child: Text("Select items list")
                          )
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            final recipe = RecipiesList(
                              title: title.text,
                              description: description.text,
                              imageURL: imageURL.text,
                              instructions: instructions.text,
                              itemsList: selectedList!
                            );
                            globals.db.createRecipiesList(recipe).whenComplete(() {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, "MyHomePage");
                            });
                          },
                          child: Text('Save', style: TextStyle(color: globals.mainColor),),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel', style: TextStyle(color: globals.mainColor),),
                        ),
                      ],
                    ),
                  );
                },
                child: Text(
                  'Add Recipe',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                )
              ),
            ],
          ),
        )
    );
  }
}

class RecipeDetailPage extends StatefulWidget {
  final RecipiesList recipe;

  const RecipeDetailPage({Key? key, required this.recipe}) : super(key: key);

  @override
  _RecipeDetailPageState createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  bool _isDescriptionExpanded = false;
  bool _isInstructionsExpanded = false;
  bool _isIngredientsExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: globals.mainColor,
        title: Text(widget.recipe.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image
            Image.network(
              widget.recipe.imageURL,
              fit: BoxFit.cover,
              height: 300,
            ),
            const SizedBox(height: 16),

            // Title
            Center(
              child: Text(
                widget.recipe.title,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Description
            ExpansionTile(
              leading: Icon(Icons.description),
              title: Text(
                'Description',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              initiallyExpanded: _isDescriptionExpanded,
              onExpansionChanged: (expanded) {
                setState(() {
                  _isDescriptionExpanded = expanded;
                });
              },
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    widget.recipe.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Instructions
            ExpansionTile(
              leading: Icon(Icons.list),
              // Add Icon
              title: Text(
                'Instructions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              initiallyExpanded: _isInstructionsExpanded,
              onExpansionChanged: (expanded) {
                setState(() {
                  _isInstructionsExpanded = expanded;
                });
              },
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    widget.recipe.instructions,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),

            //Ingredients
            ExpansionTile(
              leading: Icon(Icons.shopping_basket),
              // Add Icon
              title: Text(
                'Ingredients',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              initiallyExpanded: _isIngredientsExpanded,
              onExpansionChanged: (expanded) {
                setState(() {
                  _isIngredientsExpanded = expanded;
                });
              },
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.recipe.itemsList.itemList.length,
                  itemBuilder: (context, index) {
                    final item = widget.recipe.itemsList.itemList[index];
                    return ListTile(
                      leading: Text(
                        '${index + 1}.',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      title: Text(
                        item.itemName,
                        style: const TextStyle(fontSize: 16),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    'Total Price: \$${widget.recipe.itemsList.totalCost.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
