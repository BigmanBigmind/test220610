import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rider_app/AllWidgets/Divider.dart';



class MainScreen extends StatefulWidget {
  static const String idScreen = "mainScreen";   //페이지 id

  @override
  _MainScreenState createState() => _MainScreenState();
}



class _MainScreenState extends State<MainScreen> {

  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController newGoogleMapController;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.56667,  126.97806),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Main Screen"),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;      //guide에 없음. 새로 넣음
            },
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Container(
              height: 320.0,
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
                    Container(
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
                    SizedBox(height: 24.0,),
                    Row(
                      children: [
                        Icon(Icons.home, color: Colors.grey,),
                        SizedBox(width: 12.0, ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Add Home"),
                            SizedBox(height: 4.0,),
                            Text("Your living home address",
                                style: TextStyle(color: Colors.black54, fontSize: 12.0,),),
                          ],
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
