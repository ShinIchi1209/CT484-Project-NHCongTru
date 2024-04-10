import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './screens/home.dart';
import './screens/account_edit.dart'; // Import màn hình Account Edit

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDo App',
      routes: {
        '/': (ctx) => Home(),
        '/accountEdit': (ctx) => AccountEdit(),
      },
      initialRoute: '/',
    );
  }
}
