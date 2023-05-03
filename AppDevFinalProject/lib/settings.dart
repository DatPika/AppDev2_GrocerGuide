import 'package:flutter/material.dart';

void main() {
  runApp(SettingsSetup());
}

class SettingsSetup extends StatelessWidget {
  const SettingsSetup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightGreen
      ),
      title: 'Settings Page',
      home: Settings()
    );
  }
}

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Settings'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            //Picking a color theme
            //TODO: implement flutter_colorpicker
            Container(
              child: Text(
                'Pick your color theme'
              )
            ),
            //Picking type(s) of measurement
            //TODO: check if really needed feature
            Container(
              child: Text(
                'Pick your prefered measurements'
              ),
            )
          ],
        ),
      ),
    );
  }
}
