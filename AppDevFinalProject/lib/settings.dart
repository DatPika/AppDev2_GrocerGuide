import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import './globals.dart' as globals;
import './main.dart';
import './profile.dart';

void main() {
  runApp(SettingsPage());
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
                globals.mainColor =  _mainColor!;
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