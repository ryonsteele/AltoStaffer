class CalEvent {

  //Class to store MMA Event Data

  bool readyForCalendar = true;
  String eventName;
  DateTime eventDate;
  StringBuffer eventDetails = new StringBuffer(''); //StringBuffer to display list of fights

  CalEvent(this.eventName);

  @override
  String toString() {
    return '\n' + this.eventName + '\nDate: ' + this.eventDate.toIso8601String() +
        '\nShifts: ' + eventDetails.toString();
  }



  void addDetails(String det){
    eventDetails.write('\n' + det);
  }

  String getPrefKey(){
    //Key used for the shared prefs to store the calendar event ID in case
    //the event needs to be updated
    //The first 4 digits of the event name are used since event titles
    //sometimes change, but the first 4 letters remain the same
    //The date is also used since the first 4 digits of name may be shared with
    //other events
    return eventName.substring(0,4) + eventDate.toIso8601String();
  }

  String getPrefBoolKey(){
    //Key used for bool preferences
    //Preferences must have different keys in shared_prefs library
    // or else conflicts occur
    return eventName.substring(0,5) + eventDate.toIso8601String();
  }

}