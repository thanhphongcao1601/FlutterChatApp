import 'package:chat_app/views/profilescreen.dart';
import 'package:flutter/material.dart';

import '../helper/authenticate.dart';
import '../services/auth.dart';
import 'chatscreen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  int _selectedIndex = 3;
  AuthMethods authMethods = AuthMethods();


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index){
        case 0:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatScreen()),
          );
          break;
        case 5:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfileScreen()),
          );
          break;
        case 2:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfileScreen()),
          );
          break;
        case 3:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SettingScreen()),
          );
          break;
      }

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[200],
        title: const Text('Demo Palo'),
        actions:[
          GestureDetector(
              onTap: (){
                authMethods.signOut();
                Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context)=> Authenticate()
                ));
              },
              child: Icon(Icons.exit_to_app_rounded)
          )
        ],
      ),
      body: Container(
        child: Text("Setting Screen"),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Messages',
            backgroundColor: Colors.brown[200],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud_rounded),
            label: 'Weather',
            backgroundColor: Colors.brown[200],
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Me',
            backgroundColor: Colors.brown[200],

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
            backgroundColor: Colors.brown[200],
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[600],
        onTap: _onItemTapped,
      ),
    );
  }
}

