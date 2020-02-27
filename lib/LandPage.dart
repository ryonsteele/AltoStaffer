import 'package:alto_staffing/AltoUtils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'models/shifts.dart';
import 'package:alto_staffing/Home.dart';
import 'dart:convert';
import 'ShiftCard.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'models/Specs.dart';

class LandPage extends StatefulWidget {
  final String tempid;

  LandPage({Key key, @required this.tempid}) : super(key: key);

  @override
  AppState createState() => AppState(this.tempid);
}

class AppState extends State<LandPage> with SingleTickerProviderStateMixin{
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static String tempId = "";
  static bool isLoading = false;
  List shifts;
  List openShifts;

  AppState(String tid) {
    tempId = tid;
  }

  @override
  void initState() {
    isLoading = false;
    if(this.shifts != null) {
      this.shifts.clear();
      this.shifts = null;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).primaryColor;

    getScheduled();

    final List<String> _dropdownValues = [
      "  ",
      "One",
      "Two",
      "Three",
      "Four",
      "Five"
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
          });
        },
        //this wont make dropdown expanded and fill the horizontal space
        isExpanded: false,
        //make default value of dropdown the first value of our list
        value: _dropdownValues.first,
      );
    }

    if((this.shifts == null || this.shifts.isEmpty) && !isLoading){
      isLoading = true;
      return MaterialApp(
          home: Scaffold(
            body: SpinKitSquareCircle(
        color: Color(0xFF05152B),
        size: 100.0,
        controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 4800)),
      ),
      )
      );
    }


    return MaterialApp(
        home: DefaultTabController(
        length: 2,
        child: Scaffold(
        resizeToAvoidBottomPadding: false,
        key: _scaffoldKey,
          appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        bottom: TabBar(
          tabs: [
            Tab(icon: Icon(Icons.calendar_today)),
            Tab(icon: Icon(Icons.local_offer)),
          ],
        ),
        title: Text('My Shifts'),
        actions: <Widget>[
          //Add the dropdown widget to the `Action` part of our appBar. it can also be among the `leading` part
          dropdownWidget(),
        ],
      ),
        backgroundColor: Colors.white,
        body:
        TabBarView(
          children: [
        Center(
        child: ListView.builder(
        itemCount: this.shifts.length,
//            padding: const EdgeInsets.only(top: 10.0),
            itemBuilder: (context, index) {
              return ShiftCard(this.shifts[index]);
            })
        ),
          Center(
              child: ListView.builder(
                  itemCount: this.openShifts.length,
//            padding: const EdgeInsets.only(top: 10.0),
                  itemBuilder: (context, index) {
                    return ShiftCard(this.openShifts[index]);
                  })
          ),
          ],
        ),
        )));
  }

//todo api impl
  Future getScheduled() async {
    if(this.shifts != null && this.shifts.isNotEmpty) return;
    this.shifts = new List<Shifts>();
    this.openShifts = new List<Shifts>();
    Response response;
    Response openResponse;
    try {
      final now = new DateTime.now();
      final yesterday = new DateTime(now.year, now.month, now.day - 1);
      response = await http.get(AltoUtils.baseHcsUrl + '?action=getOrders&sessionkey='+Home.keyNumber.sessionKey+'&tempId='+tempId+'&status=filled&orderBy1=shiftStart&orderByDirection1=ASC&shiftStart='+yesterday.toIso8601String()+'&resultType=json');
      openResponse = await http.get(AltoUtils.baseHcsUrl + '?action=getOrders&sessionkey='+Home.keyNumber.sessionKey+'&status=open&orderBy1=shiftStart&orderByDirection1=ASC&shiftStart='+now.toIso8601String()+'&resultType=json');

    } on Exception catch (exception) {
      print(exception);
    } catch (error) {
      print(error);
    }


    if(response.body.contains('html')) return null;
    //print(response.body);

    this.shifts=(json.decode(response.body) as List).map((i) =>
        Shifts.fromJson(i)).toList();

    this.openShifts=(json.decode(openResponse.body) as List).map((i) =>
        Shifts.fromJson(i)).toList();

    this.openShifts.sort((a, b) => a.shiftStartTime.compareTo(b.shiftStartTime));

    setState(() {});

  }



}