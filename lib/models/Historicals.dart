import 'package:alto_staffing/models/shifts.dart';
import 'dart:convert';

import '../AltoUtils.dart';


class Historicals {
  String _hoursScheduled;
  String _hoursWorked;
  String _dateWindowBegin;
  String _dateWindowEnd;
  List<Shifts> _shifts = new List<Shifts>();

  Historicals(
      {String hoursScheduled,
        String hoursWorked,
        String dateWindowBegin,
        String dateWindowEnd}) {
    this._hoursScheduled = hoursScheduled;
    this._hoursWorked = hoursWorked;
    this._dateWindowBegin = dateWindowBegin;
    this._dateWindowEnd = dateWindowEnd;
  }

  String get hoursScheduled => _hoursScheduled;
  set hoursScheduled(String hoursScheduled) => _hoursScheduled = hoursScheduled;
  String get hoursWorked => _hoursWorked;
  set hoursWorked(String hoursWorked) => _hoursWorked = hoursWorked;
  String get dateWindowBegin => _dateWindowBegin;
  set dateWindowBegin(String dateWindowBegin) =>
      _dateWindowBegin = dateWindowBegin;
  String get dateWindowEnd => _dateWindowEnd;
  set dateWindowEnd(String dateWindowEnd) => _dateWindowEnd = dateWindowEnd;
  List get shifts => _shifts;
  set shifts(List<Shifts> shifts) => _shifts = shifts;

  Historicals.fromJson(Map<String, dynamic> jsonString) {
    _hoursScheduled = jsonString['hoursScheduled'];
    _hoursWorked = jsonString['hoursWorked'];
    _dateWindowBegin = AltoUtils.formatDates(jsonString['dateWindowBegin']);
    _dateWindowEnd = AltoUtils.formatDates(jsonString['dateWindowEnd']);
    _shifts = (jsonString['shifts'] as List).map((i) => Shifts.fromJson(i)).toList();//json['shifts'].cast<Shifts>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hoursScheduled'] = this._hoursScheduled;
    data['hoursWorked'] = this._hoursWorked;
    data['dateWindowBegin'] = this._dateWindowBegin;
    data['dateWindowEnd'] = this._dateWindowEnd;
    data['shifts'] = this._shifts;
    return data;
  }

}
