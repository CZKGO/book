// Step 7 (Final): Change the app's theme

import 'package:flutter/material.dart';
import 'package:flutter_book/page/home/HomePage.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Book",
      theme: ThemeData(
          backgroundColor: Colors.white,
          textTheme: TextTheme(
              button: new TextStyle(color: Colors.black87),
              title: new TextStyle(color: Colors.black87))),
      home: HomePage(),
      debugShowCheckedModeBanner: true,
//      debugShowMaterialGrid: true,
//      showSemanticsDebugger: true,
    );
  }
}
