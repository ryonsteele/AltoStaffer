import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'AltoUtils.dart';
import 'Home.dart';
import 'MultiSelectChip.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';


class AppPage extends StatefulWidget {
  @override
  AppState createState() => AppState();
}

class AppState extends State<AppPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController fnameController = new TextEditingController();
  TextEditingController lnameController = new TextEditingController();
  //TextEditingController ssnController = new TextEditingController();
  TextEditingController streetController = new TextEditingController();
  TextEditingController cityController = new TextEditingController();
  TextEditingController stateController = new TextEditingController();
  TextEditingController zipController = new TextEditingController();
  TextEditingController pPhoneController = new TextEditingController();
  TextEditingController sPhoneController = new TextEditingController();
  String fname;
  String lname;
  // String ssn;
  String street;
  String city;
  String state;
  String zip;
  String primaryPhone;
  String secondaryPhone;
  static String fileKey;
  List specDatasource;
  List<String> multiSelectSpec = List();
  List<String> multiSelectCerts = List();

  String _fileName;
  List<File> files = [];
  Map<String, String> _paths;
  String _extension;
  bool _loadingPath = false;
  FileType _pickingType;


  bool _obsecure = false;

  @override
  Widget build(BuildContext context) {
    Color primary = Color(0xFF0B859E);
    void initState() {
      super.initState();
    }

    //getSpecs();

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
                  color: Color(0xFF0B859E),
                  width: 2,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(
                  color: Color(0xFF0B859E),
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

    //input widget
    Widget _inputBlank(String hint, TextEditingController controller,
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
                  color: Color(0xFF0B859E),
                  width: 2,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(
                  color: Color(0xFF0B859E),
                  width: 3,
                ),
              ),
            ),
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

//    Future<Widget> _showMultiSelectSpec()  async {
//
//      final speclist = AltoUtils.getSpecs();
//      showDialog(
//          context: context,
//          builder: (BuildContext context) {
//            //Here we will build the content of the dialog
//            return AlertDialog(
//              title: Text("Scroll & Select All Specializations"),
//            content:SingleChildScrollView(
//            child: Column(
//            crossAxisAlignment: CrossAxisAlignment.stretch,
//            children: <Widget>[ MultiSelectChip(
//                speclist,
//                onSelectionChanged: (selectedList) {
//                  setState(() {
//                    multiSelectSpec = selectedList;
//                  });
//                },
//               ),],),),
//              actions: <Widget>[
//                FlatButton(
//                  child: Text("Select"),
//                  onPressed: () => Navigator.of(context).pop(),
//                )
//              ],
//            );
//          });
//    }

    Future<Widget> _showMultiSelectCerts()  async {

      final certlist = AltoUtils.getCerts();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            //Here we will build the content of the dialog
            return AlertDialog(
              title: Text("Scroll & Select All Certifications"),
              content:SingleChildScrollView(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[ MultiSelectChip(
                certlist,
                onSelectionChanged: (selectedList) {
                  setState(() {
                    multiSelectCerts = selectedList;
                  });
                },
               ),],),),
              actions: <Widget>[
                FlatButton(
                  child: Text("Select"),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            );
          });
    }

    void validSubmit() {
      fname = fnameController.text;
      lname = lnameController.text;
      // ssn = ssnController.text;
      street = streetController.text;
      city = cityController.text;
      state = stateController.text;
      zip = zipController.text;
      primaryPhone = pPhoneController.text;
      secondaryPhone = sPhoneController.text;
      _makePostRequest();

    }



    return Scaffold(
      appBar: AppBar(
        title: Text('Apply To Alto'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushReplacement( MaterialPageRoute(builder: (context) => Home()));
            },
          ),
          //Add the dropdown widget to the `Action` part of our appBar. it can also be among the `leading` part
        ],
        backgroundColor: Color(0xFF0B859E),
      ),
        resizeToAvoidBottomPadding: false,
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body:
            SingleChildScrollView(
              child: Column(
                children: <Widget>[

                  Container(
                   child: Text("Submit Application",
                           style: TextStyle(
                           fontSize: 48,
                           fontWeight: FontWeight.bold,
                           color: Colors.white,
                            ),
                           ),
                            alignment: Alignment.center,
                   ),


                  Padding(
                    padding: EdgeInsets.only(bottom: 20, top: 60),
                    child: _inputBlank( "First Name",
                        fnameController, false),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: _inputBlank( "Last Name",
                        lnameController, false),
                  ),
//                  Padding(
//                    padding: EdgeInsets.only(bottom: 20),
//                    child: _inputBlank( "Social Secuity #",
//                        ssnController, true),
//                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: _inputBlank( "Street",
                        streetController, false),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: _inputBlank( "City",
                        cityController, false),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: _inputBlank( "State",
                        stateController, false),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: _inputBlank( "Zip",
                        zipController, false),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: _inputBlank( "Primary Phone #",
                        pPhoneController, false),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: _inputBlank( "Secondary Phone #",
                        sPhoneController, false),
                  ),
//                  Padding(
//                    padding: EdgeInsets.only(bottom: 20, left: 20, right: 20),
//                    child: _button("Specialization", Colors.white, primary,
//                        primary, Colors.white, _showMultiSelectSpec),
//                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20, left: 20, right: 20),
                    child: _button("Certification", Colors.white, primary,
                        primary, Colors.white, _showMultiSelectCerts),
                  ),
