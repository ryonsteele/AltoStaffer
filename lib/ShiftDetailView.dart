

import 'package:alto_staffing/AltoUtils.dart';
import 'package:alto_staffing/models/shifts.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:alto_staffing/models/ApiShift.dart';
import 'package:sliding_button/sliding_button.dart';
import 'package:http/http.dart';
import 'package:alto_staffing/Home.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class ShiftDetailView extends StatefulWidget {

  final Shifts data;

  ShiftDetailView({Key key, @required this.data}) : super(key: key);

  @override
  _ShiftDetailView createState() => _ShiftDetailView(this.data);
}


class _ShiftDetailView extends State<ShiftDetailView> {

  final GlobalKey<SlidingButtonState> _slideButtonKey = GlobalKey<SlidingButtonState>();
  TextEditingController _textFieldController = TextEditingController();
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  String _currentAddress;
  static const int OPEN_SHIFT = 0;
  static const int CHECKED_IN = 1;
  static const int CHECKED_OUT_BRK = 2;
  static const int CHECKED_IN_BRK = 3;
  static const int CHECKED_OUT = 4;
  static SharedPreferences prefs;
  static Color sliderColor = Colors.blue;
  static String statusText = "";
  static MaterialColor statusColor = Colors.lightBlue;
  static String sliderStatus = "Slide to Change Status...";
  SlidingButton myButton;

  static int currentStatus = 0;

  List<String> litems;
  Shifts data;

  _ShiftDetailView(Shifts data) {
    this.data = data;
    loadInit();
  }

  Future loadInit() async {

    if(this.data.status == 'Open') {
      sliderColor = Colors.orangeAccent;
      statusText = 'OPEN';
      statusColor = Colors.orange;
      myButton = getMyButton();
      _makeInterestGetRequest();
      return;
    }
    _getCurrentLocationInit();
    _makeGetRequest();
  }


