import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';
import 'dart:convert';
import 'models/Specs.dart';
import 'package:alto_staffing/MultiSelectDialogItem.dart';
import 'models/SpecsList.dart';
import 'clipper.dart';

class AppPage extends StatefulWidget {
  @override
  AppState createState() => AppState();
}

class AppState extends State<AppPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController fnameController = new TextEditingController();
  TextEditingController lnameController = new TextEditingController();
  TextEditingController ssnController = new TextEditingController();
  TextEditingController streetController = new TextEditingController();
  TextEditingController cityController = new TextEditingController();
  TextEditingController stateController = new TextEditingController();
  String fname;
  String lname;
  String ssn;
  String street;
  String city;
  String state;
  List specDatasource;
  List multiSelect;

  bool _obsecure = false;

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).primaryColor;
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

    Widget _showMultiSelect()  {
      final items = <MultiSelectDialogItem<int>>[
        MultiSelectDialogItem(1, 'Dog'),
        MultiSelectDialogItem(2, 'Cat'),
        MultiSelectDialogItem(3, 'Mouse'),
        MultiSelectDialogItem(4, 'Mouse'),
        MultiSelectDialogItem(5, 'Mouse'),
        MultiSelectDialogItem(6, 'Mouse'),
        MultiSelectDialogItem(7, 'Mouse'),
        MultiSelectDialogItem(8, 'Mouse'),
        MultiSelectDialogItem(9, 'Mouse'),
        MultiSelectDialogItem(10, 'Mouse'),
        MultiSelectDialogItem(11, 'Mouse'),
      ];

      final selectedValues = showDialog<Set<int>>(
        context: context,
        builder: (context) {
          return MultiSelectDialog(
            items: items,
            initialSelectedValues: [1, 3].toSet(),
          );
        },
      );

      print(selectedValues);
    }


    void validSubmit() {
      fname = fnameController.text;
      lname = lnameController.text;
      ssn = ssnController.text;
      street = streetController.text;
      city = cityController.text;
      state = stateController.text;

      fnameController.clear();
      lnameController.clear();
      ssnController.clear();
      streetController.clear();
      cityController.clear();
      stateController.clear();
    }



    return Scaffold(
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
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: _inputBlank( "Social Secuity #",
                        ssnController, true),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: _inputBlank( "Street",
                        streetController, true),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: _inputBlank( "City",
                        cityController, true),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: _inputBlank( "State",
                        stateController, true),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: _inputBlank( "Zip",
                        stateController, true),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: _inputBlank( "Primary Phone #",
                        stateController, true),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: _inputBlank( "Secondary Phone #",
                        stateController, true),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: _button("Specs", Colors.white, primary,
                        primary, Colors.white, _showMultiSelect),
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