

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:alto_staffing/models/shifts.dart';
import 'ShiftDetailView.dart';

class ShiftCard extends StatefulWidget {
//  final CandidateResults member;
  final Shifts member;

  ShiftCard(this.member);

  @override
  State<StatefulWidget> createState() {
    return ShiftCardState(member);
  }
}

class ShiftCardState extends State<ShiftCard> {
  Shifts baby;

  ShiftCardState(this.baby);


  Widget get babyCard {
    if(baby.clientName == null){return null;}
    //print(this.baby.toJson());
    return new Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            side: BorderSide(width: 2, color: Colors.black)),
        //color: const Color(0xffffffce),
        //margin: const EdgeInsets.only(top: 25.0, left: 75.0, right: 75.0, bottom: 25.0),
        child: InkWell(
            splashColor: Colors.grey,
            onTap: () async {
              Navigator.of(context).pushReplacement( MaterialPageRoute(builder: (context) => ShiftDetailView(data: this.baby)));
            },


            child: new Padding(
                padding: const EdgeInsets.only(bottom: 1.0, top: 5.0),
                child: Column(
                  //mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,

                    children: <Widget>[
                      Container(
                          color: Colors.white70,
                          child: ListTile(
                            leading: Text('${baby.status}',style: TextStyle(fontSize: 14.0,fontWeight: FontWeight.bold)),
                            title: Text('${baby.clientName}      ${getHours()} Hr',style: TextStyle(fontSize: 14.0,fontWeight: FontWeight.bold)),
                            subtitle: Text('${baby.city}    Start: ${baby.shiftStartTime}'),
                          )),
                    ]))));
  }

   int getHours(){
    try {
      DateTime shiftStart = new DateFormat("MM/dd/yyyy hh:mm a").parse(baby.shiftStartTime);
      DateTime shiftEnd = new DateFormat("MM/dd/yyyy hh:mm a").parse(baby.shiftEndTime);
      return shiftEnd.difference(shiftStart).inHours;

    }catch(ex){
      print(ex);
     }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child:  babyCard,
    );
  }




}