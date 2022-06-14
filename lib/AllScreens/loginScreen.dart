import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rider_app/AllScreens/registrationScreen.dart';
import 'package:rider_app/AllScreens/mainscreen.dart';
import 'package:rider_app/main.dart';

class LoginScreen extends StatelessWidget {
  static const String idScreen = "login";   //페이지 id

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(        //모든 기종의 아이폰,안드로이드에서 화면 제대로 해줄라면 스크롤 필요
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [

              SizedBox(height: 35.0,),
              Image(
                image: AssetImage("images/logo.png"),
                width: 390.0,
                height: 250.0,
                alignment: Alignment.center,
              ),
              SizedBox(height: 1.0,),
              Text(
                "Login as a Rider",
                style: TextStyle(fontSize: 24.0, fontFamily: "Brand Bold"),
                textAlign: TextAlign.center,
              ),

              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [

                    SizedBox(height: 1.0,),
                    TextField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "E-mail",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),

                    SizedBox(height: 1.0,),
                    TextField(
                      controller: passwordTextEditingController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "password",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),

                    SizedBox(height: 10.0,),
                    ElevatedButton(
                      onPressed: (){
                        print("log in button clicked");
                        if(!emailTextEditingController.text.contains("@")){
                          displayToastMsg("Email address is not correct", context);
                        }
                        else if(passwordTextEditingController.text.isEmpty){
                          displayToastMsg("Password is mandatory.", context);
                        }
                        else{
                          loginAndAuthenticateUser(context);
                        }

                      },
                      child: Container(
                        height: 50.0,
                        child: Center(
                          child: Text(
                            "Login",
                            style: TextStyle(fontSize: 18.0, fontFamily: "Brand Bold"),
                          ),
                        ),
                      ),
                      style: ButtonStyle(
                        textStyle: MaterialStateProperty.all(
                              TextStyle(color: Colors.white)),
                     //   foregroundColor: MaterialStateProperty.all(Colors.yellow),
                        backgroundColor: MaterialStateProperty.all(Colors.yellow),
                        shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(24.0),
                            ),
                        ),

                      ),

                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: (){
                  print("clicked"); //누르면 register화면으로 넘어감
                  Navigator.pushNamedAndRemoveUntil(context, RegistrationScreen.idScreen, (route) => false);
                },
                child: Text(
                  "Do not have an Account? Register here",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  //FirebaseAuth instance 선언을 꼭 해줘야 됨
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void loginAndAuthenticateUser(BuildContext context) async{

    final User firebaseUser = (await _firebaseAuth
        .signInWithEmailAndPassword(
        email: emailTextEditingController.text,
        password: passwordTextEditingController.text
    ).catchError((errMsg){
      displayToastMsg("Error: " + errMsg.toString(), context);
    })).user;   //sign in user information adapting firebase format

    if(firebaseUser != null)  //user created
    {
      //displayToastMsg("firebaseUser != null", context);
      //user가 db에 있는지 확인    //todo: DataSnapshot이란? snap.snapshot.value 어떻게 타고 들어갔을까
      usersRef.child(firebaseUser.uid).once().then((snap){
        if(snap.snapshot.value != null){
          Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
          displayToastMsg("Logged in successfully", context);
        }
        else{
          _firebaseAuth.signOut();
          displayToastMsg("No record exists for this user. Please create new account", context);
        }
      });
    }
    else
    {
      //error occured - display error log
      displayToastMsg("Error occured. cannot sign in", context);
    }

  }
}
