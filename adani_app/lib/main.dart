import 'package:flutter/material.dart';  
import 'detect.dart';
import 'profile.dart';
import 'scaner.dart';

void main() => runApp(MyApp());  
 
class MyApp extends StatelessWidget {  
  @override  
  Widget build(BuildContext context) {  
    return const MaterialApp(  
      home: MyNavigationBar (),   
    );  
  }  
}
  
class MyNavigationBar extends StatefulWidget {  
  const MyNavigationBar ({Key? key}) : super(key: key);

  @override  
  _MyNavigationBarState createState() => _MyNavigationBarState();  
}  
  
class _MyNavigationBarState extends State<MyNavigationBar> {
  int _selectedIndex = 0;  
  static const List<Widget> _widgetOptions = <Widget>[  
    HomePage(),
    Detect_page(),  
    Profile(),  
  ];  
  
  void _onItemTapped(int index) {  
    setState(() {  
      _selectedIndex = index;  
    });  
  }  
  
  @override  
  Widget build(BuildContext context) {  
    return Scaffold(  
      appBar: AppBar(  
        title: const Text('Adani Product Proctor'),  
          backgroundColor: Colors.blue 
      ),  
      body: Center(  
        child: _widgetOptions.elementAt(_selectedIndex),  
      ),  
      bottomNavigationBar: BottomNavigationBar(  
        items: const <BottomNavigationBarItem>[  
          BottomNavigationBarItem(  
            icon: Icon(Icons.qr_code_scanner_rounded),  
            label: 'Scan',  
            backgroundColor: Colors.blue 
          ),  
          BottomNavigationBarItem(  
            icon: Icon(Icons.add_a_photo_outlined),  
            label: 'Detect',  
            backgroundColor: Colors.blue  
          ),  
          BottomNavigationBarItem(  
            icon: Icon(Icons.person),  
            label: 'Profile',
            backgroundColor: Colors.blue,  
          ),  
        ],  
        type: BottomNavigationBarType.shifting,  
        currentIndex: _selectedIndex,  
        selectedItemColor: Colors.black,  
        iconSize: 40,  
        onTap: _onItemTapped,  
        elevation: 5  
      ),  
    );  
  }  
}  