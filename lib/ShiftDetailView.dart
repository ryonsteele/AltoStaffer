

import 'dart:async';
import 'dart:io';

import 'package:alto_staffing/AltoUtils.dart';
import 'package:alto_staffing/LandPage.dart';
import 'package:alto_staffing/models/ClientAddress.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:alto_staffing/models/shifts.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:core';
import 'package:alto_staffing/models/ApiShift.dart';
import 'package:sliding_button/sliding_button.dart';
import 'package:http/http.dart';
import 'package:alto_staffing/Home.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:timezone/timezone.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'ResourcesPage.dart';

class ShiftDetailView extends StatefulWidget {

  final Shifts data;

  ShiftDetailView({Key key, @required this.data}) : super(key: key);

  @override
  _ShiftDetailView createState() => _ShiftDetailView(this.data);
}


class _ShiftDetailView extends State<ShiftDetailView> with WidgetsBindingObserver {

  final GlobalKey<SlidingButtonState> _slideButtonKey = GlobalKey<SlidingButtonState>();
  TextEditingController _fNameFieldController = TextEditingController();
  TextEditingController _lNameFieldController = TextEditingController();
  TextEditingController _titleFieldController = TextEditingController();
  Position _currentPosition;
  String _currentAddy;
  static const int OPEN_SHIFT = 0;
  static const int CHECKED_IN = 1;
  static const int CHECKED_OUT = 4;
  static SharedPreferences prefs;
  static Color sliderColor = Colors.blue;
  static String statusText = "";
  static MaterialColor statusColor = Colors.lightBlue;
  static String sliderStatus = "Slide to Clock In/out";
  static bool isLoading = false;
  static String locationLocal;
  String optionalNoteText = "";
  Widget myButton;
  ClientAddress myClientAddy = new ClientAddress("","","","","","","");

  static int currentStatus = 0;
  static int backTrigger = 0;

  List<String> litems;
  Shifts data;
  String gTempId;

  _ShiftDetailView(Shifts data) {
    WidgetsBinding.instance.addObserver(this);
    this.data = data;
    //getPerms();
    tz.initializeTimeZones();
    loadInit();
  }


