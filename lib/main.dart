import 'package:flutter/material.dart';
import 'package:stopwatch/screens/home.dart';

void main(){
  runApp(Myapp());
}
class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "StopWatch",
      home: Home(),
    );
  }
}