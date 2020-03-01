import 'package:alto_staffing/AltoUtils.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;
import 'package:http/http.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/sessionkey.dart';
import 'clipper.dart';
import 'AppPage.dart';
import 'LandPage.dart';

class Home extends StatefulWidget {
  static String myUserName = "";
  static SessionKey keyNumber;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  //FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();


  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _textFieldController = TextEditingController();
  static bool firstLogin = false;
  bool rememberMe = false;
  static SharedPreferences prefs;
  String _email;
  String _password;
  static String deviceToken = "";
  String _displayName;
  bool _obsecure = false;

  @override
  void initState() {
    super.initState();
    loadPrefs();
    getSessionKey();



    firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> msg) {
        print(" onLaunch called ${(msg)}");
      },
      onResume: (Map<String, dynamic> msg) {
        print(" onResume called ${(msg)}");
      },
      onMessage: (Map<String, dynamic> msg) {
        //showNotification(msg);
        print(" onMessage called ${(msg)}");
      },
    );
    firebaseMessaging.requestNotificationPermissions(const IosNotificationSettings(sound: true, alert: true, badge: true));
    firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings setting) {
      print('IOS Setting Registed');
    });
    firebaseMessaging.getToken().then((token) {
      //update(token);
      deviceToken = token;
      print(token);
    });
  }

  Future navigateToApplication(context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => AppPage()));
  }

  Future navigateToLanding(context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => LandPage()));
  }

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).primaryColor;


    //input widget
    Widget _input(Icon icon, String hint, TextEditingController controller,
        bool obsecure) {
      return Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: TextField(
          controller: controller,
          obscureText: obsecure,
          style: TextStyle(
            fontSize: 20,
          ),
          decoration: InputDecoration(
              hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              hintText: hint,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 3,
                ),
              ),
              prefixIcon: Padding(
                child: IconTheme(
                  data: IconThemeData(color: Theme.of(context).primaryColor),
                  child: icon,
                ),
                padding: EdgeInsets.only(left: 30, right: 10),
              )),
        ),
      );
    }

    //button widget
    Widget _button(String text, Color splashColor, Color highlightColor,
        Color fillColor, Color textColor, void function()) {
      return RaisedButton(
        highlightElevation: 0.0,
        splashColor: splashColor,
        highlightColor: highlightColor,
        elevation: 0.0,
        color: fillColor,
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        child: Text(
          text,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: textColor, fontSize: 20),
        ),
        onPressed: () {
          function();
        },
      );
    }

    //login and register fuctions

    void _loginUser() {
      _email = _emailController.text;
      _password = _passwordController.text;
      Home.myUserName = _email.trim();

      if(firstLogin) {
        showAlertDialog(context);
      }else{
        _makePostRequest();
      }

     // navigateToLanding(context);
    }

    void _registerUser() {
      _email = _emailController.text;
      _password = _passwordController.text;
      _emailController.clear();
      _passwordController.clear();
      navigateToApplication(context);


    }

    void _onRememberMeChanged(bool newValue) => setState(() {
      setState(() {
        rememberMe = newValue;
      });
    });

    void _loginSheet() {
      _scaffoldKey.currentState.showBottomSheet<void>((BuildContext context) {
        return DecoratedBox(
          decoration: BoxDecoration(color: Theme.of(context).canvasColor),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0)),
            child: Container(
              child: ListView(
                children: <Widget>[
                  Container(
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          left: 10,
                          top: 10,
                          child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              _emailController.clear();
                              _passwordController.clear();
                            },
                            icon: Icon(
                              Icons.close,
                              size: 30.0,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        )
                      ],
                    ),
                    height: 50,
                    width: 50,
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 140,
                          child: Stack(
                            children: <Widget>[
                              Positioned(
                                child: Align(
                                  child: Container(
                                    width: 130,
                                    height: 130,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  alignment: Alignment.center,
                                ),
                              ),
                              Positioned(
                                child: Container(
                                  child: Text(
                                    "LOGIN",
                                    style: TextStyle(
                                      fontSize: 48,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 20, top: 60),
                          child: _input(Icon(Icons.email), "EMAIL",
                              _emailController, false),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: _input(Icon(Icons.lock), "PASSWORD",
                              _passwordController, true),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 20,
                              right: 20,
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Container(
                            child: _button("LOGIN", Colors.white, primary,
                                primary, Colors.white, _loginUser),
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                          ),
                        ),
                      Switch(value: this.rememberMe,
                       onChanged: (value) {
                        setState(() {
                          this.rememberMe = value;
                          prefs.setBool('remember_key', value);
                         });
                      },),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              height: MediaQuery.of(context).size.height / 1.1,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
            ),
          ),
        );
      });
    }

    void _registerSheet() {
      _scaffoldKey.currentState.showBottomSheet<void>((BuildContext context) {
        return DecoratedBox(
          decoration: BoxDecoration(color: Theme.of(context).canvasColor),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0)),
            child: Container(
              child: ListView(
                children: <Widget>[
                  Container(
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          left: 10,
                          top: 10,
                          child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              _emailController.clear();
                              _passwordController.clear();
                              _nameController.clear();
                            },
                            icon: Icon(
                              Icons.close,
                              size: 30.0,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        )
                      ],
                    ),
                    height: 50,
                    width: 50,
                  ),
                  SingleChildScrollView(
                    child: Column(children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 140,
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              child: Align(
                                child: Container(
                                  width: 130,
                                  height: 130,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context).primaryColor),
                                ),
                                alignment: Alignment.center,
                              ),
                            ),
                            Positioned(
                              child: Container(
                                padding: EdgeInsets.only(bottom: 25, right: 40),
                                child: Text(
                                  "AP",
                                  style: TextStyle(
                                    fontSize: 44,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                alignment: Alignment.center,
                              ),
                            ),
                            Positioned(
                              child: Align(
                                child: Container(
                                  padding: EdgeInsets.only(top: 40, left: 28),
                                  width: 130,
                                  child: Text(
                                    "PLY",
                                    style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                alignment: Alignment.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: 20,
                        ),
                        child: _input(Icon(Icons.email), "EMAIL",
                            _emailController, false),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: _input(Icon(Icons.lock), "PASSWORD",
                            _passwordController, true),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 20,
                            right: 20,
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Container(
                          child: _button("APPLY", Colors.white, primary,
                              primary, Colors.white, _registerUser),
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ]),
                  ),
                ],
              ),
              height: MediaQuery.of(context).size.height / 1.1,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
            ),
          ),
        );
      });
    }



    return Scaffold(
        resizeToAvoidBottomPadding: false,
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Alto Staffing'),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: Column(
          children: <Widget>[
           // logo(),
            Padding(
              padding: const EdgeInsets.only(top: 100.0, bottom: 30.0),
              child: new Image.asset(
                'assets/altologo.png',
//              width: 600.0,
                height: 150,
                fit: BoxFit.fill,
              ),
            ),
            Padding(
              child: Container(
                child: _button("LOGIN", primary, Colors.white, Colors.white,
                    primary, _loginSheet),
                height: 50,
              ),
              padding: EdgeInsets.only(top: 80, left: 20, right: 20),
            ),
            Padding(
              child: Container(
                child: OutlineButton(
                  highlightedBorderColor: Colors.white,
                  borderSide: BorderSide(color: Colors.white, width: 2.0),
                  highlightElevation: 0.0,
                  splashColor: Colors.white,
                  highlightColor: Theme.of(context).primaryColor,
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                  child: Text(
                    "APPLY",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20),
                  ),
                  onPressed: () {
                    _registerSheet();
                  },
                ),
                height: 50,
              ),
              padding: EdgeInsets.only(top: 10, left: 20, right: 20),
            ),
            Expanded(
              child: Align(
                child: ClipPath(
                  child: Container(
                    color: Colors.white,
                    height: 300,
                  ),
                  clipper: BottomWaveClipper(),
                ),
                alignment: Alignment.bottomCenter,
              ),
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.stretch,
        ));
  }

  Future getSessionKey() async {
    List keys = new List<SessionKey>();
    Response response;
    try {
      response = await http.get(AltoUtils.baseHcsUrl + '?action=getSessionKey'+AltoUtils.suCreds+'&resultType=json');

    } on Exception catch (exception) {
      print(exception);
    } catch (error) {
      print(error);
    }


    if(response.body.contains('html')) return null;
    //print(response.body);

    keys=(json.decode(response.body) as List).map((i) =>
        SessionKey.fromJson(i)).toList();

    //todo utils
    for(SessionKey rec in keys ){
      print(rec.sessionKey);
      Home.keyNumber = rec;
    }
  }

  _makePostRequest() async {

    try{

    String platform = '';
    if (Platform.isAndroid) {
      platform = 'Android';
    } else if (Platform.isIOS) {
      platform = 'iOS';
    }else {
      throw new UnsupportedError("Unknown device type");
    }
    // set up POST request arguments
    //todo externalize
    String url = AltoUtils.baseApiUrl + '/login';
    Map<String, String> headers = {"Content-type": "application/json"};
    String myjson = '{"username": "'+ _email+'", "password": "'+_password+'", "devicetoken": "'+deviceToken+'", "devicetype": "'+platform+'" }';
    // make POST request
    Response response = await post(url, headers: headers, body: myjson);
    // check the status code for the result
    int statusCode = response.statusCode;
    // this API passes back the id of the new item added to the body
    String body = response.body;

    if(statusCode >= 200 && statusCode < 300) {
      if (rememberMe) {
        prefs.setString('first_key', _email);
        prefs.setString('second_key', _password);
      } else {
        _emailController.clear();
        _passwordController.clear();
        prefs.setString('first_key', '');
        prefs.setString('second_key', '');
      }

      prefs.setBool('init_key', false);

      try {
        final Map<String, dynamic> data = json.decode(body);
        print(data['tempid']);
        prefs.setString('temp_id', data['tempid']);
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => LandPage(tempid: data['tempid'])));
      } on FormatException catch (e) {
        print("That string didn't look like Json.");
      } on NoSuchMethodError catch (e) {
        print('That string was null!');
      }
    }else{
      showConnectionDialog(context);
    }

    }on Exception catch (ex) {
      showConnectionDialog(context);
    }

  }

  Future loadPrefs() async{
     prefs = await SharedPreferences.getInstance();
     _emailController.text = prefs.getString('first_key') ?? '';
     _passwordController.text = prefs.getString('second_key') ?? '';
     firstLogin =  prefs.getBool('init_key') ?? true;
     this.rememberMe =  prefs.getBool('remember_key') ?? false;

     setState(() {});
  }


  showAlertDialog(BuildContext context) {

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {Navigator.of(context, rootNavigator: true).pop('dialog');},
    );
    Widget continueButton = FlatButton(
      child: Text("Confirm"),
      onPressed:  () {

        Navigator.of(context, rootNavigator: true).pop('dialog');
        if(_textFieldController.text.trim() == _password.trim()){
          _makePostRequest();
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('First time? Confirm Password!'),
      content: TextField(
        controller: _textFieldController,
        decoration: InputDecoration(hintText: "Enter password again..."),
      ),
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