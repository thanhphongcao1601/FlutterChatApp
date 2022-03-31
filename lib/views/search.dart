import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'conversation.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController searchEditingController = TextEditingController();
  QuerySnapshot<Map<String, dynamic>>? searchSnapshot;

  initiateSearch(){
    databaseMethods.getUserByUserEmail(
        searchEditingController.text.replaceAll("@gmail.com", "")+"@gmail.com").then(
            (val){
              setState(() {
                searchSnapshot = val;
              });
        });
  }

  //create chatRoom and move to conservation screen
  createChatRoomAndStartConservation(String userName){
    if (userName!=Constants.myName){
      String chatRoomId = getChatRoomId(userName,Constants.myName);

      List<String> users = [userName, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "user" : users,
        "chatRoomid" : chatRoomId
      };
      DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(context,
          MaterialPageRoute(
              builder: (context) => ConversationScreen(chatRoomId)
          )
      );
    } else{
      print("You can not send to yourself");
    }
  }

  Widget SearchTile({String? username, String? useremail}){
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(username!),
            Text(useremail!)
          ],
        ),
        Spacer(),
        GestureDetector(
          onTap: (){
            createChatRoomAndStartConservation(username);
          },
          child: Container(
            decoration: BoxDecoration(
                color: Colors.brown[200],
                borderRadius: BorderRadius.circular(30)
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: const Text("Message",style: TextStyle(color: Colors.white),),
          ),
        )
      ],
    );
  }

  Widget searchList(){
    return searchSnapshot!=null ? ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        itemCount: searchSnapshot!.docs.length,
        shrinkWrap: true,
        itemBuilder: (context, index){
          return SearchTile(
              username : searchSnapshot!.docs[index].data()["name"],
              useremail: searchSnapshot!.docs[index].data()["email"]
          );
        }) : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[200],
        title: const Text("Search here"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children:[
                Expanded(
                    child: TextField(
                      controller: searchEditingController,
                    )
                ),
                GestureDetector(
                  onTap: (){
                    initiateSearch();
                  },
                  child: Container(
                      height: 50,
                      width: 50,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        // gradient: const LinearGradient(
                        //   colors: [
                        //     Color(0xff211d1d),
                        //     Color(0xff9e6940)
                        //   ]
                        // ),
                          borderRadius: BorderRadius.circular(50)
                      ),
                      child: Image.asset("assets/images/search.png")
                  ),
                ),
              ],
            ),
          ),
          searchList()
        ],
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}

