import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        //fontFamily: 'Inspiration'
      ),
      home: Login(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
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
        centerTitle: true,
        title: Text('Grocelery', style: TextStyle(
            fontFamily: 'Inspiration',
            fontSize: 35,
            fontWeight: FontWeight.bold),),
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
            'Bob Beans',
            style: TextStyle(fontSize: 55, fontWeight: FontWeight.bold, fontFamily: 'Playball',),
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

//Settings Page
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

// Navigation Bar
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
                  style: TextStyle(
                      fontFamily: 'Inspiration',
                      fontSize: 75,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
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
              title: Text('Locations',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Playball',
                      fontSize: 30)),
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
                style: TextStyle(
                    color: Colors.white, fontFamily: 'Playball', fontSize: 30),
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
              title: Text('Recipes',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Playball',
                      fontSize: 30)),
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

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              child: Text(
                'Welcome to Grocelery',
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
              child: TextField(
                controller: emailcontroller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  fillColor: Colors.black,
                  labelText: 'Email',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: passwordcontroller,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  fillColor: Colors.black,
                  labelText: 'Password',
                ),
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
                      onPressed: () {
                        checkPassword(emailcontroller, passwordcontroller);
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
    ));
  }

  void checkPassword(TextEditingController id, TextEditingController password) {
    String _username = 'Selihom';
    String _password = '1';

    if (_username == id.text && _password == password.text) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyHomePage(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid Credentials')),
      );
    }
  }
}

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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
              child: TextField(
                controller: usernamecontroller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  fillColor: Colors.black,
                  labelText: 'Username',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: emailcontroller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  fillColor: Colors.black,
                  labelText: 'Email',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: passwordcontroller,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  fillColor: Colors.black,
                  labelText: 'Password',
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.all(20.0),
                child: Center(
                    child: SizedBox(
                  height: 50,
                  width: 300,
                  child: ElevatedButton(
                      onPressed: () {},
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Login(),
                        ),
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
        )),
      ),
    ));
  }
}
