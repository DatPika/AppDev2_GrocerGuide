

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Model.dart';
import 'dbhelper.dart';
import './settings.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'globals.dart' as globals;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project',
      debugShowCheckedModeBanner: false,
      color: globals.mainColor,
      theme: ThemeData(
        primarySwatch: Colors.green
        //fontFamily: 'Inspiration'
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          if (snapshot.hasData){
            return MyHomePage();
          } else{
            print('hello');
            Navigator.of(context).pop;
            return Login();
          }
        },
      ),
    );;
  }
}



class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    HomePage(),
    ItemsPage(),
    ListsPage(),
    RecipiesPage(),
    StoresListsPage(),
    CartList(),
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
        centerTitle: true,
        backgroundColor: globals.mainColor,

        title: Text('Grocelery', style: TextStyle(
            fontFamily: 'Inspiration',
            fontSize: 35,
            fontWeight: FontWeight.bold),),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: globals.mainColor,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home_outlined,
                color: Colors.grey,
                size: 30,
              ),
              activeIcon: Icon(Icons.home, color: globals.mainColor, size: 35),
              label: 'Home'),

          BottomNavigationBarItem(
              icon: Icon(
                Icons.emoji_food_beverage,
                color: Colors.grey,
                size: 30,
              ),
              activeIcon: Icon(Icons.emoji_food_beverage_outlined, color: globals.mainColor, size: 35),
              label: 'Items'),

          BottomNavigationBarItem(
              icon: Icon(
                Icons.list,
                color: Colors.grey,
                size: 30,
              ),
              activeIcon: Icon(Icons.list_alt_outlined, color: globals.mainColor, size: 35),
              label: 'Lists'),

          BottomNavigationBarItem(
              icon: Icon(
                Icons.dinner_dining,
                color: Colors.grey,
                size: 30,
              ),
              activeIcon: Icon(Icons.dinner_dining_outlined, color: globals.mainColor, size: 35),
              label: 'Recipies'),

          BottomNavigationBarItem(
              icon: Icon(
                Icons.store,
                color: Colors.grey,
                size: 30,
              ),
              activeIcon: Icon(Icons.store_outlined, color: globals.mainColor, size: 35),
              label: 'Stores'),

          BottomNavigationBarItem(
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.grey,
                size: 30,
              ),
              activeIcon: Icon(Icons.shopping_cart_outlined, color: globals.mainColor, size: 35),
              label: 'My Cart'),

          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings_outlined,
              color: Colors.grey,
              size: 30,
            ),
            label: 'Settings',
            activeIcon: Icon(Icons.settings, color: globals.mainColor, size: 35),
          )
        ],
      ),
    );
  }
}

//Home Page
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [Text("It's nice to see you again Bob!")],
    ));
  }
}

