import 'package:flutter/material.dart';
import './ui/home.dart';

void main(){
  runApp( new MaterialApp(
      title: "simple layout",
      debugShowCheckedModeBanner: false,
      home: new Home(),
  ));
}