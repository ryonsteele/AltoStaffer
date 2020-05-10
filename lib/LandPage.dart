

import 'package:alto_staffing/AltoUtils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/CalEvent.dart';
import 'models/Historicals.dart';
import 'models/shifts.dart';
import 'package:alto_staffing/Home.dart';
import 'ShiftPrefPage.dart';
import 'dart:convert';
import 'ShiftCard.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'ContactPage.dart';
import 'package:device_calendar/device_calendar.dart';
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
  String loadMessage = 'Loading....';
  static SharedPreferences prefs;
  DeviceCalendarPlugin _deviceCalendarPlugin;
  List<Calendar> _calendars;
  Calendar _selectedCalendar;
  List shifts;
  List openShifts;
  Historicals historicals;

  AppState(String tid) {
    _deviceCalendarPlugin = new DeviceCalendarPlugin();
    tempId = tid;
  }

  @override
  void initState() {
    if(this.shifts != null) {
      this.shifts.clear();
      this.shifts = null;
    }
    _retrieveCalendars();
    getScheduled(false);
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
                    builder: (context) => Home(bypassSplash: false,)));
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
        length: 3,
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
              getScheduled(false);
            }else if(index ==1){
              getOpens(false);
            }else if(index ==2){
              getHistorical();
            }
          },
          tabs: [
            Tab(icon: Icon(Icons.calendar_today)),
            Tab(icon: Icon(Icons.local_offer)),
            Tab(icon: Icon(Icons.hourglass_full)),
          ],
        ),
      ),
        backgroundColor: Colors.white,
        body:
        TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
        Center(
        child: loadingScheduledListView(this.shifts),
        ),
        Center(
         child: loadingOpensListView(this.openShifts),
          ),
        Center(
          child: loadingHistoryView(this.historicals),
          ),
         ],
        ),
        )));
  }

  Future<void> getScheduled(bool clear) async {
    if(clear && this.shifts != null && this.shifts.isNotEmpty) this.shifts.clear();
    this.loadMessage = 'Loading....';
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
     // this.shifts.sort((a, b) => a.shiftStartTime.compareTo(b.shiftStartTime));
      _addEventsToCalendar();
      if (this.shifts == null || this.shifts.isEmpty){
        setState(() {this.loadMessage = 'You have no shifts scheduled, please call Alto to schedule shifts.';});
      }

    } on Exception catch (exception) {
      print(exception);
      showConnectionDialog(context);
    } catch (error) {
      print(error);
      showConnectionDialog(context);
    }
  }

  Future getHistorical() async {
    this.loadMessage = 'Loading....';
    this.shifts = new List<Shifts>();
    Response response;
    try {
      if(tempId == null || tempId.isEmpty){
        prefs = await SharedPreferences.getInstance();
        tempId = prefs.getString('temp_id') ?? '';
      }

      response = await http.get(AltoUtils.baseApiUrl + '/mobileshifts/history/' + tempId);


      if(response.body.contains('html')) return null;
      //print(response.body);
      setState(() {
        this.historicals=Historicals.fromJson(json.decode(response.body));
      });

//      if (this.shifts == null || this.shifts.isEmpty){
//        setState(() {this.loadMessage = 'No data available at this time.';});
//      }

    } on Exception catch (exception) {
      print(exception);
      showConnectionDialog(context);
    } catch (error) {
      print(error);
      showConnectionDialog(context);
    }
  }

  Future getOpens(bool clear) async {
    if(clear && this.openShifts != null && this.openShifts.isNotEmpty) this.openShifts.clear();
    this.openShifts = new List<Shifts>();
    this.loadMessage = 'Loading....';
    Response openResponse;
    try {
      openResponse = await http.get(AltoUtils.baseApiUrl + '/mobileshifts/open/' + tempId);

      if(openResponse.body.contains('html')) {
        print(openResponse.body);
        return null;
      }

        this.openShifts=(json.decode(openResponse.body) as List).map((i) =>
            Shifts.fromJson(i)).toList();

       // this.openShifts.sort((a, b) => a.shiftStartTime.compareTo(b.shiftStartTime));

        if (this.openShifts == null || this.openShifts.isEmpty){
          setState(() {this.loadMessage = 'You have no shifts scheduled, please call Alto to schedule shifts.';});
        }
      setState(() {});
    } on Exception catch (exception) {
      print(exception);
      showConnectionDialog(context);
    } catch (error) {
      print(error);
      showConnectionDialog(context);
    }
  }



  loadingScheduledListView(List items) {
    if(items != null && items.isNotEmpty){

      return items.length != 0
          ? RefreshIndicator( child: ListView.builder(
          itemCount: items != null ? items.length : 0,
          itemBuilder: (context, index) {
            return ShiftCard(items[index]);
          },),
           onRefresh: getSchedData,
          )


        : Center(child: CircularProgressIndicator());
    }else{

      return ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            return Text(this.loadMessage);
          });

    }
  }

  Future<void> getOpenData() async{
    this.openShifts.clear();
    setState(() {
      getOpens(false);
    });
  }

  Future<void> getSchedData() async{
    this.shifts.clear();
    setState(() {
      getScheduled(false);
    });
  }

  loadingOpensListView(List items) {
    if(items != null && items.isNotEmpty){

      return items.length != 0
          ? RefreshIndicator( child: ListView.builder(
        itemCount: items != null ? items.length : 0,
        itemBuilder: (context, index) {
          return ShiftCard(items[index]);
        },),
        onRefresh: getOpenData,
      )


          : Center(child: CircularProgressIndicator());
    }else{

      return ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            return Text(this.loadMessage);
          });

    }
  }

  loadingHistoryView(Historicals item) {
    if(item != null){

      return Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(left: 25.0, bottom: 100, top: 15),
                    child: Text('Period of: ', textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 12)),
                  ),
                  Padding(padding: EdgeInsets.only(right: 25.0, bottom: 100, top: 15),
                    child: Text('${this.historicals.dateWindowBegin} to ${this.historicals.dateWindowEnd}', textAlign: TextAlign.end, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 12)),
                  ),
                ]),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(left: 25.0, bottom: 50),
                    child: Text('Hours Scheduled: ', textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18)),
                  ),
                  Padding(padding: EdgeInsets.only(right: 25.0, bottom: 50),
                    child: Text('${this.historicals.hoursScheduled}', textAlign: TextAlign.end, style: TextStyle(fontSize: 18)),
                  ),
                ]),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(left: 25.0),
                    child: Text('Hours Worked: ', textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18)),
                  ),
                  Padding(padding: EdgeInsets.only(right: 25.0),
                    child: Text('${this.historicals.hoursWorked}', textAlign: TextAlign.end, style: TextStyle(fontSize: 18)),
                  ),
                ]),
          ],
        ),
      );

    }else{

      return ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            return Text(this.loadMessage);
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

  void _retrieveCalendars() async {
    //Retrieve user's calendars from mobile device
    //Request permissions first if they haven't been granted
    try {
      var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
      if (permissionsGranted.isSuccess && !permissionsGranted.data) {
        permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
        if (!permissionsGranted.isSuccess || !permissionsGranted.data) {
          return;
        }
      }

      final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
      setState(() {
        _calendars = calendarsResult?.data;
        for(var cal in _calendars){
          if (cal.isDefault){
            _selectedCalendar = cal;
          }
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Future _addEventsToCalendar() async {
    //Method to add events to the user's calendar
    //If called, the list of mmaEvents will be iterated through and the mma
    // Events will be added to the user's selected calendar

    //If the events have previously been added by the user, they will have a
    // shared preference key for the Event ID and the event will be UPDATED
    // instead of CREATED

    //If events are successfully created/added, then the events that were
    // CREATED/UPDATED will be displayed to the user in the status string

    var evString = new StringBuffer('');
    SharedPreferences prefs = await SharedPreferences.getInstance();

    for (var shift in this.shifts) {
      CalEvent evnt = new CalEvent(shift.clientName);
      evnt.readyForCalendar = true;
      evnt.eventDate = new DateFormat("MM/dd/yyyy HH:mm a").parse(shift.shiftStartTime);
      evnt.addDetails(shift.clientName + shift.shiftStartTime);
      //Before adding MMA Event to calendar, check if it is ready for calendar
      // (i.e. ensure it is properly formatted)
      if (evnt.readyForCalendar) {
        final eventTime = evnt.eventDate;
        final eventToCreate = new Event(_selectedCalendar.id);
        eventToCreate.title = evnt.eventName;
        eventToCreate.start = eventTime;
        eventToCreate.description = evnt.toString();
        String mmaEventId = prefs.getString(evnt.getPrefKey());
        if (mmaEventId != null) {
          eventToCreate.eventId = mmaEventId;
        }
        eventToCreate.end = eventTime.add(new Duration(hours: 3));
        final createEventResult =
        await _deviceCalendarPlugin.createOrUpdateEvent(eventToCreate);
        if (createEventResult.isSuccess &&
            (createEventResult.data?.isNotEmpty ?? false)) {
          prefs.setString(evnt.getPrefKey(), createEventResult.data);
          evString.write(evnt.eventName + '\n');
        }
      }
    }
  }

}