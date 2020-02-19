

import 'package:alto_staffing/models/shifts.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sliding_button/sliding_button.dart';

class ShiftDetailView extends StatefulWidget {

  final Shifts data;

  ShiftDetailView({Key key, @required this.data}) : super(key: key);

  @override
  _ShiftDetailView createState() => _ShiftDetailView(this.data);
}


class _ShiftDetailView extends State<ShiftDetailView> {

  final GlobalKey<SlidingButtonState> _slideButtonKey = GlobalKey<SlidingButtonState>();
  TextEditingController _textFieldController = TextEditingController();
  static const int CHECK_IN = 0;
  static const int CHECKOUT_BRK = 1;
  static const int CHECKIN_BRK = 2;
  static const int CHECKOUT = 3;
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

    var newDateTimeObj2 = new DateFormat.yMd().add_jm().parse(this.data.shiftStartTime);
    var date2 = DateTime.now();
    var difference = date2.difference(newDateTimeObj2).inHours;
    if( difference <= 2 && this.data.status == 'Sched') {
      myButton = getMyButton();
    }
  }


  showAlertDialog(BuildContext context) {

    String title = "";
    TextField content;

    if(currentStatus == CHECK_IN){
      title = "Check In for Shift?";
      content = TextField(
        controller: _textFieldController,
        decoration: InputDecoration(hintText: "Supervisor Initials..."),
      );
    }
    if(currentStatus == CHECKOUT_BRK){
      title = "Check Out for Break?";
      content = null;
    }
    if(currentStatus == CHECKIN_BRK){
      title = "Check In from Break?";
      content = null;
    }
    if(currentStatus == CHECKOUT){
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
        Navigator.of(context, rootNavigator: true).pop('dialog');
        if(currentStatus >= CHECKOUT){
          myButton = null;
          setState(() {});
        }
        currentStatus++;},
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
      buttonColor: Color.fromRGBO(24, 190, 181, 1),
      slideButtonIconColor: Color.fromRGBO(24, 190, 181, 1),
      radius: 8,
      onSlideSuccessCallback: () {
        //_incrementCounter();
        showAlertDialog(context);
        Future.delayed(Duration(seconds: 1), () {
          _slideButtonKey.currentState.reset();
        });},);
  }


  @override
  Widget build(BuildContext context) {

    if(this.data == null){
      return new Container();
    }


    return Scaffold(
      appBar: AppBar(
        title: Text('Shift Details'),
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
                      child: Text('Status: ${this.data.status}', textAlign: TextAlign.end, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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

  Future _makePostRequest() async {
    // set up POST request arguments
    //todo externalize
    String url = 'http://192.168.1.98:8080/api/mobile/login';
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"username": "'+ _email+'", "password": "'+_password+'" }';
    // make POST request
    Response response = await post(url, headers: headers, body: json);
    // check the status code for the result
    int statusCode = response.statusCode;
    // this API passes back the id of the new item added to the body
    String body = response.body;

    if(statusCode >= 200 && statusCode < 300){

      if( rememberMe ) {
        prefs.setString('first_key', _email);
        prefs.setString('second_key', _password);
      }else{
        prefs.setString('first_key', '');
        prefs.setString('second_key', '');
      }

      prefs.setBool('init_key', false);
      Navigator.push(context, MaterialPageRoute(builder: (context) => LandPage()));
    }

  }
}