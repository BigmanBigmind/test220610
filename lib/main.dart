import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rider_app/AllScreens/loginScreen.dart';
import 'package:rider_app/AllScreens/mainscreen.dart';
import 'package:rider_app/AllScreens/registrationScreen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();    //todo 뭔지 찾아보기
  await Firebase.initializeApp();   //firebase_core import 해야됨

  runApp(MyApp());
}
//firebase db에 "users" 라는 child 생성하여 usersRef 라는 객체는 "users" 관리
DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("users");  //firebase_database 9.0.15

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  static const String idScreen = "mainScreen";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'taxi rider app',
      theme: ThemeData(
        fontFamily: "Brand Bold",
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
 //     home: RegistrationScreen(),
      initialRoute: MainScreen.idScreen,   // 페이지 id 로 지정
      routes:{
        RegistrationScreen.idScreen: (context) => RegistrationScreen(),
        LoginScreen.idScreen: (context) => LoginScreen(),
        MainScreen.idScreen: (context) => MainScreen(),
      },
      debugShowCheckedModeBanner: false,    // 안드로이드 앱바에 debug 표시 안함
    );
  }
}


