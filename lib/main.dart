import 'package:ct484_project/screens/account_edit.dart';
import 'package:ct484_project/screens/auth/auth_manager.dart';
import 'package:ct484_project/screens/auth/auth_screen.dart';
import 'package:ct484_project/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import './screens/home.dart';
//import './screens/account_edit.dart';

void main() async {
  await dotenv.load();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   title: 'ToDo App',
    //   routes: {
    //     '/': (ctx) => const Home(),
    //     '/accountEdit': (ctx) => const AccountEdit(),
    //   },
    //   initialRoute: '/',
    // );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => AuthManager(),
        ),
      ],
      child: Consumer<AuthManager>(
        builder: (context, authManager, child) {
          return MaterialApp(
            title: 'To-Do App',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'Lato',
              // Your theme data
            ),
            home: authManager.isAuth
                ? const SafeArea(child: Home())
                : FutureBuilder(
                    future: authManager.tryAutoLogin(),
                    builder: (ctx, snapshot) {
                      return snapshot.connectionState == ConnectionState.waiting
                          ? const SafeArea(child: SplashScreen())
                          : const SafeArea(child: AuthScreen());
                    },
                  ),
            routes:  {
               '/accountEdit': (ctx) => const AccountEdit(),
            },
            onGenerateRoute: (settings) {
              // Your onGenerateRoute logic
            },
          );
        },
      ),
    );
  }
}
