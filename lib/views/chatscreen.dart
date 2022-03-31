import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/conversation.dart';
import 'package:chat_app/views/profilescreen.dart';
import 'package:chat_app/views/search.dart';
import 'package:chat_app/views/settingscreen.dart';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../helper/helperfunctions.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();
  Stream? chatRoomStream;

  Widget chatRoomList(){
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("ChatRoom")
          .where("user",arrayContains: Constants.myName)
          .snapshots(),
      builder: (context,AsyncSnapshot snapshot){
        return snapshot.hasData ? ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context,index){
              return ChatRoomTile(snapshot.data.docs[index].data()["chatRoomid"]
                  //lay danh sach ban be tu chatRoomid
                  .toString().replaceAll("_", "").replaceAll(Constants.myName, ""),
                  snapshot.data.docs[index].data()["chatRoomid"],
                  snapshot.data.docs[index].data()["lastMess"]);
            }
        )
            : Container();
      }
    );
  }

  @override
  void initState() {
    getUserInfo();
    databaseMethods.getChatRooms(Constants.myName).then((value){
      setState(() {
        chatRoomStream = value;
      });
    });
    // TODO: implement initState
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference() as String;
    print("${Constants.myName} o chatscreen");
    setState(() {
    });
  }

  int _selectedIndex = 0;
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.brown[200],
        onPressed: () { Navigator.push(context, MaterialPageRoute(
            builder: (context) => SearchScreen())
        );},
        child: Icon(Icons.search),
      ),
      body: chatRoomList(),
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

class ChatRoomTile extends StatelessWidget {
  String userName;
  String chatRoomid;
  final lastMess;
  ChatRoomTile(this.userName,this.chatRoomid,this.lastMess);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context,
            MaterialPageRoute(builder: (context)=>ConversationScreen(chatRoomid))
        );
      },
      child: Container(
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
              height: 50,
              width: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
                borderRadius: BorderRadius.circular(50)
              ),
              child: Text("${userName.substring(0,1).toUpperCase()}"),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${userName}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                // Text("${lastMess}",
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width-80,
                      child: Text("${lastMess}",
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
