// new package 가 메뉴에서 안 보일 때는, lib 폴더 우클릭 후 marked directory as -> sources root
// https://ondolroom.tistory.com/865

import 'package:flutter/material.dart';

class ProgressDialog extends StatelessWidget {
  String message;
  ProgressDialog({this.message});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.yellow,
      child: Container(
        margin: EdgeInsets.all(15.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Row(
            children: [
              SizedBox(width: 6.0, ),
              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black),),
              SizedBox(width: 26.0,),
              Text(
                message,
                style: TextStyle(color: Colors.black, fontSize: 10.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

