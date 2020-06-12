import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Gider Hesaplama"),
          centerTitle: true,
        ),
        body: Center(
          child: Text(
            "Yeni Projeye Hoş Geldiniz",
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
