import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dbhelper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// class _MyHomePageState extends State<MyHomePage> {
//   final db = new DatabaseHelper();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Flutter Firestore CRUD'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children:<Widget> [
//             ElevatedButton(onPressed: db.create(), child: Text('Create'),),
//             ElevatedButton(onPressed: db.read(), child: Text('Read'),),
//             ElevatedButton(onPressed: db.update(), child: Text('Update'),),
//             ElevatedButton(onPressed: db.delete(), child: Text('Delete'),),
//           ],
//         ),
//       ),
//     );
//   }

// }

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    HomePage(),
    ProfilePage(),
    SettingsPage(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grocelery'),
      ),
      drawer: NavigationDrawer(),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.green,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home_outlined,
                color: Colors.white,
                size: 30,
              ),
              activeIcon: Icon(Icons.home, color: Colors.white, size: 35),
              label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
              color: Colors.white,
              size: 30,
            ),
            label: 'Profile',
            activeIcon: Icon(Icons.person, color: Colors.white, size: 35),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings_outlined,
              color: Colors.white,
              size: 30,
            ),
            label: 'Settings',
            activeIcon: Icon(Icons.settings, color: Colors.white, size: 35),
          )
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [Text("It's nice to see you again Bob!")],
    ));
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            height: 320,
            width: 230,
            child: Icon(
              Icons.account_circle_rounded,
              size: 230,
            ),
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
            alignment: Alignment.center,
          ),
          Text(
            'Username',
            style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
          ),
          Text('emailheaha@gmail.com', style: TextStyle(fontSize: 20)),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text(
              'Update Profile',
              style: TextStyle(color: Colors.black),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(primary: Colors.red),
            child: Text(
              'Sign out',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('This is settings'),
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.green,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildHeader(context),
            buildMenuItems(context),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) => Material(
        color: Colors.green,
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => MyHomePage()));
          },
          child: Container(
            padding: EdgeInsets.only(
                top: 24 + MediaQuery.of(context).padding.top, bottom: 24),
            child: Column(
              children: [
                Text(
                  'Grocelery',
                  style: TextStyle(fontSize: 40, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      );

  Widget buildMenuItems(BuildContext context) => Container(
        color: Colors.green,
        padding: EdgeInsets.all(1),
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(
                Icons.location_on,
                color: Colors.white,
              ),
              onTap: () {},
              title: Text('Locations', style: TextStyle(color: Colors.white)),
              trailing: Icon(
                Icons.arrow_right_outlined,
                size: 30,
                color: Colors.white,
              ),
            ),
            Divider(
              color: Colors.black,
              thickness: 1,
            ),
            ListTile(
              leading: Icon(Icons.fastfood, color: Colors.white),
              onTap: () {},
              title: Text(
                'Ingredients',
                style: TextStyle(color: Colors.white),
              ),
              trailing: Icon(Icons.arrow_right_outlined,
                  size: 30, color: Colors.white),
            ),
            Divider(
              color: Colors.black,
              thickness: 1,
            ),
            ListTile(
              leading: Icon(
                Icons.receipt_long,
                color: Colors.white,
              ),
              onTap: () {},
              title: Text('Recipes', style: TextStyle(color: Colors.white)),
              trailing: Icon(Icons.arrow_right_outlined,
                  size: 30, color: Colors.white),
            ),
            Divider(
              color: Colors.black,
              thickness: 1,
            ),
          ],
        ),
      );
}

