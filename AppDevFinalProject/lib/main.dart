import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Model.dart';
import 'dbhelper.dart';
import 'globals.dart' as globals;
import './settings.dart';
import './home.dart';
import './items.dart';
import './lists.dart';
import './recipies.dart';
import './stores.dart';
import './cart.dart';

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
        primarySwatch: Colors.green,
        shadowColor: Colors.lightGreen
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          if (snapshot.hasData){
            return MyHomePage();
          } else{
            print('There\'s been an error in in loading of the data');
            Navigator.of(context).pop;
            return Login();
          }
        },
      ),
    );;
  }
}

//The default page, not ACTUAL home page
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

        title: Text('Grocer Guide', style: TextStyle(
            fontFamily: globals.fontFamily,
            fontSize: 35,
            fontWeight: FontWeight.bold),),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: globals.mainColor,
        currentIndex: _currentIndex,
        onTap: onTabTapped,
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
                          fontFamily: globals.fontFamily,
                          fontSize: 40,
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
                          fontFamily: globals.fontFamily,
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
                                  style: TextStyle(fontFamily: globals.fontFamily, fontSize: 24),
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
                                fontFamily: globals.fontFamily,
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
                      'Join Grocer Guide',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: globals.fontFamily,
                          fontSize: 40,
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
                                  style: TextStyle(fontFamily: globals.fontFamily, fontSize: 24),
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
                                fontFamily: globals.fontFamily,
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




