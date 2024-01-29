import 'package:flutter/material.dart';
import '../pages/homepage.dart';
import '../pages/splash.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CamText Extractor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context)  => MySplashScreen(),
        '/home': (context)  => MyhomePage(),
      },
    );
 }
}