

import 'package:alto_staffing/AltoUtils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/shifts.dart';
import 'package:alto_staffing/Home.dart';
import 'ShiftPrefPage.dart';
import 'dart:convert';
import 'ShiftCard.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'ContactPage.dart';
import 'models/Specs.dart';

class LandPage extends StatefulWidget {
  final String tempid;

  LandPage({Key key, @required this.tempid}) : super(key: key);

  @override
  AppState createState() => AppState(this.tempid);
}

class AppState extends State<LandPage> with TickerProviderStateMixin{
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static String tempId = "";
  static SharedPreferences prefs;
  List shifts;
  List openShifts;

  AppState(String tid) {
    tempId = tid;
  }

  @override
  void initState() {
    if(this.shifts != null) {
      this.shifts.clear();
      this.shifts = null;
    }
    if(this.openShifts != null) {
      this.openShifts.clear();
      this.openShifts = null;
    }
    getScheduled();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {



    final List<String> _dropdownValues = [
      "  ",
      "Contact Alto",
      "Shift Preferences",
      "Logout",
    ]; //The list of values we want on the dropdown
    String _currentlySelected = ""; //var to hold currently selected value

    //make the drop down its own widget for readability
    Widget dropdownWidget() {
      return DropdownButton(
        //map each value from the lIst to our dropdownMenuItem widget
        items: _dropdownValues
            .map((value) => DropdownMenuItem(
          child: Text(value),
          value: value,
        ))
            .toList(),
        onChanged: (String value) {
          //once dropdown changes, update the state of out currentValue
          setState(() {
            _currentlySelected = value;
            if(!_currentlySelected.trim().isEmpty){

              if(_currentlySelected.trim() == "Contact Alto"){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => ContactPage()));

              }else if(_currentlySelected.trim() == "Shift Preferences"){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => ShiftPrefPage(tempid: AppState.tempId)));

              }else if(_currentlySelected.trim() == "Logout"){
                Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) => Home()));
              }
            }
          });
        },
        //this wont make dropdown expanded and fill the horizontal space
        isExpanded: false,
        //make default value of dropdown the first value of our list
        value: _dropdownValues.first,
      );
    }


    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DefaultTabController(
        length: 2,
        child: Scaffold(
        resizeToAvoidBottomPadding: false,
        key: _scaffoldKey,
          appBar: AppBar(
            actions: <Widget>[
              //Add the dropdown widget to the `Action` part of our appBar. it can also be among the `leading` part
              dropdownWidget(),
            ],
            backgroundColor: Color(0xFF0B859E),
        bottom: TabBar(
          onTap: (index) {
            if(index == 0){
              getScheduled();

            }else if(index ==1 ){
              getOpens();
            }
          },
          tabs: [
            Tab(icon: Icon(Icons.calendar_today)),
            Tab(icon: Icon(Icons.local_offer)),
          ],
        ),
        title: Text('My Shifts'),
      ),
        backgroundColor: Colors.white,
        body:
        TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
        Center(
        child: loadingListView(this.shifts),
        ),
          Center(
              child: loadingListView(this.openShifts),
          ),
          ],
        ),
        )));
  }

  Future getScheduled() async {
    if(this.shifts != null && this.shifts.isNotEmpty) return;
    this.shifts = new List<Shifts>();
    Response response;
    try {
      if(tempId == null || tempId.isEmpty){
        prefs = await SharedPreferences.getInstance();
        tempId = prefs.getString('temp_id') ?? '';
      }

      response = await http.get(AltoUtils.baseApiUrl + '/mobileshifts/scheduled/' + tempId);


    if(response.body.contains('html')) return null;
    //print(response.body);
      setState(() {
        this.shifts=(json.decode(response.body) as List).map((i) =>
            Shifts.fromJson(i)).toList();
      });


    } on Exception catch (exception) {
      print(exception);
      showConnectionDialog(context);
    } catch (error) {
      print(error);
      showConnectionDialog(context);
    }
  }

  Future getOpens() async {
    if(this.openShifts != null && this.openShifts.isNotEmpty) return;
    this.openShifts = new List<Shifts>();
    Response openResponse;
    try {
      openResponse = await http.get(AltoUtils.baseApiUrl + '/mobileshifts/open/' + tempId);

      if(openResponse.body.contains('html')) {
        print(openResponse.body);
        return null;
      }

        this.openShifts=(json.decode(openResponse.body) as List).map((i) =>
            Shifts.fromJson(i)).toList();

        this.openShifts.sort((a, b) => a.shiftStartTime.compareTo(b.shiftStartTime));
    } on Exception catch (exception) {
      print(exception);
      showConnectionDialog(context);
    } catch (error) {
      print(error);
      showConnectionDialog(context);
    }
    setState(() {});

  }

  loadingListView(List items) {
    if(items != null && items.isNotEmpty){

      return ListView.builder(
          itemCount: items != null ? items.length : 0,
          itemBuilder: (context, index) {
            return ShiftCard(items[index]);
          });

    }else{

      return ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            return Text("Loading....");
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