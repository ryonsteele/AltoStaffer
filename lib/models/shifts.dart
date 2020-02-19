import 'package:intl/intl.dart';

class Shifts {
  String _orderId;
  String _status;
  String _shiftStartTime;
  String _shiftEndTime;
  String _tempId;
  String _firstName;
  String _lastName;
  String _clientId;
  String _clientName;
  String _regionName;
  String _orderSpecialty;
  String _orderCertification;
  String _floor;
  String _shiftNumber;
  String _note;
  String _payrollNumber;
  String _lessLunchMin;
  String _dateTimeCreated;
  String _takenBy;
  String _bookedByUserId;
  String _orderTypeId;
  String _orderType;
  String _city;
  String _state;
  String _zipCode;
  String _orderSourceID;
  String _orderSourceName;
  String _ltOrderID;
  String _dateTimeModified;
  String _subjectID;
  String _subject;
  String _vms;

  Shifts(
      {String orderId,
        String status,
        String shiftStartTime,
        String shiftEndTime,
        String tempId,
        String firstName,
        String lastName,
        String clientId,
        String clientName,
        String regionName,
        String orderSpecialty,
        String orderCertification,
        String floor,
        String shiftNumber,
        String note,
        String payrollNumber,
        String lessLunchMin,
        String dateTimeCreated,
        String takenBy,
        String bookedByUserId,
        String orderTypeId,
        String orderType,
        String city,
        String state,
        String zipCode,
        String orderSourceID,
        String orderSourceName,
        String ltOrderID,
        String dateTimeModified,
        String subjectID,
        String subject,
        String vms}) {
    this._orderId = orderId;
    this._status = status;
    this._shiftStartTime = shiftStartTime;
    this._shiftEndTime = shiftEndTime;
    this._tempId = tempId;
    this._firstName = firstName;
    this._lastName = lastName;
    this._clientId = clientId;
    this._clientName = clientName;
    this._regionName = regionName;
    this._orderSpecialty = orderSpecialty;
    this._orderCertification = orderCertification;
    this._floor = floor;
    this._shiftNumber = shiftNumber;
    this._note = note;
    this._payrollNumber = payrollNumber;
    this._lessLunchMin = lessLunchMin;
    this._dateTimeCreated = dateTimeCreated;
    this._takenBy = takenBy;
    this._bookedByUserId = bookedByUserId;
    this._orderTypeId = orderTypeId;
    this._orderType = orderType;
    this._city = city;
    this._state = state;
    this._zipCode = zipCode;
    this._orderSourceID = orderSourceID;
    this._orderSourceName = orderSourceName;
    this._ltOrderID = ltOrderID;
    this._dateTimeModified = dateTimeModified;
    this._subjectID = subjectID;
    this._subject = subject;
    this._vms = vms;
  }

  String get orderId => _orderId;
  set orderId(String orderId) => _orderId = orderId;
  String get status => _status;
  set status(String status) => _status = status;
  String get shiftStartTime => _shiftStartTime;
  set shiftStartTime(String shiftStartTime) => _shiftStartTime = shiftStartTime;
  String get shiftEndTime => _shiftEndTime;
  set shiftEndTime(String shiftEndTime) => _shiftEndTime = shiftEndTime;
  String get tempId => _tempId;
  set tempId(String tempId) => _tempId = tempId;
  String get firstName => _firstName;
  set firstName(String firstName) => _firstName = firstName;
  String get lastName => _lastName;
  set lastName(String lastName) => _lastName = lastName;
  String get clientId => _clientId;
  set clientId(String clientId) => _clientId = clientId;
  String get clientName => _clientName;
  set clientName(String clientName) => _clientName = clientName;
  String get regionName => _regionName;
  set regionName(String regionName) => _regionName = regionName;
  String get orderSpecialty => _orderSpecialty;
  set orderSpecialty(String orderSpecialty) => _orderSpecialty = orderSpecialty;
  String get orderCertification => _orderCertification;
  set orderCertification(String orderCertification) =>
      _orderCertification = orderCertification;
  String get floor => _floor;
  set floor(String floor) => _floor = floor;
  String get shiftNumber => _shiftNumber;
  set shiftNumber(String shiftNumber) => _shiftNumber = shiftNumber;
  String get note => _note;
  set note(String note) => _note = note;
  String get payrollNumber => _payrollNumber;
  set payrollNumber(String payrollNumber) => _payrollNumber = payrollNumber;
  String get lessLunchMin => _lessLunchMin;
  set lessLunchMin(String lessLunchMin) => _lessLunchMin = lessLunchMin;
  String get dateTimeCreated => _dateTimeCreated;
  set dateTimeCreated(String dateTimeCreated) =>
      _dateTimeCreated = dateTimeCreated;
  String get takenBy => _takenBy;
  set takenBy(String takenBy) => _takenBy = takenBy;
  String get bookedByUserId => _bookedByUserId;
  set bookedByUserId(String bookedByUserId) => _bookedByUserId = bookedByUserId;
  String get orderTypeId => _orderTypeId;
  set orderTypeId(String orderTypeId) => _orderTypeId = orderTypeId;
  String get orderType => _orderType;
  set orderType(String orderType) => _orderType = orderType;
  String get city => _city;
  set city(String city) => _city = city;
  String get state => _state;
  set state(String state) => _state = state;
  String get zipCode => _zipCode;
  set zipCode(String zipCode) => _zipCode = zipCode;
  String get orderSourceID => _orderSourceID;
  set orderSourceID(String orderSourceID) => _orderSourceID = orderSourceID;
  String get orderSourceName => _orderSourceName;
  set orderSourceName(String orderSourceName) =>
      _orderSourceName = orderSourceName;
  String get ltOrderID => _ltOrderID;
  set ltOrderID(String ltOrderID) => _ltOrderID = ltOrderID;
  String get dateTimeModified => _dateTimeModified;
  set dateTimeModified(String dateTimeModified) =>
      _dateTimeModified = dateTimeModified;
  String get subjectID => _subjectID;
  set subjectID(String subjectID) => _subjectID = subjectID;
  String get subject => _subject;
  set subject(String subject) => _subject = subject;
  String get vms => _vms;
  set vms(String vms) => _vms = vms;

