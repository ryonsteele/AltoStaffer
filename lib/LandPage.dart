

import 'package:alto_staffing/AltoUtils.dart';
import 'package:alto_staffing/AuthService.dart';
import 'package:alto_staffing/MessageCard.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/CalEvent.dart';
import 'models/Historicals.dart';
import 'ResourcesPage.dart';
import 'models/MessageObj.dart';
import 'models/shifts.dart';
import 'package:alto_staffing/Home.dart';
import 'ShiftPrefPage.dart';
import 'dart:convert';
import 'ShiftCard.dart';
import 'ContactPage.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class LandPage extends StatefulWidget {
  final String tempid;
  int backTrigger;

  LandPage({Key key, @required this.tempid, this.backTrigger}) : super(key: key);

  @override
  AppState createState() => AppState(this.tempid, this.backTrigger);
}

class AppState extends State<LandPage> with TickerProviderStateMixin, WidgetsBindingObserver{
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static String tempId = "";
  static int backTrigger = 0;
  String loadMessage = 'Loading....';
  static SharedPreferences prefs;
  DeviceCalendarPlugin _deviceCalendarPlugin;
  List<Calendar> _calendars;
  Calendar _selectedCalendar;
  List shifts;
  List openShifts;
  List<Shifts> histShifts;
  List newMessages;
  Historicals historicals;

  AppState(String tid, int backtrigger) {
    _deviceCalendarPlugin = new DeviceCalendarPlugin();
    tempId = tid;
    backTrigger = backtrigger;
  }

