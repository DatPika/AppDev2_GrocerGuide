import 'package:flutter/material.dart';

void main() {
  runApp(ListsSetup());
}

class ListsSetup extends StatelessWidget {
  const ListsSetup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.lightGreen
        ),
        title: 'Lists Page',
        home: Lists()
    );
  }
}

class Lists extends StatefulWidget {
  const Lists({Key? key}) : super(key: key);

  @override
  State<Lists> createState() => _ListsState();
}

class _ListsState extends State<Lists> {
  @override

  //TODO: implement getting the lists
  final lists = [];

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Lists'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Card(
              child: Column(
                children: <Widget>[
                  Text('List Name'),
                  Column(
                    children: <Widget>[
                      //TODO: add condition that allows for limited amount of items shown
                      Text('Item1'),
                      Text('Item2'),
                      Text('Item3'),
                      Text('Item4'),
                    ],
                  )
                ],
              ),
            ),
            Card(
              child: Column(
                children: <Widget>[
                  Text('List Name 2'),
                  Column(
                    children: <Widget>[
                      //TODO: add condition that allows for limited amount of items shown
                      Text('Item1'),
                      Text('Item2'),
                      Text('Item3'),
                      Text('Item4'),
                      Text('Item5'),
                      Text('Item6'),
                      Text('Item7'),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _buildListCard extends StatelessWidget {
  const _buildListCard({Key? key}) : super(key: key);

  @override

  //TODO: implement getting the items
  static const items = [];

  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Text('List Name'),
          Column(
            children: <Widget>[
              //TODO: add condition that allows for limited amount of items shown
              // items.forEach((element) {
              //   _buildItem(item: element);
              // })
            ],
          )
        ],
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
