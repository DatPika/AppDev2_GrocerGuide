import 'package:flutter/material.dart';

void main() {
  runApp(ListSetup());
}

class ListSetup extends StatelessWidget {
  const ListSetup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.lightGreen
        ),
        title: 'List Page',
        home: List()
    );
  }
}

class List extends StatefulWidget {
  const List({Key? key}) : super(key: key);

  @override
  State<List> createState() => _ListState();
}

class _ListState extends State<List> {
  @override

  //TODO: implement getting the list
  final list = [];

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        //TODO: add list name instead of just 'List'
        title: Text('List'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            list.forEach((element) {
              _buildItem(item: element);
            })
          ],
        ),
      ),
    );
  }
}

class _buildItem extends StatelessWidget {
  final item;

  const _buildItem({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('- ${item}');
  }
}