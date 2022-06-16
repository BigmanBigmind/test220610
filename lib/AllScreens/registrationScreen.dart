import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rider_app/AllScreens/loginScreen.dart';
import 'package:rider_app/AllScreens/mainscreen.dart';
import 'package:rider_app/main.dart';
import 'package:rider_app/AllWidgets/progressDialog.dart';

class RegistrationScreen extends StatelessWidget {
  static const String idScreen = "register";    //페이지 id

  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
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

              SizedBox(height: 20.0,),
              Image(
                image: AssetImage("images/logo.png"),
                width: 390.0,
                height: 250.0,
                alignment: Alignment.center,
              ),
              SizedBox(height: 1.0,),
              Text(
                "Register as a Rider",
                style: TextStyle(fontSize: 24.0, fontFamily: "Brand Bold"),
                textAlign: TextAlign.center,
              ),

              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [

                    SizedBox(height: 1.0,),
                    TextField(
                      controller: nameTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Name",
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
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
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
                      controller: phoneTextEditingController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "Phone",
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

                    SizedBox(height: 20.0,),
                    ElevatedButton(
                      onPressed: (){
                        print("Create Account");
                        if(nameTextEditingController.text.length < 3){
                        //  Fluttertoast.showToast(msg: "Name must be at least 4 characters.");
                          displayToastMsg("Name must be at least 3 characters.", context);
                        }
                        else if(!emailTextEditingController.text.contains("@")){
                          displayToastMsg("Email address is not correct", context);
                        }
                        else if(phoneTextEditingController.text.isEmpty){
                          displayToastMsg("Phone number is mandatory", context);
                        }
                        else if(passwordTextEditingController.text.length < 6){
                          displayToastMsg("Password must be at least 6 characters.", context);
                        }
                        else{
                          registerNewUser(context);
                        }

                      },
                      child: Container(
                        height: 50.0,
                        child: Center(
                          child: Text(
                            "Create Account",
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
                  print("clicked"); //누르면 login화면으로 넘어감
                  Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);

                },
                child: Text(
                  "Already have an Account? Log in here",
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
  void registerNewUser(BuildContext context) async
  {

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return ProgressDialog(message: "Registering. Please wait...",);
        }
    );

    final User firebaseUser = (await _firebaseAuth
        .createUserWithEmailAndPassword(
          email: emailTextEditingController.text,
          password: passwordTextEditingController.text
        ).catchError((errMsg){
          Navigator.pop(context); //remove showDialog
          displayToastMsg("Error: " + errMsg.toString(), context);
    })).user;   //create user information adapting firebase format
    if(firebaseUser != null)  //user created
    {
      //save user info to db

      Map userDataMap = {
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
      };
      //DatabaseReference의 child인 userRef의 child로 지금 user를 넣고 그 user의 값으로 userDataMap을 넣음
      usersRef.child(firebaseUser.uid).set(userDataMap);   //main.dart에서 선언한 DatabaseReference usersRef
      displayToastMsg("your account has created successfully", context);

      Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
    }
    else
    {
      Navigator.pop(context); //remove showDialog
      //error msg
      displayToastMsg("New user account has not created", context);
    }
  }

}

displayToastMsg(String msg, BuildContext context){
  Fluttertoast.showToast(msg: msg);
}