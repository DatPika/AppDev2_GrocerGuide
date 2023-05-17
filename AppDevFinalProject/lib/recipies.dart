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
  CollectionReference recipeCollection =
      globals.db.firestore.collection('recipiesList');
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
    ));
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
