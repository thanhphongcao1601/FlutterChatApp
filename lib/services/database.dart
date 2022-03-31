import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{
  getUserByUsername(String username) async {
    return await FirebaseFirestore.instance.collection("users")
        .where("name", isEqualTo : username)
        .get();
  }

  getUserByUserEmail(String userEmail) async {
    return await FirebaseFirestore.instance.collection("users")
        .where("email", isEqualTo : userEmail)
        .get();
  }

  uploadUserInfo(userMap, String docEmail){
    FirebaseFirestore.instance.collection("users").doc(docEmail)
        .set(userMap);
  }

  createChatRoom(String chatRoomid, chatRoomMap){
    FirebaseFirestore.instance.collection("ChatRoom")
        .doc(chatRoomid).set(chatRoomMap).catchError((e){
          print(e.toString());
    });
  }

  addConversationMessage(String chatRoomid, messageMap){
    FirebaseFirestore.instance.collection("ChatRoom")
        .doc(chatRoomid)
        .collection("chats")
        .add(messageMap).catchError((e){
          print(e.toString());
    });
  }

  getConversationMessage(String chatRoomid) async{
    return await FirebaseFirestore.instance.collection("ChatRoom")
        .doc(chatRoomid)
        .collection("chats")
        .snapshots();
  }

  getChatRooms(String userName) async{
    return await FirebaseFirestore.instance.collection("ChatRoom")
              .where("users",arrayContains: userName)
              .snapshots();
  }
  
  setLastMess(String lastMess,String chatRoomid) async{
    // Map<String,String> lm = {'lastMess':lastMess};
    FirebaseFirestore.instance.collection("ChatRoom")
        .doc(chatRoomid)
        .set({'lastMess': lastMess},SetOptions(merge: true));
  }

  setUrlAvatar(String url,String email){
    var t = FirebaseFirestore.instance.collection("users")
        .doc(email).set({'urlAvatar': url},SetOptions(merge: true));
  }
}