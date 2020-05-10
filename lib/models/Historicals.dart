import 'package:intl/intl.dart';

class Historicals {
  String _hoursScheduled;
  String _hoursWorked;
  String _dateWindowBegin;
  String _dateWindowEnd;

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

  Historicals.fromJson(Map<String, dynamic> json) {
    _hoursScheduled = json['hoursScheduled'];
    _hoursWorked = json['hoursWorked'];
    _dateWindowBegin = formatDates(json['dateWindowBegin']);
    _dateWindowEnd = formatDates(json['dateWindowEnd']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hoursScheduled'] = this._hoursScheduled;
    data['hoursWorked'] = this._hoursWorked;
    data['dateWindowBegin'] = this._dateWindowBegin;
    data['dateWindowEnd'] = this._dateWindowEnd;
    return data;
  }

  String formatDates(String sDate){
    String formatted;//2020-02-03T08:00
    DateTime dateTime = new DateFormat("yyyy-MM-ddTHH:mm").parse(sDate);
    return DateFormat.yMd().add_jm().format(dateTime);
  }
}
