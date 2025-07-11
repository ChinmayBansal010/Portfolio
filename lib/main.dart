import 'package:flutter/material.dart';
import 'package:portfolio/pages/home.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chinmay.dev',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        textTheme: ThemeData.dark().textTheme.apply(
          fontFamily: 'SpaceGrotesk',
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
      ),
      home: const HomePage(),
    );
  }
}