//                  Padding(
//                    padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
//                    child: new RaisedButton(
//                    onPressed: () => _openFileExplorer(),
//                      child: new Text("Attach Resume"),
//                      ),
//                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Container(
                      child: _button("Submit", Colors.white, primary,
                          primary, Colors.white, validSubmit),
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),

        );
  }

  Upload() async {

    if(fileKey == null || fileKey.isEmpty) return;
    var dioDoo = dio.Dio();
    dioDoo.options.baseUrl = AltoUtils.baseApiUrl;

    for(File f in this.files) {

      dio.FormData formData =  dio.FormData.fromMap({
        "file": [
          dio.MultipartFile.fromBytes(f.readAsBytesSync(),
              filename: "file"),
        ],
        "filekey": fileKey
      });

      var response = await dioDoo.post("/fileupload", data: formData).catchError((e) {
        print("Got error: ${e.error}");     // Finally, callback fires.
      });
      print(response.statusCode);
    }
  }


  Future _makePostRequest() async {

    try{
      // set up POST request arguments
      fileKey = UniqueKey().toString();
      String url = AltoUtils.baseApiUrl + '/apply';
      Map<String, String> headers = {"Content-type": "application/json"};

      String json = '{"firstname": "'+ this.fname.trim()+'", "email": "'+Home.myUserName.trim()+'",' +'"lastname": "'+ this.lname.trim()+
          '",' +'"street": "'+ this.street.trim()+'",' +'"city": "'+ this.city.trim()+ '",' +'"state": "'+ this.state.trim()+
          '", "zip": "'+ zip.trim() + '", "certs": '+ jsonEncode(this.multiSelectCerts) +', "specs": '+ jsonEncode(this.multiSelectSpec)
          +', "primary": "'+ this.primaryPhone.trim()+'", "secondary": "'+ this.secondaryPhone.trim()+'", "filekey": "'+ fileKey.trim()+'"}';

      // make POST request
       print(json);
      Response response = await post(url, headers: headers, body: json);
      // check the status code for the result
      int statusCode = response.statusCode;
      // this API passes back the id of the new item added to the body
      String body = response.body;

      if(statusCode >= 200 && statusCode < 300) {

        fnameController.clear();
        lnameController.clear();
        //ssnController.clear();
        streetController.clear();
        cityController.clear();
        stateController.clear();
        zipController.clear();
        pPhoneController.clear();
        sPhoneController.clear();
        multiSelectCerts.clear();
        multiSelectSpec.clear();
        //Upload();
        showSuccessDialog(this.context);

      }else{
        showConnectionDialog(this.context);
      }

    } on Exception catch (exception) {
      print(exception);
      showConnectionDialog(this.context);
    } catch (error) {
      print(error);
      showConnectionDialog(this.context);
    }
    setState(() {});
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

  showSuccessDialog(BuildContext context) {

    Widget continueButton = FlatButton(
      child: Text("Ok"),
      onPressed:  () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        Navigator.of(context).pushReplacement( MaterialPageRoute(builder: (context) => Home()));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('Your Application has been recieved.'),
      content: Text("Thank you for applying!"),
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

  void _openFileExplorer() async {
    setState(() => _loadingPath = true);
    File file = null;

    try {

      file  = await FilePicker.getFile(type: FileType.any);
      files.add(file);

    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    if (!mounted) return;
    setState(()  {
      _loadingPath = false;

    });
  }


  //todo api impl
//  Future<List<MultiSelector>> getSpecs() async {
//    multiSelect = new List<MultiSelector>();
//    Response response;
//    try {
//      response = await http.get('https://ctms.contingenttalentmanagement.com/CirrusConcept/clearConnect/2_0/index.cfm?action=getSpecs&username=lesliekahn&password=Jan242003!&resultType=json');
//
//    } on Exception catch (exception) {
//      print(exception);
//    } catch (error) {
//      print(error);
//    }
//
//
//    if(response.body.contains('html')) return null;
//    //print(response.body);
//
//    specDatasource=(json.decode(response.body) as List).map((i) =>
//        Specs.fromJson(i)).toList();
//
//    //todo utils
//    for(Specs rec in specDatasource ){
//       multiSelect.add(new MultiSelector(val: 1, disp: rec.specName));
//    }
//
//    return multiSelect;
//
//  }


}