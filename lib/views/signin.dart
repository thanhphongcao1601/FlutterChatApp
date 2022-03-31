import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/chatscreen.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class SignIn extends StatefulWidget {
  //Truyen vao Login 1 function chuyen doi giua Login va SignUp
  final Function toggle;
  SignIn(this.toggle);
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn>{
  final formKey = GlobalKey<FormState>();
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  TextEditingController _resetPassController = TextEditingController();

  bool isloading = false; // check man hinh load
  AuthMethods authMethods = AuthMethods();  //cac ham ve tai khoan nguoi dung
  DatabaseMethods databaseMethods = DatabaseMethods(); //cac ham ve xu ly database chatroom,...
  QuerySnapshot<Map<String, dynamic>>? snapshotUserInfo;

  @override
  void initState() {
    databaseMethods.getChatRooms(Constants.myName).then((value){
      setState(() {
      });
    });
    // TODO: implement initState
    super.initState();
  }

  signIn() async{
    if (formKey.currentState!.validate()){  //kiem tra cac thong tin nhap hop le
      //Dang nhap voi email va password
      authMethods.signInWithEmailAndPassword(
          emailEditingController.text.trim().replaceAll("@gmail.com", "")+"@gmail.com",
          passwordEditingController.text)
        .then((val) async{
          if (val!=null){
            setState(() {
              isloading = true;
            });

            //luu email vao preference
            HelperFunctions.saveUserEmailSharedPreference(emailEditingController.text.trim().replaceAll("@gmail.com", "")+"@gmail.com");

            databaseMethods.getUserByUserEmail(emailEditingController.text.trim().replaceAll("@gmail.com", "")+"@gmail.com")
                .then((val) async{
                    snapshotUserInfo = val;
                    // luu name vao preference
                    //set trang la la 'da dang nhap' LoggedIn
                    HelperFunctions.saveUserLoggedInSharedPreference(true);
                    //luu email vao preference
                    HelperFunctions.saveUserEmailSharedPreference(snapshotUserInfo!.docs[0].data()["email"].toString());
                    //luu email vao preference
                    HelperFunctions.saveUserNameSharedPreference(snapshotUserInfo!.docs[0].data()["name"].toString());
                      Constants.myEmail = await HelperFunctions.getUserEmailSharedPreference() as String;
                      print("email - dang nhap - "+Constants.myEmail);
                    HelperFunctions.saveUserAvatarSharedPreference(snapshotUserInfo!.docs[0].data()["urlAvatar"].toString());
                    Constants.myAvatar = await HelperFunctions.getUserAvatarSharedPreference() as String;
                      print("avatar - dang nhap - "+Constants.myAvatar);
                    HelperFunctions.getUserNameSharedPreference().then((val){
                      Constants.myName=val.toString();
                      print(Constants.myName + " sau khi dang nhap");
                    }).then((val){
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(
                              builder: (context)=> ChatScreen()
                          )
                      );
                    });
            });
          }
          else {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Đăng nhập thất bại'),
                content: const Text('Tên đăng nhập hoặc mật khẩu không chính xác!'),
                actions: <Widget>[
                  // TextButton(
                  //   onPressed: () => Navigator.pop(context, 'Cancel'),
                  //   child: const Text('Cancel'),
                  // ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ],
              )
            );
          }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Demo Palo'),
      // ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.bottomCenter,
          color: Colors.brown[200],
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children:[
              Image.asset('assets/images/chocolate.png',height: 250,),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      // validator: (val){
                      //   //kiem tra co phai la email hay khong
                      //   return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      //       .hasMatch(val.toString()) ? null : "Enter correct email";
                      // },
                      controller: emailEditingController,
                      style: simpleTextStyle(),
                      decoration: textFieldInputDecoration("email"),
                    ),
                    TextFormField(
                      obscureText: true,  //set to input password
                      validator: (val){
                        return val.toString().length < 6 ? "Please enter password 6+ characters" : null;
                      },
                      controller: passwordEditingController,
                      style: simpleTextStyle(),
                      decoration: textFieldInputDecoration("password"),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16,),
              Container(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                    onTap: (){
                      showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Forgot passeword'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // TextField(
                                //     onChanged: (value) { },
                                //     decoration: InputDecoration(hintText: "Enter your username"),
                                //   ),
                                TextField(
                                  onChanged: (value) { },
                                  decoration: InputDecoration(hintText: "Enter your email"),
                                  controller: _resetPassController,
                                ),
                              ],
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => {
                                  authMethods.resetPass(_resetPassController.text),
                                  // Navigator.pop(context, 'Reset password')
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          )
                      );
                    },
                    child: Text('Forgot password?',style: biggerTextStyle(),)),
              ),
              SizedBox(height: 16,),
              GestureDetector(
                onTap: ((){
                  signIn();
                }),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: Text('Sign In', style: biggerTextStyle(),),
                ),
              ),
              SizedBox(height: 16,),
              GestureDetector(
                onTap: (){
                  print("${Constants.myName} zzzzz");
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(20)
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: Text('Sign In With Google', style: biggerTextStyle(),),
                ),
              ),
              SizedBox(height: 16,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Don\'t have account? ', style: simpleTextStyle()),
                  GestureDetector(
                    onTap: (){
                      widget.toggle();
                    },
                      child: Text('Register now', style: TextStyle(fontSize: 18, decoration: TextDecoration.underline, color: Colors.white),)),
                ],
              ),
              SizedBox(height: 50,)
            ],
          ),
        ),
      ),
    );
  }
}
