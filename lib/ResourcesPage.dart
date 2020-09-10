import 'dart:convert';

import 'package:alto_staffing/AltoUtils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:alto_staffing/Home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'LandPage.dart';



class ResourcesPage extends StatefulWidget {
  final String tempid;

  ResourcesPage({Key key, @required this.tempid}) : super(key: key);

  @override
  AppState createState() => AppState(this.tempid);
}

class AppState extends State<ResourcesPage> with SingleTickerProviderStateMixin{
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String tempid;


  AppState(String tid) {
    this.tempid = tid;
  }

  @override
  void initState() {
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    Color primary = Color(0xFF0B859E);;

    return Scaffold(
      appBar: AppBar(
        title: Text('Human Resources Links'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushReplacement( MaterialPageRoute(builder: (context) => LandPage(tempid: this.tempid, backTrigger: 0,)));
            },
          ),
          //Add the dropdown widget to the `Action` part of our appBar. it can also be among the `leading` part
        ],
        backgroundColor: Color(0xFF0B859E),
      ),
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('App Build Version', style: TextStyle(
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                      fontSize: 10.0
                  ),),
                  Text(Home.versions, style: TextStyle(
                      color: Colors.black,
                      fontSize: 10.0
                  ),),
                ],
              ),
              SizedBox(height: 40),
              GestureDetector(
                  child: Text("Workforce Portal", style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 15.0)),
                  onTap: () {
                      _launchURL(AltoUtils.url1);
                  }
              ),
              SizedBox(height: 45),
              GestureDetector(
                  child: Text("Heartland Payroll/View Check Stubs Here", style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 15.0)),
                  onTap: () {
                    _launchURL(AltoUtils.url2);
                  }
              ),
              Text("Company Code: 0200BCCS"),
              SizedBox(height: 45),
              GestureDetector(
                  child: Text("Alto’s Website", style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 15.0)),
                  onTap: () {
                    _launchURL(AltoUtils.url3);
                  }
              ),
              SizedBox(height: 20),

            ],
          ),
        ),
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showConnectionDialog(context);
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