//Profile Page
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile page"),
        backgroundColor: globals.mainColor,
      ),
      body:       Center(
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
            // Text(
            //   'Bob Beans',
            //   style: TextStyle(fontSize: 55, fontWeight: FontWeight.bold, fontFamily: 'Playball',),
            // ),
            Text(FirebaseAuth.instance.currentUser!.email.toString(), style: TextStyle(fontSize: 20)),
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
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(primary: Colors.red),
              child: Text(
                'Sign out',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemsPage extends StatefulWidget {
  const ItemsPage({Key? key}) : super(key: key);

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  CollectionReference itemColloction = globals.db.firestore.collection('itmes');
  late Stream<QuerySnapshot> itemStream;

  Future<List<Item>> getAllItem() async {
    return await globals.db.allItem();
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
              child: FutureBuilder<List<Item>>(
                future: getAllItem(),
                builder: (context, snapshot){
                  if(snapshot.connectionState == ConnectionState.done){
                    if (snapshot.hasData){
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (c, index) {
                          return Column(
                            children: [
                              ListTile(
                                iconColor: globals.mainColor,
                                tileColor: globals.mainColor.withOpacity(0.1),
                                title: Text("Name: ${snapshot.data![index].itemName}"),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(snapshot.data![index].itemType),
                                    Text(snapshot.data![index].itemCost.toString()),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          print(snapshot.data![index].itemCost);
                                        },
                                        icon: Icon(Icons.edit)
                                    ),

                                    IconButton(
                                        onPressed: () {
                                          globals.db.deleteItem(snapshot.data![index].itemName);
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
                  return Center(child: CircularProgressIndicator());
                },
              )
            ),

            ElevatedButton(
              style: ButtonStyle(),
                onPressed: () async{
                  TextEditingController name = TextEditingController();
                  TextEditingController type = TextEditingController();
                  TextEditingController cost = TextEditingController();

                  showDialog(context: context, builder: (BuildContext context) => new AlertDialog(
                    title: Text("Add new Item"),
                    content: Container(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(20),
                            child: TextField(
                              controller: name,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Item Name'
                              ),

                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(20),
                            child: TextField(
                              controller: type,
                              decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: 'Item Type'
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(20),
                            child: TextField(
                              controller: cost,
                              decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: 'Item Cost'
                              ),

                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      ElevatedButton(
                          onPressed: () {
                            if (double.parse(cost.text) > 0){
                              globals.db.createItem(Item(itemName: name.text, itemType: type.text, itemCost: double.parse(cost.text)));
                            }
                            else{
                              globals.db.createItem(Item(itemName: name.text, itemType: type.text));
                            }
                            Navigator.of(context).pop();
                          },
                          child: Text('Add')
                      )
                    ],
                  )
                  );
                },
                child: Text(
                  'Add Item',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                )),
          ],
        )
      ),
    );
  }
}

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

class RecipiesPage extends StatefulWidget {
  const RecipiesPage({Key? key}) : super(key: key);

  @override
  State<RecipiesPage> createState() => _RecipiesPageState();
}

class _RecipiesPageState extends State<RecipiesPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class StoresListsPage extends StatefulWidget {
  const StoresListsPage({Key? key}) : super(key: key);

  @override
  State<StoresListsPage> createState() => _StoresListsPageState();
}

class _StoresListsPageState extends State<StoresListsPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class CartList extends StatefulWidget {
  const CartList({Key? key}) : super(key: key);

  @override
  State<CartList> createState() => _CartListState();
}

class _CartListState extends State<CartList> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


//Settings Page
class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var _tempMainColor;
  var _tempShadeColor;
  var _mainColor = Colors.lightGreen;
  var _shadeColor = Colors.lightGreen[300];

  void _showProfile(){
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()));

  }

  void _openDialog(String title, Widget content) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          title: Text(title),
          content: content,
          actions: [
            TextButton(
              child: Text('CANCEL'),
              onPressed: Navigator.of(context).pop,
            ),
            TextButton(
              child: Text('SUBMIT'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() => _mainColor = _tempMainColor);
                setState(() => _shadeColor = _tempShadeColor);
                print('Main Color: $_mainColor\nShade Color: $_shadeColor');
                globals.mainColor =  _shadeColor!;
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }

  void _openColorPicker() async {
    _openDialog(
      "Color picker",
      MaterialColorPicker(
        selectedColor: _shadeColor,
        onColorChange: (color) => setState(() => _tempShadeColor = color),
        onMainColorChange: (color) => setState(() => _tempMainColor = color),
        onBack: () => print("Back button pressed"),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          //Picking a color theme
          Container(
              margin: EdgeInsets.only(top: 50),
              child: Text(
                  'Pick your color theme'
              )
          ),
          OutlinedButton(
            onPressed: _openColorPicker,
            child: Text('Pick Theme', style: TextStyle(color: globals.mainColor)),
          ),

          SizedBox(
            height: 20,
          ),

          OutlinedButton(
              onPressed: () {
                _showProfile();
              },
              child: Text('Profile', style: TextStyle(color: globals.mainColor)),
          )
        ],
      ),
    );
  }
}

// Navigation Bar

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  TextEditingController usercontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.all(50.0),
          child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      'Welcome to Grocer Guide',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Inspiration',
                          fontSize: 65,
                          fontWeight: FontWeight.bold),
                    ),
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(30),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      controller: usercontroller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        fillColor: Colors.black,
                        labelText: 'Username',
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (user) => user != null && user == ''
                          ? 'Enter username'
                          : null,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      controller: passwordcontroller,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        fillColor: Colors.black,
                        labelText: 'Password',
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (password) => password != null && password == ''
                          ? 'Enter password'
                          : null,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => Home(username: username),
                      //   ),
                      // );
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 20,
                          fontFamily: 'Playball',
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Center(
                          child: SizedBox(
                            height: 50,
                            width: 300,
                            child: ElevatedButton(
                                onPressed: () async{
                                  final isValid = formKey.currentState!.validate();
                                  if (isValid){

                                    var isGood = await globals.db.signIn(usercontroller, passwordcontroller, context);
                                    if (isGood){
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(builder: (context) => MyHomePage()),
                                      );
                                    }
                                    else{
                                      usercontroller.text = "";
                                      passwordcontroller.text = "";
                                      final snackBar = SnackBar(content: Text("either the email or password is incorrect"), backgroundColor: Colors.red,);

                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    }
                                  }
                                },
                                child: Text(
                                  'Sign in',
                                  style: TextStyle(fontFamily: 'Playball', fontSize: 24),
                                )),
                          ))),
                  Padding(
                      padding: EdgeInsets.all(1),
                      child: Center(
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop;

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Register(),
                              ),
                            );
                          },
                          child: Text(
                            'Click to create an account!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 20,
                                fontFamily: 'Playball',
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      )),
                ],
              )),
        ),
      )
    ));

  }

  // void checkPassword(TextEditingController id, TextEditingController password) async{
  //   final db = new DatabaseHelper();
  //   var user = await globals.db.firestore.collection('users').doc(id.text).get();
  //
  //   if (user.exists) {
  //     String data = globals.db.readUser(id.text).toString();
  //     Map<String, dynamic> valueMap = json.decode(data);
  //     User user = new User.fromJson(valueMap);
  //     var pass = user.password;
  //
  //     if(pass == password.text){
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => MyHomePage(),
  //         ),
  //       );
  //     }
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Invalid Credentials')),
  //     );
  //   }
  // }
}

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formKey = GlobalKey<FormState>();
  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.all(50.0),
        child: Center(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      'Join to Grocelery',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Inspiration',
                          fontSize: 75,
                          fontWeight: FontWeight.bold),
                    ),
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(30),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      controller: usernamecontroller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        fillColor: Colors.black,
                        labelText: 'Username',
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (user) => user != null && user == ''
                          ? 'Enter username'
                          : null,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      controller: emailcontroller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        fillColor: Colors.black,
                        labelText: 'Email',
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (email) => email != null && !EmailValidator.validate(email)
                          ? 'Enter a valid email'
                          : null,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      controller: passwordcontroller,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        fillColor: Colors.black,
                        labelText: 'Password',
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (password) => password != null && password.length < 6
                          ? 'Enter min. 6 characters'
                          : null,
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Center(
                          child: SizedBox(
                            height: 50,
                            width: 300,
                            child: ElevatedButton(
                                onPressed: () async{
                                  final isValid = formKey.currentState!.validate();
                                  if (isValid){
                                    var isGood = await globals.db.signUp(usernamecontroller, emailcontroller, passwordcontroller, context);
                                    if (isGood){
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(builder: (context) => Login()),
                                      );
                                    }
                                    else{
                                      usernamecontroller.text = "";
                                      emailcontroller.text = "";
                                      passwordcontroller.text = "";
                                    }
                                  }
                                },
                                child: Text(
                                  'Register',
                                  style: TextStyle(fontFamily: 'Playball', fontSize: 24),
                                )),
                          ))),
                  Padding(
                      padding: EdgeInsets.all(1),
                      child: Center(
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => Login()),
                            );
                          },
                          child: Text(
                            'Already have an account?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 20,
                                fontFamily: 'Playball',
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      )),
                ],
              ),
            )
        ),
      ),
    ));
  }
}


