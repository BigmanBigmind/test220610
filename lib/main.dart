import 'package:flutter/material.dart';
import 'package:rider_app/AllScreens/loginScreen.dart';
import 'package:rider_app/AllScreens/mainscreen.dart';
import 'package:rider_app/AllScreens/registrationScreen.dart';

void main() {
  runApp(MyApp());
}

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
      initialRoute: LoginScreen.idScreen,   // 페이지 id 로 지정
      routes:{
        RegistrationScreen.idScreen: (context) => RegistrationScreen(),
        LoginScreen.idScreen: (context) => LoginScreen(),
        MainScreen.idScreen: (context) => MainScreen(),
      },
      debugShowCheckedModeBanner: false,    // 안드로이드 앱바에 debug 표시 안함
    );
  }
}


