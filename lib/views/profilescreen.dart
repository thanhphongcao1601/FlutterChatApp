import 'dart:io';
import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/chatscreen.dart';
import 'package:chat_app/views/settingscreen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? image;
  String userAvatar = Constants.myAvatar;

  //ham bottom navigator
  int _selectedIndex = 2;
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

  Future<String> getUrlAvatar(String child) async {
    var ref = FirebaseStorage.instance.ref().child("userImages").child(child);
    String url = (await ref.getDownloadURL()).toString();
    print(url);
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     var imageTemp = await _picker.pickImage(source: ImageSource.gallery);
      //     setState((){
      //       image = imageTemp;
      //       //luu avatar vao storage
      //       FirebaseStorage.instance.ref().child("userImages").child("avatar-"+Constants.myEmail).putFile(File(image!.path));
      //       //lay duong dan cua avatar
      //       getUrlAvatar("avatar-"+Constants.myEmail).then((value){
      //         DatabaseMethods databaseMethods = DatabaseMethods();
      //         databaseMethods.setUrlAvatar(value,Constants.myEmail);
      //         Constants.myAvatar = value;
      //         userAvatar = value;
      //       });
      //     });
      //   }),
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.brown,
                      Colors.white,
                    ],
                  ),
                ),
                width: MediaQuery.of(context).size.width,
                // color: Colors.brown[200],
                child: Column(
                  children: [
                    const SizedBox(height: 30,),
                    image==null ?
                    Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(150),
                                child: (userAvatar=='null') ?
                                Image.asset("assets/images/avatar_null.png", height: 150,width: 150,fit: BoxFit.cover,)
                                    : Image.network(userAvatar, height: 150,width: 150,fit: BoxFit.cover,)
                            ),
                            GestureDetector(
                              onTap: () async {
                                var imageTemp = await _picker.pickImage(source: ImageSource.gallery);
                                    setState(() {
                                      image = imageTemp;
                                      //luu avatar vao storage
                                      FirebaseStorage.instance.ref().child(
                                          "userImages").child(
                                          "avatar-" + Constants.myEmail).putFile(
                                          File(image!.path));
                                      //lay duong dan cua avatar
                                      getUrlAvatar("avatar-" + Constants.myEmail)
                                          .then((value) {
                                        DatabaseMethods databaseMethods = DatabaseMethods();
                                        databaseMethods.setUrlAvatar(
                                            value, Constants.myEmail);
                                        Constants.myAvatar = value;
                                        userAvatar = value;
                                      });
                                });
                              },
                                child: Icon(Icons.camera_alt_outlined)
                            ),
                          ],
                        )
                        :
                    Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(150),
                          child: Image.file(File(image!.path),
                            height: 150,width: 150,fit: BoxFit.cover,),
                        ),
                        GestureDetector(
                            onTap: () async {
                              var imageTemp = await _picker.pickImage(source: ImageSource.gallery);
                              setState(() {
                                image = imageTemp;
                                //luu avatar vao storage
                                FirebaseStorage.instance.ref().child(
                                    "userImages").child(
                                    "avatar-" + Constants.myEmail).putFile(
                                    File(image!.path));
                                //lay duong dan cua avatar
                                getUrlAvatar("avatar-" + Constants.myEmail)
                                    .then((value) {
                                  DatabaseMethods databaseMethods = DatabaseMethods();
                                  databaseMethods.setUrlAvatar(
                                      value, Constants.myEmail);
                                  Constants.myAvatar = value;
                                  userAvatar = value;
                                });
                              });
                            },
                            child: Icon(Icons.camera_alt_outlined)),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Text(Constants.myName,style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                    Text(Constants.myEmail,style: const TextStyle(fontSize: 16),),
                    const SizedBox(height: 30,),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                child: Card(
                  child: Row(
                    children: const [
                      SizedBox(width: 5,),
                      Icon(Icons.calendar_month),
                      SizedBox(width: 10,),
                      Text("29/08/2000",style: TextStyle(fontSize: 20),),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 50,
                child: Card(
                  child: Row(
                    children: const [
                      SizedBox(width: 5,),
                      Icon(Icons.person),
                      SizedBox(width: 10,),
                      Text("Nam",style: TextStyle(fontSize: 20),),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 50,
                child: Card(
                  child: Row(
                    children: const [
                      SizedBox(width: 5,),
                      Icon(Icons.phone),
                      SizedBox(width: 10,),
                      Text("0948 873 500",style: TextStyle(fontSize: 20),),
                    ],
                  ),
                ),
              ),
            ],
          )
        ),
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
