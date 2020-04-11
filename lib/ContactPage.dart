import 'package:alto_staffing/AltoUtils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:android_intent/android_intent.dart';
import 'dart:io' show Platform;
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class ContactPage extends StatefulWidget {

  ContactPage() : super();

  @override
  AppState createState() => AppState();
}

class AppState extends State<ContactPage> with SingleTickerProviderStateMixin{
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  AppState() {}

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Alto'),
      ),
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            MaterialButton(
              padding: EdgeInsets.all(8.0),
              textColor: Colors.white,
              splashColor: Colors.greenAccent,
              elevation: 8.0,
              child: Container(
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/callAlto.png'),
                      fit: BoxFit.cover),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                ),
              ),
              // ),
              onPressed: () {
                _callMe();
              },
            ),
            SizedBox(height: 60),
            MaterialButton(
              padding: EdgeInsets.all(8.0),
              textColor: Colors.white,
              splashColor: Colors.greenAccent,
              elevation: 8.0,
              child: Container(
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/textAlto.png'),
                      fit: BoxFit.cover),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                ),
              ),
              // ),
              onPressed: () {
                _textMe();
              },
            ),
            SizedBox(height: 60),
            MaterialButton(
              padding: EdgeInsets.all(8.0),
              textColor: Colors.white,
              splashColor: Colors.greenAccent,
              elevation: 8.0,
              child: Container(
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/emailAlto.png'),
                      fit: BoxFit.cover),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                ),
              ),
              // ),
              onPressed: () {
                _emailMe();
              },
            ),
          ],
        ),
      ),
    );
  }


  _textMe() async {
    const uri = 'sms:9372287007';
    if ( await UrlLauncher.canLaunch(uri)) {
      await UrlLauncher.launch(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  _callMe() async {
    const uri = 'tel:+1 937 228 7007';
    if ( await UrlLauncher.canLaunch(uri)) {
      await UrlLauncher.launch(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  _emailMe() async {
    if (Platform.isAndroid) {
//      AndroidIntent intent = AndroidIntent(
//        action: 'android.intent.action.MAIN',
//        category: 'android.intent.category.APP_EMAIL',
//      );
//      intent.launch().catchError((e) {
//        ;
//      });
      UrlLauncher.launch("mailto:aharris@altostaffing.com").catchError((e){
        ;
      });
    } else if (Platform.isIOS) {
      UrlLauncher.launch("mailto:aharris@altostaffing.com").catchError((e){
        ;
      });
    }
  }


  showConnectionDialog(BuildContext context) {

    Widget continueButton = FlatButton(
      child: Text("Ok"),
      onPressed:  () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('There\'s been a connection issue!'),
      content: Text("Please restart the app or try again soon"),
      actions: [
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }



}