  @override
  void didChangeAppLifecycleState(final AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print('Resumed state');
      loadInit();
    }
  }


  Future loadInit() async {
    backTrigger = 0;
    sliderStatus = "Slide to Clock In/out";

    if(this.data.status == 'Open') {
      backTrigger = 1;
      sliderStatus = "Slide to Confirm Interest in Shift";
      sliderColor = Colors.orangeAccent;
      statusText = 'OPEN';
      statusColor = Colors.orange;
      myButton = getMyButton();
      _makeInterestGetRequest();
      return;
    }

    _getClient();
    _getCurrentLocationInit();
    _makeGetRequest();

  }



  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
    isLoading = false;

  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent) {

    Navigator.of(context).pushReplacement( MaterialPageRoute(builder: (context) => LandPage(tempid: gTempId, backTrigger: backTrigger)));

    return true;
  }

  showAlertDialog() async {

    bool cont = false;

    Dialog superDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
      child: Container(
        height: 300.0,
        width: 300.0,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Padding(
              padding:  EdgeInsets.all(3.0),
              child: Text("Facility Supervisor on Duty"),
            ),
            Padding(
              padding:  EdgeInsets.all(3.0),
              child: TextField(
                controller: _fNameFieldController,
                decoration: InputDecoration(hintText: "Facility Sup. FirstName"),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(3.0),
              child: TextField(
                controller: _lNameFieldController,
                decoration: InputDecoration(hintText: "Facility Sup. LastName"),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(3.0),
              child: TextField(
                controller: _titleFieldController,
                decoration: InputDecoration(hintText: "Facility Sup. Title"),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 7.0)),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
            FlatButton(onPressed: (){
              if(_fNameFieldController.text == null || _fNameFieldController.text.isEmpty ||
                  _lNameFieldController.text == null || _lNameFieldController.text.isEmpty ||
                  _titleFieldController.text == null || _titleFieldController.text.isEmpty){
                return;
              }
              cont = true;
              Navigator.of(context, rootNavigator: true).pop();

            },
                child: Text('OK', style: TextStyle(color: Colors.purple, fontSize: 18.0),)),
               FlatButton(onPressed: (){
                  Navigator.of(context, rootNavigator: true).pop();
                  setState(() {
                  isLoading = false;
                  myButton = getMyButton();
              });
            },
                child: Text('Cancel', style: TextStyle(color: Colors.purple, fontSize: 18.0),))
            ],),
          ],
        ),
      ),
    );

    await showDialog(barrierDismissible: false, context: context, builder: (BuildContext context) => superDialog);

    isLoading = false;
    if(cont) {

      if (currentStatus >= CHECKED_OUT) {
        myButton = null;
      } else {
        myButton = getMyButton();
      }
      setState(() {});
      await _getCurrentLocation();

      if (_currentPosition == null) {
        await showLocationFailureDialog();
      }

      if (currentStatus == OPEN_SHIFT) {
         await _makePostRequest(_currentAddy, _currentPosition.latitude,
            _currentPosition.longitude);
      } else {
        await showBreakDialog();
      }
    }

  }

  Widget getMyButton(){

    if(isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }else {
      return new SlidingButton(
        key: _slideButtonKey,
        buttonHeight: 60,
        buttonText: sliderStatus,
        buttonColor: sliderColor,
        successfulThreshold: 0.9,
        slideButtonIconColor: Color(0xFF05152B),
        radius: 8,
        onSlideSuccessCallback: () async {
          myButton = Center(child: CircularProgressIndicator());

          Future.delayed(Duration(seconds: 1), () {
            if (_slideButtonKey != null &&
                _slideButtonKey.currentState != null) {
              isLoading = true;
              _slideButtonKey.currentState.reset();
            }
            return;
          });

          if (this.data.status == 'Open') {
            await _postShiftInterest();
            return;
          } else {

            var newDateTimeObj2 = new DateFormat.yMd().add_jm().parse(this.data.shiftStartTime);
            var date2 = DateTime.now();

            if(currentStatus == CHECKED_IN){
              await showAlertDialog();
              return;
            }

            if( newDateTimeObj2.day == date2.day && newDateTimeObj2.month == date2.month ) {
              await showAlertDialog();
            }else{
              await showOutOfWindowDialog();
              isLoading = false;
              myButton = getMyButton();
            }
          }
        },);
    }
  }


  @override
  Widget build(BuildContext context) {

    if(this.data == null){
      return new Container();
    }

    final List<String> _dropdownValues = [
      "Settings",
      "HR Links",
      "Logout"
    ]; //The list of values we want on the dropdown
    String _currentlySelected = ""; //var to hold currently selected value

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
            if(_currentlySelected.trim() == "HR Links"){
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ResourcesPage(tempid: gTempId)));

            }else if(_currentlySelected.trim() == "Logout"){
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => Home(bypassSplash: false,)));
            }
          });
        },
        //this wont make dropdown expanded and fill the horizontal space
        isExpanded: false,
        //make default value of dropdown the first value of our list
        value: _dropdownValues.first,
      );
    }

    double c_width = MediaQuery.of(context).size.width*0.8;

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Shift Details'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushReplacement( MaterialPageRoute(builder: (context) => LandPage(tempid: gTempId, backTrigger: backTrigger,)));
            },
          ),
          //Add the dropdown widget to the `Action` part of our appBar. it can also be among the `leading` part
          dropdownWidget(),
        ],
        backgroundColor: Color(0xFF0B859E),
      ),
      body: new Container(
        decoration: new BoxDecoration(
          color: Color(0xFFDAE0E0),
          border: new Border.all(color: Colors.black, width: 5.0),
          borderRadius: new BorderRadius.all(Radius.circular(10)),
        ),
        margin: const EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0, bottom: 5.0),
        child:new SingleChildScrollView(
        child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: c_width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                   Padding(padding: EdgeInsets.only(left: 25.0, top: 25),
                      child: Text('OrderID:${this.data.orderId}', textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 14)),
                    ),
                    Container(
                    child: Padding(padding: EdgeInsets.only(right: 25.0, top: 25),
                      child: Container(

                        child: Text(' Status: ${statusText} ', textAlign: TextAlign.end, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, backgroundColor: statusColor)),
                        ),),
                    ),
                  ]),
              ),
              Container(
                width: c_width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                     Padding(padding: EdgeInsets.only(left: 25.0, top: 25),

                      child: Text('${this.data.clientName}', textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 14)),
                  ),
                  ]),
                ),
            Container(
              width: c_width,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(left: 25.0, top: 8),
                      child: Text('${this.data.regionName}', textAlign: TextAlign.start, style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black, fontSize: 14)),
                    ),
                  ]),
            ),
            Container(
              width: c_width,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(left: 25.0, top: 8),
                      child: Text('Shift Start: ', textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 14)),
                    ),
                    Padding(padding: EdgeInsets.only(right: 25.0, top: 8),
                      child: Text('${this.data.shiftStartTime}', textAlign: TextAlign.end, style: TextStyle( fontSize: 14)),
                    ),
                  ]),
            ),
            Container(
              width: c_width,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(left: 25.0, top: 8),
                      child: Text('Shift End: ', textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 14)),
                    ),
                    Padding(padding: EdgeInsets.only(right: 25.0, top: 8),
                      child: Text('${this.data.shiftEndTime}', textAlign: TextAlign.end, style: TextStyle(fontSize: 14)),
                    ),
                  ]),
           ),
            Container(
              width: c_width,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(left: 25.0, top: 8),
                      child: Text('Floor: ', textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 14)),
                    ),
                    Padding(padding: EdgeInsets.only(right: 25.0, top: 8),
                      child: Text('${this.data.floor}', textAlign: TextAlign.end, style: TextStyle(fontSize: 14)),
                    ),
                  ]),
            ),
           Container(
            width: c_width,
            child: Padding(padding: EdgeInsets.only(right: 25.0, top: 18),
                child: RaisedButton(
                  onPressed: () =>
                  {
                    if (this.data.status != 'Open') {
                      MapsLauncher.launchQuery('${this.myClientAddy.address}, ${this.myClientAddy.city}, ${this.myClientAddy.state} ${this.myClientAddy.zip}, USA'),
                    }
                  },
                  child: Text('${this.myClientAddy.address} ${this.myClientAddy.city} ${this.myClientAddy.state} ${this.myClientAddy.zip}', textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 12)),
                ),
              ),
            ),
            Container(
              width: c_width,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(left: 25.0, top: 8),
                      child: Text('Specialty: ', textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 14)),
                    ),
                    Padding(padding: EdgeInsets.only(right: 25.0, top: 8),
                      child: Text('${this.data.orderSpecialty}', textAlign: TextAlign.end, style: TextStyle(fontSize: 14)),
                    ),
                  ]),
            ),
           Container(
              width: c_width,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(left: 25.0, top: 8),
                      child: Text('Certification: ', textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 14)),
                    ),
                    Padding(padding: EdgeInsets.only(right: 25.0, top: 8),
                      child: Text('${this.data.orderCertification}', textAlign: TextAlign.end, style: TextStyle(fontSize: 14)),
                    ),
                  ]),
            ),
              Padding(padding: EdgeInsets.only(right: 25.0, top: 18),
                child: Text('NOTES', textAlign: TextAlign.center, style: TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18)),
              ),
              Container(
                width: c_width,
                child:
                Padding(padding: EdgeInsets.only(right: 25.0, top: 18, bottom: 125),
                child: Text('${this.optionalNoteText} \n ${this.data.note}', textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 13)),
              ),
                  ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: c_width,
                  child: Padding(padding: EdgeInsets.only(right: 25.0, bottom: 100),
                   child:  myButton
                ),
                ),
              ),
            ],
        ),
    ),),);
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(),
    );
  }

  Future _postShiftInterest() async {
    try{
    // set up POST request arguments
    String url = AltoUtils.baseApiUrl + '/openshift';
    Map<String, String> headers = {"Content-type": "application/json"};
    prefs = await SharedPreferences.getInstance();
    String tempid = prefs.getString('temp_id') ?? '';

    String json = '{"tempId": "'+ tempid+'", "username": "'+Home.myUserName + '", "orderId": "'+ this.data.orderId+'"}';

    // make POST request
    print(json);
    Response response = await post(url, headers: headers, body: json).timeout(const Duration(seconds: 15));
    // check the status code for the result
    int statusCode = response.statusCode;
    // this API passes back the id of the new item added to the body
    String body = response.body;

    if(statusCode >= 200 && statusCode < 300){
      await showInterestSuccessDialog();
    }else{
      if(Home.openShifts != null) Home.openShifts.clear();
      await showStaleShiftDialog();
    }

    } on TimeoutException catch (exception) {
      print(exception);
      await showConnectionDialog();
    } on SocketException catch (exception) {
      print(exception);
      await showConnectionDialog();
    }
    isLoading = false;
    setState(() {myButton = null;});
  }

  Future _makePostRequest(String currentAddy, double lat, double lon) async {


    // set up POST request arguments
    String url = AltoUtils.baseApiUrl + '/shift';
    Map<String, String> headers = {"Content-type": "application/json"};
    var signOff = _fNameFieldController.text.trim() + " " + _lNameFieldController.text.trim() + " | " + _titleFieldController.text.trim();
    int statusCode = 0;

    //debug
//    lat = 39.635568;
//    lon = -84.201236;

    try{

    StringBuffer buffer = new StringBuffer();
    buffer.write('{"tempId": "');
    buffer.write(this.data.tempId);
    buffer.write('", "username": "');
    buffer.write(Home.myUserName);
    buffer.write('", "clockedAddy": "');
    buffer.write(currentAddy);
    buffer.write('", "lat": "');
    buffer.write(lat.toString());
    buffer.write('", "lon": "');
    buffer.write(lon.toString());
    buffer.write('", "shiftstatuskey": "');
    buffer.write(currentStatus.toString());
    buffer.write('", "shiftSignoff": "');
    buffer.write(signOff);
    buffer.write('", "orderId": "');
    buffer.write(this.data.orderId);
    buffer.write('", "clientId": "');
    buffer.write(this.data.clientId);
    buffer.write('" }');
    String json = buffer.toString();

    // make POST request
    Response response = await post(url, headers: headers, body: json).timeout(const Duration(seconds: 15));

    // check the status code for the result
    statusCode = response.statusCode;
    // this API passes back the id of the new item added to the body
    String body = response.body;
    } on TimeoutException catch (exception) {
      print(exception);
      await showConnectionDialog();
    } on SocketException catch (exception) {
      print(exception);
      await showConnectionDialog();
    }

    if(statusCode >= 200 && statusCode < 300) {
      currentStatus = CHECKED_IN;
      await showClockSuccessDialog(false);
    }else if(statusCode == 400){
      await showInvalidGeoDialog();
    }

    isLoading = false;
    setState(() {myButton = getMyButton();});
  }

  Future _makePatchRequest(String currentAddy, double lat, double lon, bool tookBreak) async {

    int statusCode = 0;
    String url = AltoUtils.baseApiUrl + '/shift';
    Map<String, String> headers = {"Content-type": "application/json"};

    try{
      Navigator.of(context, rootNavigator: true).pop('dialog');

    //debug
//      lat = 39.635568;
//      lon = -84.201236;

    var signOff = _fNameFieldController.text.trim() + " " + _lNameFieldController.text.trim() + " | " + _titleFieldController.text.trim();

      StringBuffer buffer = new StringBuffer();
      buffer.write('{"tempId": "');
      buffer.write(this.data.tempId);
      buffer.write('", "username": "');
      buffer.write(Home.myUserName);
      buffer.write('", "clockedAddy": "');
      buffer.write(currentAddy);
      buffer.write('", "lat": "');
      buffer.write(lat.toString());
      buffer.write('", "lon": "');
      buffer.write(lon.toString());
      buffer.write('", "shiftstatuskey": "');
      buffer.write(currentStatus.toString());
      buffer.write('", "shiftSignoff": "');
      buffer.write(signOff);
      buffer.write('", "orderId": "');
      buffer.write(this.data.orderId);
      buffer.write('", "clientId": "');
      buffer.write(this.data.clientId);
      buffer.write('", "breaks": "');
      buffer.write(tookBreak.toString());
      buffer.write('" }');
      String json = buffer.toString();


    // make POST request
    Response response = await patch(url, headers: headers, body: json).timeout(const Duration(seconds: 15));
    // check the status code for the result
    statusCode = response.statusCode;
    // this API passes back the id of the new item added to the body
    String body = response.body;
    } on TimeoutException catch (exception) {
      print(exception);
      await showConnectionDialog();
    } on SocketException catch (exception) {
      print(exception);
      await showConnectionDialog();
    }

    if(statusCode >= 200 && statusCode < 300){
      currentStatus++;
      if(currentStatus >= CHECKED_OUT){
        myButton = null;
      }
      await showClockSuccessDialog( true);
    }else if(statusCode == 400){
      await showInvalidGeoDialog();
    }

    isLoading = false;
    setState(() {myButton = getMyButton();});
  }

  Future _getClient() async {

    String url = AltoUtils.baseApiUrl + '/client/'+this.data.clientId;
    Map<String, String> headers = {"Content-type": "application/json"};

    Response response = await get(url, headers: headers).timeout(const Duration(seconds: 15));
    // check the status code for the result
    int statusCode = response.statusCode;


    if(statusCode >= 200 && statusCode < 300) {
      String body = response.body;
      final Map parsed = json.decode(body);
      final clientAddy = ClientAddress.fromJson(parsed);

      if(clientAddy.address != null){
        setState(() {
          this.myClientAddy = clientAddy;
        });
      }
    }

  }

  Future _makeGetRequest() async {
    // set up POST request arguments

    String url = AltoUtils.baseApiUrl + '/shift/'+this.data.orderId;
    Map<String, String> headers = {"Content-type": "application/json"};
    Response response;
    int statusCode = 0;

    try{
      response = await get(url, headers: headers).timeout(const Duration(seconds: 15));

    } on TimeoutException catch (exception) {
      print(exception);
      await showConnectionDialog();
    } on SocketException catch (exception) {
      print(exception);
      await showConnectionDialog();
    }
      // check the status code for the result
    if(response != null) {
      statusCode = response.statusCode;
    }


    if(statusCode >= 200 && statusCode < 300){

      String body = response.body;
      if(body == null || body.isEmpty){

        setState(() {
          currentStatus = 0;
          _setStatusText(currentStatus);
          myButton = getMyButton();
        });

        return;
      }

      final Map parsed = json.decode(body);
      final liveShift = ApiShift.fromJson(parsed);

      if(liveShift.shiftStartTimeActual == null){
        currentStatus = OPEN_SHIFT;

      } else if(liveShift.shiftEndTimeActual != null){
        this.optionalNoteText = "Clocked in at: " + formatDates(liveShift.shiftStartTimeActual) +" \nClocked out at: " + formatDates(liveShift.shiftEndTimeActual);
        currentStatus = CHECKED_OUT;
        backTrigger = 2;
        myButton = null;

      }else{
        currentStatus = CHECKED_IN;
        myButton = getMyButton();
      }

      setState(() {
        _setStatusText(currentStatus);
      });
    }

  }

  Future _makeInterestGetRequest() async {
    try{
    // set up POST request arguments
    prefs = await SharedPreferences.getInstance();
    gTempId = prefs.getString('temp_id') ?? '';
    String url = AltoUtils.baseApiUrl + '/openshift/'+this.data.orderId+'/'+gTempId;
    Map<String, String> headers = {"Content-type": "application/json"};

    // make POST request
    Response response = await get(url, headers: headers).timeout(const Duration(seconds: 15));
    // check the status code for the result
    int statusCode = response.statusCode;

    if(statusCode >= 200 && statusCode < 300){

      String body = response.body;
      if(body != null && !body.isEmpty){
        statusText = 'Submitted';
        myButton = null;
        setState(() {});
        return;
      }
    }

    } on TimeoutException catch (exception) {
      print(exception);
      await showConnectionDialog();
    } on SocketException catch (exception) {
      print(exception);
      await showConnectionDialog();
    }
    setState(() {});
  }

  _setStatusText(int stat){

    if(stat == CHECKED_IN){
      statusText = 'ON SHIFT';
      statusColor = Colors.lightGreen;
      sliderColor = Colors.lightGreen;
    }
    if(stat == CHECKED_OUT){
      statusText = 'SHIFT END';
      statusColor = Colors.blueGrey;
      sliderColor = Colors.blueGrey;
      return;
    }
    if(stat == OPEN_SHIFT){
      statusText = 'COMMITTED';
      statusColor = Colors.blue;
      sliderColor = Colors.blue;
    }else {
      myButton = getMyButton();
    }
  }

   _getCurrentLocation() async {

     try {
       _currentPosition = await getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
     } on Exception catch (exception) {
       _currentPosition = null;
       myButton = null;
       isLoading = false;
     } catch (error) {
       _currentPosition = null;
       myButton = null;
       isLoading = false;
     }

  }

  _getCurrentLocationInit() async{

    try {
      _currentPosition = await getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
    } on Exception catch (exception) {
       _currentPosition = null;
        myButton = null;
        isLoading = false;
    } catch (error) {
       _currentPosition = null;
        myButton = null;
        isLoading = false;
    }

  }

  showOutOfWindowDialog() {

    Widget continueButton = FlatButton(
      child: Text("Ok"),
      onPressed:  () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('Invalid Clock In'),
      content: Text("Clocking In is only available the day the Shift is Scheduled."),
      actions: [
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showBreakDialog() async {

    Widget continueButton = FlatButton(
      child: Text("Yes"),
      onPressed:  () async {
        //Navigator.of(context, rootNavigator: true).pop('dialog');
         await _makePatchRequest(_currentAddy, _currentPosition.latitude,
            _currentPosition.longitude, true);
      },
    );

    Widget cancelButton = FlatButton(
      child: Text("No"),
      onPressed:  () async {
        //Navigator.of(context, rootNavigator: true).pop('dialog');
        await _makePatchRequest(_currentAddy, _currentPosition.latitude,
            _currentPosition.longitude, false);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('Did you take a break?'),
      content: Text("Please click yes if you took a break during this shift"),
      actions: [
        continueButton,
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showLocationFailureDialog() async {

      Widget continueButton = FlatButton(
        child: Text("Ok"),
        onPressed:  () {
          Navigator.of(context, rootNavigator: true).pop('dialog');
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text('Location Permissions Not Enabled'),
        content: Text("You declined location permissions on this device and will not be allowed to clock in or out. Please Enable Location for this App in your device Settings"),
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

  showConnectionDialog() async {

    Widget continueButton = FlatButton(
      child: Text("Ok"),
      onPressed:  () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        isLoading = false;
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('There\'s been a connection issue!'),
      content: Text("Please check you network, restart the app or try again soon"),
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


  showStaleShiftDialog() {

    Widget continueButton = FlatButton(
      child: Text("Ok"),
      onPressed:  () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('There\'s been an issue sending interest in shift'),
      content: Text("It is likely the shift is no longer available and the list on your device is stale. \nPlease refresh your Open shift list by dragging downward on the list itself."),
      actions: [
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  showInterestSuccessDialog() {


    Widget continueButton = FlatButton(
      child: Text("Ok"),
      onPressed:  () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        Navigator.of(context).pushReplacement( MaterialPageRoute(builder: (context) => LandPage(tempid: gTempId, backTrigger: backTrigger,)));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('Interest Submitted'),
      content: Text("Someone from Alto should reach out soon!"),
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

  showClockSuccessDialog( bool clockout) {

    String message = "You have successfully clocked in your shift";
    if(clockout) {
      message = "You have successfully clocked out of your shift";
    }

    Widget continueButton = FlatButton(
      child: Text("Ok"),
      onPressed:  () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        Navigator.of(context).pushReplacement( MaterialPageRoute(builder: (context) => LandPage(tempid: gTempId, backTrigger: backTrigger,)));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('Operation Successful!'),
      content: Text(message),
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

  String formatDates(String sDate){

    DateTime dateTime =  DateTime.parse(sDate);
    var ny = getLocation('US/Eastern');
    var date = TZDateTime.from(dateTime, ny);
    return DateFormat.yMd().add_jm().format(date);
  }

  showInvalidGeoDialog() {


    Widget continueButton = FlatButton(
      child: Text("Ok"),
      onPressed:  () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('Invalid GPS Location'),
      content: Text("Your device is reporting it is not at the correct location. \nThis attempt has been recorded."),
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