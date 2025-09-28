import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:todo_app/pages/homepage.dart';

class splashPage extends StatefulWidget {
  const splashPage({super.key});

  @override
  State<splashPage> createState() => _splashPageState();
}

class _splashPageState extends State<splashPage> {
  @override
    void initState() {
      super.initState();
      Timer(Duration(seconds: 2), () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder : (contex) => Homepage()));
      });
    }

    Widget build(BuildContext context){
      return Scaffold(
        backgroundColor: Colors.black12,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              "assets/download.jpg",
              fit: BoxFit.cover,
            ),
            Container(
                color: Colors.black.withOpacity(0.8),
            ),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/icons8-hard-working-48.svg",
                    width: 140,
                    height: 140,
                    alignment: Alignment.centerRight,
                  ),
                  Text("GRIND", style: TextStyle(color: Colors.white, fontSize: 35),)
                ],
              ),
            ),
          ],
        ),
      );
    }

}
