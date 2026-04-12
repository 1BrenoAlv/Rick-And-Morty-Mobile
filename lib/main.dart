import 'package:flutter/material.dart';
import 'package:rick_and_morty_mobile/app/view/pages//home-page/Home_Page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage(), debugShowCheckedModeBanner: false);
  }
}
