import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf4f4f4),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(children: [
              SizedBox(
              width: 100,
              height: 100,
              child: Image.asset('images/splash_img.jpg'),
            ),
           SizedBox(height: 10,),
           SvgPicture.asset(
              width:40,
              height:40,
              'images/svg-bounce.svg',
            ),
            ],)
            
          ],
        ),
      ),
    );
  }
}
