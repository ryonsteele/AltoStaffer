import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:alto_staffing/Home.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();



  @override
  Widget build(BuildContext context) {

    _firebaseMessaging.requestNotificationPermissions();

    return MaterialApp(
      title: 'Alto Staffing',

      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          hintColor: Color(0xFF05152B),
          primaryColor: Color(0xFF0B859E),
          fontFamily: "Montserrat",
          canvasColor: Colors.transparent),
      home: Home(bypassSplash: true,),
    );
  }
}
