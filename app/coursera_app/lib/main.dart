import 'package:coursera_app/login_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xffF24D0D)),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