  Shifts.fromJson(Map<String, dynamic> json) {
    _orderId = json['orderId'];
    _status = formatStatus(json['status']);
    _shiftStartTime = formatDates(json['shiftStartTime']);
    _shiftEndTime = formatDates(json['shiftEndTime']);
    _tempId = json['tempId'];
    _firstName = json['firstName'];
    _lastName = json['lastName'];
    _clientId = json['clientId'];
    _clientName = json['clientName'];
    _regionName = json['regionName'];
    _orderSpecialty = json['orderSpecialty'];
    _orderCertification = json['orderCertification'];
    _floor = json['floor'];
    _shiftNumber = json['shiftNumber'];
    _note = json['note'];
    _payrollNumber = json['payrollNumber'];
    _lessLunchMin = json['lessLunchMin'];
    _dateTimeCreated = json['dateTimeCreated'];
    _takenBy = json['takenBy'];
    _bookedByUserId = json['bookedByUserId'];
    _orderTypeId = json['orderTypeId'];
    _orderType = json['orderType'];
    _city = json['city'];
    _state = json['state'];
    _zipCode = json['zipCode'];
    _orderSourceID = json['orderSourceID'];
    _orderSourceName = json['orderSourceName'];
    _ltOrderID = json['lt_orderID'];
    _dateTimeModified = json['dateTimeModified'];
    _subjectID = json['subjectID'];
    _subject = json['subject'];
    _vms = json['vms'];
  }

  String formatDates(String sDate){
    String formatted;//2020-02-03T08:00:00
    DateTime dateTime = new DateFormat("yyyy-MM-ddTHH:mm:ss").parse(sDate);
    return DateFormat.yMd().add_jm().format(dateTime);
  }

  String formatStatus(String sStatus){
    String status = "";

    if(sStatus == 'open'){
      status = 'Open';
    }else if(sStatus == 'filled'){
      status = 'Sched';
    }else if(sStatus == 'void'){
      status = 'VOID';
    }else{
      status = 'UKN';
    }

    return status;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this._orderId;
    data['status'] = this._status;
    data['shiftStartTime'] = this._shiftStartTime;
    data['shiftEndTime'] = this._shiftEndTime;
    data['tempId'] = this._tempId;
    data['firstName'] = this._firstName;
    data['lastName'] = this._lastName;
    data['clientId'] = this._clientId;
    data['clientName'] = this._clientName;
    data['regionName'] = this._regionName;
    data['orderSpecialty'] = this._orderSpecialty;
    data['orderCertification'] = this._orderCertification;
    data['floor'] = this._floor;
    data['shiftNumber'] = this._shiftNumber;
    data['note'] = this._note;
    data['payrollNumber'] = this._payrollNumber;
    data['lessLunchMin'] = this._lessLunchMin;
    data['dateTimeCreated'] = this._dateTimeCreated;
    data['takenBy'] = this._takenBy;
    data['bookedByUserId'] = this._bookedByUserId;
    data['orderTypeId'] = this._orderTypeId;
    data['orderType'] = this._orderType;
    data['city'] = this._city;
    data['state'] = this._state;
    data['zipCode'] = this._zipCode;
    data['orderSourceID'] = this._orderSourceID;
    data['orderSourceName'] = this._orderSourceName;
    data['lt_orderID'] = this._ltOrderID;
    data['dateTimeModified'] = this._dateTimeModified;
    data['subjectID'] = this._subjectID;
    data['subject'] = this._subject;
    data['vms'] = this._vms;
    return data;
  }
}

