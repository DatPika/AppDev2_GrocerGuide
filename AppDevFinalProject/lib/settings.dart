import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

void main() {
  runApp(SettingsSetup());
}

class SettingsSetup extends StatelessWidget {
  const SettingsSetup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.lightGreen),
    // theme: ThemeData(
    //   colorScheme: ColorScheme.fromSwatch().copyWith(
    //     primary: _mainColor,
    //     secondary: _shadeColor,
    //   ),
    // ),
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
  ColorSwatch? _tempMainColor;
  Color? _tempShadeColor;
  ColorSwatch? _mainColor = Colors.lightGreen;
  Color? _shadeColor = Colors.lightGreen[300];

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
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.lightGreen),
        // theme: ThemeData(
        //   colorScheme: ColorScheme.fromSwatch().copyWith(
        //     primary: _mainColor,
        //     secondary: _shadeColor,
        //   ),
        // ),
        title: 'Settings Page',
        home: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('Settings'),
          ),
          body: Center(
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
                  child: const Text('Pick Theme'),
                )
              ],
            ),
          ),
        )
    );
  }
}
