import 'dart:io';

import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomid;
  ConversationScreen(this.chatRoomid);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  TextEditingController messageController = TextEditingController();
  DatabaseMethods databaseMethods = DatabaseMethods();
  final ScrollController _scrollController = ScrollController();

  final ImagePicker _picker = ImagePicker();

  Widget ChatMessageList(){
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("ChatRoom")
            .doc(widget.chatRoomid)
            .collection("chats")
            .orderBy("time",descending: false)
            .snapshots(),
        builder: (context,AsyncSnapshot snapshot){
          if (!snapshot.hasData) {
            return Container();
          } else {
            return ListView.builder(
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index){
                  //lay thoi gian gui tin nhan
                  var time = DateTime.parse(snapshot.data.docs[index].data()["time"].toDate().toString());
                  //chuyen time ve dung dinh dang
                  var time_string = time.hour.toString()+":"+time.minute.toString();
                  return MessageTile(snapshot.data.docs[index].data()["message"],
                                      snapshot.data.docs[index].data()["sendBy"]==Constants.myName,
                                      time_string);
                }
            );
          }
        }
    );
  }

  //ham gui tin nhan len firebase
  sendMessage() async {
    if (messageController.text.isNotEmpty){
      Map<String,dynamic> messageMap = {
        "message": messageController.text,
        "sendBy" : Constants.myName,
        "time" : DateTime.now()
      };
      //luu tin nhan cuoi cung
      databaseMethods.setLastMess(messageController.text, widget.chatRoomid);
      databaseMethods.addConversationMessage(widget.chatRoomid, messageMap);
      //dua khung chat ve rong
      messageController.text = "";
    }
  }

  @override
  void initState() {
    super.initState();
    autoScroll();
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance?.addPostFrameCallback((_) async {
      await Future.delayed(Duration(milliseconds: 300));
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[200],
        centerTitle: false,
        title: Text("${widget.chatRoomid.replaceAll("_", "").replaceAll(Constants.myName, "")}"),
        actions: [
          GestureDetector(
            onTap: (){},
            child: Container(child: Icon(Icons.menu),margin: EdgeInsets.fromLTRB(0, 0, 10, 0),),
          )
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: ChatMessageList()
            ),
            Container(
              height: 50,
              color: Colors.brown[200],
              //alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children:[
                    Container(
                        child: Icon(Icons.tag_faces,color: Colors.white,)
                    ),
                    Expanded(
                        child: TextField(
                          style: TextStyle(color: Colors.white),
                          controller: messageController,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
                              hintText: "Text some words . . .",
                              hintStyle: TextStyle(color: Colors.white54),
                              border: InputBorder.none
                          ),
                        ),
                    ),
                    GestureDetector(
                      onTap: (){
                        sendMessage();
                        autoScroll();
                        autoScroll();
                      },
                      child: Container( //button send
                          height: 50,
                          // width: 50,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50)
                          ),
                          child: Container(
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                                    },
                                    child: Image.asset("assets/images/camera.png",color: Colors.white)),
                                  SizedBox(width: 10),
                                  Image.asset("assets/images/send.png",color: Colors.white,height: 25,)
                                ],
                              )
                          )
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      )
    );
  }

  autoScroll(){
    Future.delayed(Duration(milliseconds: 300));
      if (_scrollController.hasClients){
         _scrollController.animateTo(
          _scrollController.position.maxScrollExtent+70,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 200),
        );
      }
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  final timeSend;
  MessageTile(this.message,this.isSendByMe,this.timeSend);

  @override
  Widget build(BuildContext context) {
    return isSendByMe ? Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.centerRight,
      margin: EdgeInsets.fromLTRB(10,10,10,0),
      child:  Container(
        margin: EdgeInsets.only(left: 20),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.brown[200],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20)
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message,style: TextStyle(color: Colors.white,fontSize: 17)),
            SizedBox(height: 5,),
            Text(timeSend.toString(),style: TextStyle(fontSize: 10,color: Colors.white)),
          ],
        ),
      ),
    )
    : Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.fromLTRB(10,10,10,0),
        child:  Container(
          margin: EdgeInsets.only(right: 20),
          padding: EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Color(828531813),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20)
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(message,style: TextStyle(color: Colors.black87,fontSize: 17)),
              SizedBox(height: 5,),
              Text(timeSend.toString(),style: TextStyle(fontSize: 10)),
            ],
          )
          ),
    );
  }
}