  @override
  void initState() {
    AltoUtils.initTimeZones();
    WidgetsBinding.instance.addObserver(this);
    if(this.shifts != null) {
      this.shifts.clear();
      this.shifts = null;
    }
    if(backTrigger == 0) {
      _retrieveCalendars();
      getScheduled(false);
      if(Home.openShifts != null) Home.openShifts.clear();
      getOpenData();
    }else if (backTrigger == 1){
      if(Home.openShifts == null || Home.openShifts.isEmpty) {
        getOpens();
      }
    }else{
      getHistData();
    }
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(final AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {
        _makePostTokenRequest();
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final List<String> _dropdownValues = [
      "Settings",
      "Contact Alto",
      "Shift Preferences",
      "HR Links",
      "Logout",
    ]; //The list of values we want on the dropdown
    String _currentlySelected = "Settings"; //var to hold currently selected value

    //make the drop down its own widget for readability
    Widget dropdownWidget() {
      return DropdownButton(
        //map each value from the lIst to our dropdownMenuItem widget
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 42,
        underline: SizedBox(),
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
            if(_currentlySelected.trim() != 'Settings'){

              if(_currentlySelected.trim() == "Contact Alto"){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => ContactPage()));

              }else if(_currentlySelected.trim() == "Shift Preferences"){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => ShiftPrefPage(tempid: AppState.tempId)));

              }else if(_currentlySelected.trim() == "HR Links"){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => ResourcesPage(tempid: AppState.tempId)));

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
          initialIndex: backTrigger,
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
              if(Home.openShifts == null || Home.openShifts.isEmpty) {
                getOpens();
              }
            }else if(index ==2) {
              getHistorical();
            }
          },
          tabs: [
            Tab(icon: Icon(Icons.calendar_today)),
            Tab(icon: Icon(Icons.local_offer)),
            Tab(icon: Icon(Icons.hourglass_full)),
//            Tab(icon: Icon(Icons.mail_outline)),
          ],
        ),
      ),
        backgroundColor: Color(0xFFDAE0E0),
        body:
        TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
        Center(
        child: loadingScheduledListView(this.shifts),
        ),
        Center(
         child: loadingOpensView(),
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

    } on Exception catch (exception) {
      print(exception);
      showConnectionDialog();
    }

    if(response.body.contains('html')) return null;
      setState(() {
        this.shifts=(json.decode(response.body) as List).map((i) =>
            Shifts.fromJson(i)).toList();
      });
      _addEventsToCalendar();
      if (this.shifts == null || this.shifts.isEmpty){
        setState(() {this.loadMessage = 'You have no shifts scheduled, please call Alto to schedule shifts.';});
      }
  }

  Future getHistorical() async {
    this.loadMessage = '  Loading....';
    this.shifts = new List<Shifts>();
    Response response;
    try {
      if(tempId == null || tempId.isEmpty){
        prefs = await SharedPreferences.getInstance();
        tempId = prefs.getString('temp_id') ?? '';
      }

      response = await http.get(AltoUtils.baseApiUrl + '/mobileshifts/history/' + tempId);

    } on Exception catch (exception) {
      print(exception);
      showConnectionDialog();
    }

    if(response.body.contains('html')) return null;
      setState(() {
        this.historicals=Historicals.fromJson(json.decode(response.body));
        if(this.historicals == null || this.historicals.shifts.isEmpty) {
          setState(() {
            this.loadMessage = '  You have no shifts completed, please call Alto to schedule shifts.';
          });
        }else {
          this.histShifts = this.historicals.shifts;
        }
      });


  }

  Future getOpens() async {

    this.openShifts = new List<Shifts>();
    this.loadMessage = '  Loading....';
    Response openResponse;
    try {
      openResponse = await http.get(AltoUtils.baseApiUrl + '/mobileshifts/open/' + tempId);

    } on Exception catch (exception) {
      print(exception);
      showConnectionDialog();
    }

    if(openResponse.body.contains('html')) {
        print(openResponse.body);
        return null;
      }

        this.openShifts=(json.decode(openResponse.body) as List).map((i) =>
            Shifts.fromJson(i)).toList();

        if (this.openShifts == null || this.openShifts.isEmpty){
          setState(() {this.loadMessage = '  You have no shifts scheduled, please call Alto to schedule shifts.';});
        }else{
            Home.openShifts = this.openShifts;
        }
      setState(() {});
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
            return Text(this.loadMessage,style: TextStyle(fontSize: 14.0,fontWeight: FontWeight.bold));
          });

    }
  }

  loadingHistoricalsListView() {
    if(this.histShifts != null && this.histShifts.isNotEmpty){

      return this.histShifts.length != 0
          ? RefreshIndicator( child: ListView.builder(
        itemCount: this.histShifts != null ? this.histShifts.length : 0,
        itemBuilder: (context, index) {

          //Shifts myModel = this.histShifts[index] as Shifts;
          this.histShifts[index].status="Hist";

          return ShiftCard(this.histShifts[index]);
        },),
        onRefresh: getHistData,
      )

          : Center(child: CircularProgressIndicator());
    }else{

      return ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            return Text(this.loadMessage,style: TextStyle(fontSize: 14.0,fontWeight: FontWeight.bold));
          });

    }
  }


  Future<void> getOpenData() async{
    if(this.openShifts != null) {
      this.openShifts.clear();
    }
    setState(() {
      if(Home.openShifts == null || Home.openShifts.isEmpty) {
        getOpens();
      }
    });
  }

  Future<void> getSchedData() async{
    this.shifts.clear();
    setState(() {
      getScheduled(false);
    });
  }

  Future<void> getHistData() async{
    if(this.histShifts != null) this.histShifts.clear();
    setState(() {
      getHistorical();
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

  loadingOpensView() {
    if(Home.openShifts != null && Home.openShifts.isNotEmpty){
      double c_width = MediaQuery.of(context).size.width;
      double c_height = MediaQuery.of(context).size.height*0.75;


      return Container(
        color: Color(0xFFDAE0E0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[

            Padding(padding: EdgeInsets.only(left: 0.0, bottom: 2, top: 5),
              child: Text(' pull down on list to refresh ', textAlign: TextAlign.center, style: TextStyle( color: Colors.black, fontSize: 11)),
            ),
            Padding(padding: EdgeInsets.only( top: 2),
              child: SizedBox(
                  height: c_height,
                  width: c_width,
                  child: loadingOpensListView(Home.openShifts)
              ),),
          ],), );

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
      double c_width = MediaQuery.of(context).size.width*0.9;
      double c_height = MediaQuery.of(context).size.height*0.60;


      return Container(
        color: Color(0xFFDAE0E0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[

          Padding(padding: EdgeInsets.only(left: 0.0, bottom: 5, top: 15),
              child: Text('Hours Worked Period ', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16)),
            ),
          Container(
         width: c_width,
          child: Padding(padding: EdgeInsets.only(right: 0.0, bottom: 15, top: 5),
              child: Text('${this.historicals.dateWindowBegin} to ${this.historicals.dateWindowEnd}', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 12)),
            ),
          ),
            Container(
              width: c_width,
              child: Padding(padding: EdgeInsets.only(right: 0.0, bottom: 2, top: 5),
                child: Text('Total Hours Scheduled: ${this.historicals.hoursScheduled}', textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16)),
              ),
            ),
            Container(
              width: c_width,
              child: Padding(padding: EdgeInsets.only(right: 0.0, bottom: 10, top: 0),
                child: Text('Period Hours Worked: ${this.historicals.hoursWorked}', textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16)),
              ),
            ),
            Container(
              width: c_width,
              child: Padding(padding: EdgeInsets.only(right: 0.0, bottom: 2, top: 5),
                child: Text('Shifts Completed Previous Two Weeks', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 12)),
              ),
            ),
            Padding(padding: EdgeInsets.only(right: 5, left: 5, top: 10),
              child: SizedBox(
               height: c_height,
               width: c_width,
               child: loadingHistoricalsListView()
        ),),
    ],), );

    }else{

      return ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            return Text(this.loadMessage);
          });

    }
  }

  showConnectionDialog() {

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

    for(String key in prefs.getKeys()){
      bool found = false;

      try {
        for (var shift in this.shifts) {

          var search = shift.clientName.substring(0,4) + new DateFormat("MM/dd/yyyy HH:mm a").parse(shift.shiftStartTime).toIso8601String();
          if(search == key){
            //print("Event match found");
            found = true;
          }
         }
      if(!found){
        //print("Event match NOT found, deleting event");
        await _deviceCalendarPlugin.deleteEvent(_selectedCalendar.id, prefs.getString(key));
      }
      }catch(e){
        //not a calendar event, move on
      }
    }

    //print("Adding new events");
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
        eventToCreate.end = new DateFormat("MM/dd/yyyy HH:mm a").parse(shift.shiftEndTime);
        eventToCreate.description = evnt.toString();
        String mmaEventId = prefs.getString(evnt.getPrefKey());
        if (mmaEventId != null) {
          eventToCreate.eventId = mmaEventId;
        }
        final createEventResult =
        await _deviceCalendarPlugin.createOrUpdateEvent(eventToCreate);
        if (createEventResult.isSuccess &&
            (createEventResult.data?.isNotEmpty ?? false)) {
          prefs.setString(evnt.getPrefKey(), createEventResult.data);
          print("Adding new event: " + createEventResult.data + " With Key: " + evnt.getPrefKey());
          evString.write(evnt.eventName + '\n');
        }
      }
    }
  }

  Future _makePostTokenRequest() async {
    try{
      // set up POST request arguments
      String url = AltoUtils.baseApiUrl + '/token';
      Map<String, String> headers = {"Content-type": "application/json"};
      AuthService auth = new AuthService();
      String token = Home.deviceToken;
      if(token == null || token.isEmpty || Home.myUserName == null || Home.myUserName.isEmpty) return;

      String json = '{"username": "'+ Home.myUserName+'", "devicetoken": "'+token+'"}';

      // make POST request
      Response response = await post(url, headers: headers, body: json);
      int statusCode = response.statusCode;
      String body = response.body;

    } on Exception catch (exception) {
      print(exception);
    }
  }

}
