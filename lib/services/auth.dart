import 'package:chat_app/helper/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../helper/helperfunctions.dart';

class AuthMethods{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // sign in
  Future signInWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? firebaseUser = result.user;
      return firebaseUser;
    }
    catch(e){
      print(e.toString());
    }
  }

  // sign up
  Future signUpWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? firebaseUser = result.user;
      return firebaseUser;
    }
    catch(e){
      print(e.toString());
    }
  }

  Future resetPass(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      Constants.myAvatar="";
      Constants.myEmail="";
      Constants.myName="";
      HelperFunctions.saveUserLoggedInSharedPreference(false);
      HelperFunctions.saveUserAvatarSharedPreference("");
      HelperFunctions.saveUserEmailSharedPreference("");
      HelperFunctions.saveUserNameSharedPreference("");

      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}