  showAlertDialog(BuildContext context) {

    String title = "";
    TextField content;

    if(currentStatus == OPEN_SHIFT){
      title = "Check In for Shift?";
      content = TextField(
        controller: _textFieldController,
        decoration: InputDecoration(hintText: "Supervisor Initials..."),
      );
    }
    if(currentStatus == CHECKED_IN){
      title = "Check Out for Break?";
      content = null;
    }
    if(currentStatus == CHECKED_OUT_BRK){
      title = "Check In from Break?";
      content = null;
    }
    if(currentStatus == CHECKED_IN_BRK){
      title = "Check Out from Shift?";
      content = TextField(
        controller: _textFieldController,
        decoration: InputDecoration(hintText: "Supervisor Initials..."),
      );
    }

    setState(() {});


    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Confirm"),
      onPressed:  () {
        if(this.data.status == 'Open'){
          _postShiftInterest();
          return;
        }

        Navigator.of(context, rootNavigator: true).pop('dialog');
        _getCurrentLocation();
        if(currentStatus >= CHECKED_OUT){
          myButton = null;
          setState(() {});
        }
       },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: content,
      actions: [
        cancelButton,
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

  SlidingButton getMyButton(){
    return SlidingButton(
      key: _slideButtonKey,
      buttonHeight: 60,
      buttonText: sliderStatus,
      buttonColor: sliderColor,
      slideButtonIconColor: Color(0xFF05152B),
      radius: 8,
      onSlideSuccessCallback: () {
        //_incrementCounter();
        if(this.data.status == 'Open') {
          _postShiftInterest();
        }else {
          showAlertDialog(context);
        }
        Future.delayed(Duration(seconds: 1), () {
          if(_slideButtonKey != null && _slideButtonKey.currentState != null) {
            _slideButtonKey.currentState.reset();
          }
        });
        },);
  }


  @override
  Widget build(BuildContext context) {

    if(this.data == null){
      return new Container();
    }

    final List<String> _dropdownValues = [
      "  ",
      "Sent Home"
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
              showSentHomeDialog(context);
            }
          });
        },
        //this wont make dropdown expanded and fill the horizontal space
        isExpanded: false,
        //make default value of dropdown the first value of our list
        value: _dropdownValues.first,
      );
    }


    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Shift Details'),
        actions: <Widget>[
          //Add the dropdown widget to the `Action` part of our appBar. it can also be among the `leading` part
          dropdownWidget(),
        ],
        backgroundColor: Color(0xFF0B859E),
      ),
      body: new Container(
        decoration: new BoxDecoration(
          color: Colors.white,
          border: new Border.all(color: Colors.black, width: 5.0),
          borderRadius: new BorderRadius.all(Radius.circular(10)),
        ),
        margin: const EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0, bottom: 5.0),
        child:
        Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(left: 25.0, top: 25),
                      child: Text('OrderID:${this.data.orderId}', textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18)),
                    ),
                    Padding(padding: EdgeInsets.only(right: 25.0, top: 25),
                      child: Text('Status: ${statusText}', textAlign: TextAlign.end, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, backgroundColor: statusColor)),
                    ),
                  ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(left: 25.0, top: 25),
                      child: Text('${this.data.clientName}', textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18)),
                    ),
                  ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(left: 25.0, top: 8),
                      child: Text('${this.data.regionName}', textAlign: TextAlign.start, style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black, fontSize: 18)),
                    ),
                  ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(left: 25.0, top: 25),
                      child: Text('Shift Start: ', textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18)),
                    ),
                    Padding(padding: EdgeInsets.only(right: 25.0, top: 8),
                      child: Text('${this.data.shiftStartTime}', textAlign: TextAlign.end, style: TextStyle( fontSize: 18)),
                    ),
                  ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(left: 25.0, top: 8),
                      child: Text('Shift End: ', textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18)),
                    ),
                    Padding(padding: EdgeInsets.only(right: 25.0, top: 8),
                      child: Text('${this.data.shiftEndTime}', textAlign: TextAlign.end, style: TextStyle(fontSize: 18)),
                    ),
                  ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(left: 25.0, top: 25),
                      child: Text('Specialty: ', textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18)),
                    ),
                    Padding(padding: EdgeInsets.only(right: 25.0, top: 8),
                      child: Text('${this.data.orderSpecialty}', textAlign: TextAlign.end, style: TextStyle(fontSize: 18)),
                    ),
                  ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(left: 25.0, top: 8),
                      child: Text('Certification: ', textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18)),
                    ),
                    Padding(padding: EdgeInsets.only(right: 25.0, top: 8),
                      child: Text('${this.data.orderCertification}', textAlign: TextAlign.end, style: TextStyle(fontSize: 18)),
                    ),
                  ]),
              Padding(padding: EdgeInsets.only(right: 25.0, top: 18),
                child: Text('NOTES', textAlign: TextAlign.center, style: TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.bold, color: Colors.black, fontSize: 22)),
              ),
              Padding(padding: EdgeInsets.only(right: 25.0, top: 18),
                child: Text('${this.data.note}', textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 16)),
              ),

              Padding(padding: EdgeInsets.only(right: 25.0, top: 18),
                child: Text('${this.data.note}', textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 16)),
              ),
           Expanded(
             child:
              Align(
                alignment: Alignment.bottomCenter,
                child:
                  myButton
              ),
              ),
            ],
        ),
      ),
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
    Response response = await post(url, headers: headers, body: json);
    // check the status code for the result
    int statusCode = response.statusCode;
    // this API passes back the id of the new item added to the body
    String body = response.body;

    if(statusCode >= 200 && statusCode < 300){
      Navigator.of(context).pop();
    }else{
      showConnectionDialog(context);
    }

    } on Exception catch (exception) {
      print(exception);
      showConnectionDialog(context);
    } catch (error) {
      print(error);
      showConnectionDialog(context);
    }
  }

  Future _makePostRequest(String currentAddy, double lat, double lon) async {
    try{
    // set up POST request arguments
    String url = AltoUtils.baseApiUrl + '/shift';
    Map<String, String> headers = {"Content-type": "application/json"};

    String json = '{"tempId": "'+ this.data.tempId+'", "username": "'+Home.myUserName+'",' +'"clockedAddy": "'+ currentAddy+
        '",' +'"lat": "'+ lat.toString()+'",' +'"lon": "'+ lon.toString()+ '",' +'"shiftstatuskey": "'+ currentStatus.toString()+
        '", "shiftSignoff": "'+ _textFieldController.text+ '", "orderId": "'+ this.data.orderId+'"}';

    // make POST request
   // print(json);
    Response response = await post(url, headers: headers, body: json);
    // check the status code for the result
    int statusCode = response.statusCode;
    // this API passes back the id of the new item added to the body
    String body = response.body;

    if(statusCode >= 200 && statusCode < 300){
      currentStatus = CHECKED_IN;
      Navigator.of(context).pop();
      //_setStatusText(currentStatus);
    }else{
      showConnectionDialog(context);
    }

    } on Exception catch (exception) {
      print(exception);
      showConnectionDialog(context);
    } catch (error) {
      print(error);
      showConnectionDialog(context);
    }
    setState(() {});
  }

  Future
  _makeSentHomeRequest() async {
    try{
      // set up POST request arguments
      String url = AltoUtils.baseApiUrl + '/orderreturn';
      Map<String, String> headers = {"Content-type": "application/json"};

      String json = '{"tempId": "'+ this.data.tempId+'", "username": "'+Home.myUserName+'",' +'"clientName": "'+ this.data.clientName+'"}';

      // make POST request
     // print(json);
      Response response = await post(url, headers: headers, body: json);
      // check the status code for the result
      int statusCode = response.statusCode;
      // this API passes back the id of the new item added to the body
      String body = response.body;

      if(statusCode >= 200 && statusCode < 300){
        currentStatus = CHECKED_OUT;
        showSentHomeDialog(context);

      }else{
        showConnectionDialog(context);
      }

    } on Exception catch (exception) {
      print(exception);
      showConnectionDialog(context);
    } catch (error) {
      print(error);
      showConnectionDialog(context);
    }
    Navigator.of(context).pop();
    UrlLauncher.launch('tel:+1 205 388 0478');
    currentStatus = CHECKED_OUT;
    myButton = getMyButton();
    setState(() {});
  }

  Future _makePatchRequest(String currentAddy, double lat, double lon) async {
    try{
    // set up POST request arguments
    String url = AltoUtils.baseApiUrl + '/shift';
    Map<String, String> headers = {"Content-type": "application/json"};

    String json = '{"tempId": "'+ this.data.tempId+'", "username": "'+Home.myUserName+'",' +' "clockedAddy": "'+ currentAddy+
        '",' +' "lat": "'+ lat.toString()+'",' +' "lon": "'+ lon.toString()+ '",' +'"shiftstatuskey": "'+ currentStatus.toString()+
        '", "shiftSignoff": "'+ _textFieldController.text+ '", "orderId": "'+ this.data.orderId+'"}';

    // make POST request
    Response response = await patch(url, headers: headers, body: json);
    // check the status code for the result
    int statusCode = response.statusCode;
    // this API passes back the id of the new item added to the body
    String body = response.body;

    if(statusCode >= 200 && statusCode < 300){
      currentStatus++;
      //_setStatusText(currentStatus);
      if(currentStatus >= CHECKED_OUT){
        myButton = null;
      }
      Navigator.of(context).pop();
    }else{
      showConnectionDialog(context);
    }

    } on Exception catch (exception) {
      print(exception);
      showConnectionDialog(context);
    } catch (error) {
      print(error);
      showConnectionDialog(context);
    }
    setState(() {});
  }

  Future _makeGetRequest() async {
    // set up POST request arguments
    try{
    String url = AltoUtils.baseApiUrl + '/shift/'+this.data.orderId;
    Map<String, String> headers = {"Content-type": "application/json"};


    // make POST request
    Response response = await get(url, headers: headers);
    // check the status code for the result
    int statusCode = response.statusCode;


    if(statusCode >= 200 && statusCode < 300){

      String body = response.body;
      if(body == null || body.isEmpty){

        setState(() {
          currentStatus = 0;
          statusText = 'OPEN';
          _setStatusText(currentStatus);
          var newDateTimeObj2 = new DateFormat.yMd().add_jm().parse(this.data.shiftStartTime);
          var date2 = DateTime.now();
          var difference = date2.difference(newDateTimeObj2).inHours;
          // currently set to allow clockin two hours after shift start
          if( difference <= 2) {
            myButton = getMyButton();
          }
          myButton = getMyButton();
        });

        return;
      }

      final Map parsed = json.decode(body);
      final liveShift = ApiShift.fromJson(parsed);

      if(liveShift.shiftEndTimeActual == null){
        currentStatus = CHECKED_IN_BRK;
      }
      if(liveShift.breakEndTime == null){
        currentStatus = CHECKED_OUT_BRK;
      }
      if(liveShift.breakStartTime == null){
        currentStatus = CHECKED_IN;
      }
      if(liveShift.shiftStartTimeActual == null){
        currentStatus = OPEN_SHIFT;
      }

      setState(() {
        _setStatusText(currentStatus);
        myButton = getMyButton();
      });


      if(currentStatus >= CHECKED_OUT){
        myButton = null;
      }
    }else{
      showConnectionDialog(context);
    }

    } on Exception catch (exception) {
      print(exception);
      showConnectionDialog(context);
    } catch (error) {
      print(error);
      showConnectionDialog(context);
    }


  }

  Future _makeInterestGetRequest() async {
    try{
    // set up POST request arguments
    prefs = await SharedPreferences.getInstance();
    String tempid = prefs.getString('temp_id') ?? '';
    String url = AltoUtils.baseApiUrl + '/openshift/'+this.data.orderId+'/'+tempid;
    Map<String, String> headers = {"Content-type": "application/json"};


    // make POST request
    Response response = await get(url, headers: headers);
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
    }else{
      showConnectionDialog(context);
    }

    } on Exception catch (exception) {
      print(exception);
      showConnectionDialog(context);
    } catch (error) {
      print(error);
      showConnectionDialog(context);
    }
    setState(() {});
  }

  _setStatusText(int stat){

    if(stat == CHECKED_IN){
      statusText = 'ON SHIFT';
      statusColor = Colors.lightGreen;
      sliderColor = Colors.lightGreen;
    }
    if(stat == CHECKED_IN_BRK){
      statusText = 'ON SHIFT';
      statusColor = Colors.lightGreen;
      sliderColor = Colors.lightGreen;
    }
    if(stat == CHECKED_OUT_BRK){
      statusText = 'BREAK';
      statusColor = Colors.yellow;
      sliderColor = Colors.yellow;
    }
    if(stat == CHECKED_OUT){
      statusText = 'SHIFT END';
      statusColor = Colors.blueGrey;
      sliderColor = Colors.blueGrey;
      return;
    }
    if(stat == OPEN_SHIFT){
      statusText = 'OPEN';
      statusColor = Colors.blue;
      sliderColor = Colors.blue;
    }
    myButton = getMyButton();
  }

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      _currentPosition = position;
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getCurrentLocationInit() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      _currentPosition = position;
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];
      _currentAddress =
      "${place.locality}, ${place.postalCode}, ${place.country}";
      if(currentStatus == OPEN_SHIFT) {
        _makePostRequest(_currentAddress, _currentPosition.latitude,
            _currentPosition.longitude);
      }else{
        _makePatchRequest(_currentAddress, _currentPosition.latitude,
            _currentPosition.longitude);
      }
    } catch (e) {
      print(e);
    }
  }

  showSentHomeDialog(BuildContext context) {

    Widget continueButton = FlatButton(
      child: Text("Ok"),
      onPressed:  () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        _makeSentHomeRequest();
      },
    );

    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('You are being sent home by client?'),
      content: Text("Please click confirm to send alert to Alto"),
      actions: [
        continueButton,
        cancelButton,
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