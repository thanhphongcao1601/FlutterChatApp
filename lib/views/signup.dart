import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';

import '../helper/constants.dart';
import 'chatscreen.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  TextEditingController usernameEditingController = TextEditingController();
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();

  bool isloading = false;
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();

  signMeUP() {
    if (formKey.currentState!.validate()) {
      setState(() {
        isloading = true;
      });

      authMethods
          .signUpWithEmailAndPassword(emailEditingController.text.trim(), passwordEditingController.text)
          .then((val) async {
              Map<String, String> userInfoMap = {
                "name": usernameEditingController.text,
                "email": emailEditingController.text.trim()
              };
        //luu user da dang ky vao database "users"
        databaseMethods.uploadUserInfo(userInfoMap, emailEditingController.text.trim());

        //Luu cac thong tn vao preference
        HelperFunctions.saveUserLoggedInSharedPreference(true);
        HelperFunctions.saveUserNameSharedPreference(usernameEditingController.text);
        HelperFunctions.saveUserEmailSharedPreference(emailEditingController.text.trim());
        //HelperFunctions.saveUserAvatarSharedPreference("null");
        Constants.myAvatar = "null";
        Constants.myEmail = await HelperFunctions.getUserEmailSharedPreference() as String;
        print("email - dang ky - "+Constants.myEmail);

        HelperFunctions.getUserNameSharedPreference().then((val){
          Constants.myName=val.toString();
          print("username - dang ky - "+Constants.myName);
        }).then((val){
          Navigator.pushReplacement(context,
              MaterialPageRoute(
                  builder: (context)=> ChatScreen()
              )
          );
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isloading
          ? Container(
              child: Center(
              child: CircularProgressIndicator(),
            ))
          :
          // body:
          SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                alignment: Alignment.bottomCenter,
                color: Colors.brown[200],
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/images/chocolate.png',height: 250,),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            validator: (val) {
                              return val.toString().isEmpty ||
                                      val.toString().length < 3
                                  ? "Enter Username 3+ characters"
                                  : null;
                            },
                            controller: usernameEditingController,
                            style: simpleTextStyle(),
                            decoration: textFieldInputDecoration("username"),
                          ),
                          TextFormField(
                            validator: (val) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(val.toString())
                                  ? null
                                  : "Enter correct email";
                            },
                            controller: emailEditingController,
                            style: simpleTextStyle(),
                            decoration: textFieldInputDecoration("email"),
                          ),
                          TextFormField(
                            obscureText: true,
                            validator: (val) {
                              return val.toString().length < 6
                                  ? "Please enter password 6+ characters"
                                  : null;
                            },
                            controller: passwordEditingController,
                            style: simpleTextStyle(),
                            decoration: textFieldInputDecoration("password"),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Forgot password?',
                        style: biggerTextStyle(),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    GestureDetector(
                      onTap: () {
                        signMeUP();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        child: Text(
                          'Sign Up',
                          style: biggerTextStyle(),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child: Text(
                        'Sign Up With Google',
                        style: biggerTextStyle(),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already have account? ',
                            style: simpleTextStyle()),
                        GestureDetector(
                          onTap: () {
                            widget.toggle();
                          },
                          child: Container(
                              child: const Text(
                            'Sign in now',
                            style: TextStyle(
                                fontSize: 18,
                                decoration: TextDecoration.underline,
                                color: Colors.white),
                          )),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
