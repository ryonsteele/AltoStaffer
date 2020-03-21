import 'package:alto_staffing/AltoUtils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:alto_staffing/Home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:custom_switch_button/custom_switch_button.dart';


class ShiftPrefPage extends StatefulWidget {
  final String tempid;

  ShiftPrefPage({Key key, @required this.tempid}) : super(key: key);

  @override
  AppState createState() => AppState(this.tempid);
}

class AppState extends State<ShiftPrefPage> with SingleTickerProviderStateMixin{
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool sun = false;
  bool mon = false;
  bool tues = false;
  bool wed = false;
  bool thur = false;
  bool fri = false;
  bool sat = false;
  String tempid;
  static SharedPreferences prefs;


  AppState(String tid) {
    this.tempid = tid;
  }

  @override
  void initState() {
    loadPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text('Filter Offerings'),
      ),
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Sunday:  ', style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0
                  ),),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        this.sun = !this.sun;
                      });
                    },
                    child: Center(
                      child: CustomSwitchButton(
                        backgroundColor: Colors.blueGrey,
                        unCheckedColor: Colors.white,
                        animationDuration: Duration(milliseconds: 400),
                        checkedColor: Colors.lightGreen,
                        checked: this.sun,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Monday:  ', style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0
                  ),),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        this.mon = !this.mon;
                      });
                    },
                    child: Center(
                      child: CustomSwitchButton(
                        backgroundColor: Colors.blueGrey,
                        unCheckedColor: Colors.white,
                        animationDuration: Duration(milliseconds: 400),
                        checkedColor: Colors.lightGreen,
                        checked: this.mon,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Tuesday:  ', style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0
                  ),),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        this.tues = !this.tues;
                      });
                    },
                    child: Center(
                      child: CustomSwitchButton(
                        backgroundColor: Colors.blueGrey,
                        unCheckedColor: Colors.white,
                        animationDuration: Duration(milliseconds: 400),
                        checkedColor: Colors.lightGreen,
                        checked: this.tues,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Wednesday:  ', style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0
                  ),),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        this.wed = !this.wed;
                      });
                    },
                    child: Center(
                      child: CustomSwitchButton(
                        backgroundColor: Colors.blueGrey,
                        unCheckedColor: Colors.white,
                        animationDuration: Duration(milliseconds: 400),
                        checkedColor: Colors.lightGreen,
                        checked: this.wed,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Thursday:  ', style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0
                  ),),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        this.thur = !this.thur;
                      });
                    },
                    child: Center(
                      child: CustomSwitchButton(
                        backgroundColor: Colors.blueGrey,
                        unCheckedColor: Colors.white,
                        animationDuration: Duration(milliseconds: 400),
                        checkedColor: Colors.lightGreen,
                        checked: this.thur,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Friday:  ', style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0
                  ),),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        this.fri = !this.fri;
                      });
                    },
                    child: Center(
                      child: CustomSwitchButton(
                        backgroundColor: Colors.blueGrey,
                        unCheckedColor: Colors.white,
                        animationDuration: Duration(milliseconds: 400),
                        checkedColor: Colors.lightGreen,
                        checked: this.fri,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Saturday:  ', style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0
                  ),),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        this.sat = !this.sat;
                      });
                    },
                    child: Center(
                      child: CustomSwitchButton(
                        backgroundColor: Colors.blueGrey,
                        unCheckedColor: Colors.white,
                        animationDuration: Duration(milliseconds: 400),
                        checkedColor: Colors.lightGreen,
                        checked: this.sat,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              MaterialButton(
                padding: EdgeInsets.all(8.0),
                textColor: Colors.white,
                splashColor: Colors.greenAccent,
                elevation: 8.0,
                child: Container(
                  width: 500,
                  height: 50,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/savePref.png'),
                        fit: BoxFit.cover),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                  ),
                ),
                // ),
                onPressed: () {
                  storePrefrences();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future storePrefrences() async {
    try{
      // set up POST request arguments
      String url = AltoUtils.baseApiUrl + '/userprefs';
      Map<String, String> headers = {"Content-type": "application/json"};

      String json = '{"tempId": "'+ this.tempid +'", "username": "'+Home.myUserName+'",' +'"mon": "'+ this.mon.toString() +
          '",' +'"tue": "'+ this.tues.toString()+'",' +'"wed": "'+ this.wed.toString()+ '",' +'"thur": "'+ this.thur.toString() +
          '", "fri": "'+ this.fri.toString() + '", "sat": "'+ this.sat.toString() +'", "sun": "'+ this.sun.toString() + '"}';

      // make POST request
      // print(json);
      Response response = await post(url, headers: headers, body: json);
      // check the status code for the result
      int statusCode = response.statusCode;
      // this API passes back the id of the new item added to the body
      String body = response.body;

      if(statusCode >= 200 && statusCode < 300){

        prefs.setBool('mon', this.mon);
        prefs.setBool('tue', this.tues);
        prefs.setBool('wed', this.wed);
        prefs.setBool('thur', this.thur);
        prefs.setBool('fri', this.fri);
        prefs.setBool('sat', this.sat);
        prefs.setBool('sun', this.sun);

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

  Future loadPrefs() async{
    prefs = await SharedPreferences.getInstance();


    setState(() {
      this.mon =  prefs.getBool('mon') ?? false;
      this.tues =  prefs.getBool('tue') ?? false;
      this.wed =  prefs.getBool('wed') ?? false;
      this.thur =  prefs.getBool('thur') ?? false;
      this.fri =  prefs.getBool('fri') ?? false;
      this.sat =  prefs.getBool('sat') ?? false;
      this.sun =  prefs.getBool('sun') ?? false;
    });
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