import 'package:clambi/navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';


void main() async {
  SystemChrome.setSystemUIOverlayStyle(
  SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AnimatedSplashScreen(
          duration: 2000,
          splash: "image/logo.png",
          nextScreen: BottomNavBar(),
          splashTransition: SplashTransition.slideTransition,
          pageTransitionType: PageTransitionType.fade,
          animationDuration: Duration(seconds: 2),
          backgroundColor: Color.fromARGB(255, 93, 163, 219)
        ),
      debugShowCheckedModeBanner: false,
    );
  }
}
