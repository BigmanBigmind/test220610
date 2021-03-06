import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:rider_app/AllScreens/searchScreen.dart';
import 'package:rider_app/AllWidgets/Divider.dart';
import 'package:rider_app/Assistants/assistantMethods.dart';

import '../DataHandler/appData.dart';



class MainScreen extends StatefulWidget {
  static const String idScreen = "mainScreen";   //페이지 id

  @override
  _MainScreenState createState() => _MainScreenState();
}



class _MainScreenState extends State<MainScreen> {

  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController newGoogleMapController;

  GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();

  //todo: clima app 의 geoloactor 사용한거 보기
  Position currentPosition;
  var geolocator = Geolocator();
  double bottomPaddingOfMap = 0;

  void locatePosition() async{
    await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    print("****currentPosition.longitude: ");
    print(currentPosition.longitude);
    print(" currentPosition.longitude: ");
    print(currentPosition.longitude);
    print("\n");

    LatLng latlngPostion = LatLng(position.latitude, position.longitude);
    print("****latlngPostion.longitude: ");
    print(latlngPostion.longitude);
    print(" latlngPostion.latitude: ");
    print(latlngPostion.latitude);
    print("\n");

    CameraPosition cameraPosition = new CameraPosition(target: latlngPostion, zoom: 14);
    newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

//    AssistantMethods assistantMethods;
    try{
      //todo: class 내의 함수 그대로 불러쓰려면 static 선언 필요
      String address = await AssistantMethods.searchCoordinateAddress(position, context);
      print("************This is your Address :: " + address);

    }
    catch(exp){
      print("***********excpetion :: ");
    }

  }

  static final CameraPosition _kGooglePlex = CameraPosition(  //initialCameraPosition 으로 할 위치
    target: LatLng(37.56667,  126.97806),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      appBar: AppBar(
        title: Text("Main Screen"),
      ),
      drawer: Container(
        color: Colors.white,
        width: 255.0,
        child: Drawer(
          child: ListView(
            children: [
              Container(
                height: 165.0,
                child: DrawerHeader(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Row(
                    children: [
                      Image.asset("images/user_icon.png", height: 65.0, width: 65.0,),
                      SizedBox(width: 16.0,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Profile name", style: TextStyle(fontSize: 16.0, fontFamily: "Brand-Bold"),),
                          SizedBox(height: 6.0,),
                          Text("Visit Profile"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              DividerWidget(),

              SizedBox(height: 12.0,),

              ListTile(
                leading: Icon(Icons.history),
                title: Text("Histrory", style: TextStyle(fontSize: 15.0),),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text("Visit Profile", style: TextStyle(fontSize: 15.0),),
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text("About", style: TextStyle(fontSize: 15.0),),
              ),

            ],
          )
        )
      ),
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;      //guide에 없음. 새로 넣음

              setState(() {
                bottomPaddingOfMap = 300.0;
              });

              locatePosition();
            },
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
          ),

          //hamburger button for Drawer
          Positioned(
            top: 45.0,
            left: 22.0,

            child: GestureDetector(
              onTap: (){
                scaffoldkey.currentState.openDrawer();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 6.0,
                      spreadRadius: 0.5,
                      offset: Offset(
                        0.7,
                        0.7,
                      ),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.menu, color: Colors.black),
                  radius: 20.0,
                ),
              ),
            ),
          ),

          //밑에 박스   //todo: Positioned의 left, right, bottom 위치 선정이 궁금
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Container(
              height: 300.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 16.0,
                    spreadRadius: 0.5,
                    offset: Offset(0.7, 0.7),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 6.0),
                    Text("Hi There, ", style: TextStyle(fontSize: 10.0), ),
                    Text("Where to? ", style: TextStyle(fontFamily: "Brand-Bold"),),
                    SizedBox(height: 20.0,),
                    
                    GestureDetector(  //todo: GestureDetector 의 역할은?
                      onTap: (){  //todo: Navigator 의 역할은?
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchScreen()));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black54,
                              blurRadius: 6.0,
                              spreadRadius: 0.5,
                              offset: Offset(0.7, 0.7),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Icon(Icons.search, color: Colors.blueAccent,),
                              SizedBox(width: 10.0,),
                              Text("Search Drop Off"),
                            ],
                          ),
                        )
                      ),
                    ),
                    SizedBox(height: 24.0,),
                    Row(
                      children: [
                        Icon(Icons.home, color: Colors.grey,),
                        SizedBox(width: 12.0, ),
                        Expanded(     //todo:주소가 너무 길어서 Expanded위젯으로 감쌌음
                                      // https://devmg.tistory.com/195
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //Text("Add Home"),
                              Text(
                                Provider.of<AppData>(context).pickUpLocation != null
                                    ? Provider.of<AppData>(context).pickUpLocation.placeName
                                    : "Add Home",
                              //  style: TextStyle(fontSize: 10.0,),
                              ),

                              SizedBox(height: 4.0,),
                              Text("Your living home address",
                                  style: TextStyle(color: Colors.black54, fontSize: 12.0,),),
                            ],
                          ),
                        ),

                      ],
                    ),
                    SizedBox(height: 10.0,),
                    DividerWidget(),
                    SizedBox(height: 10.0,),
                    Row(
                      children: [
                        Icon(Icons.work, color: Colors.grey,),
                        SizedBox(width: 12.0, ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Add work"),
                            SizedBox(height: 4.0,),
                            Text("Your office address",
                              style: TextStyle(color: Colors.black54, fontSize: 12.0,),),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ),
              
          ),
        ],
      ),
    );
  }
}
