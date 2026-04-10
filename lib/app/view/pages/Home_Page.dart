import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsetsGeometry.directional(
            bottom: 15,
            top: 15,
            end: 5,
            start: 5,
          ),
          child: Row(
            children: [
              SizedBox(
                width: 50,
                height: 50,

                child: ClipRRect(
                  child: Image.asset('assets/logo.png', fit: BoxFit.cover),
                  borderRadius: BorderRadiusGeometry.circular(10),
                ),
              ),
              SizedBox(width: 5),
              Text('Rick And Morty Explorer', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
      body: Column(),
    );
  }
}
