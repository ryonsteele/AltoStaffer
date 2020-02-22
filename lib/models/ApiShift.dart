class ApiShift {
  int _id;
  String _orderid;
  String _username;
  String _status;
  String _shiftStartTime;
  String _shiftEndTime;
  String _breakStartTime;
  String _breakEndTime;
  String _shiftStartTimeActual;
  String _shiftStartSignoff;
  String _shiftEndTimeActual;
  String _shiftEndSignoff;
  String _clientId;
  String _clientName;
  String _orderSpecialty;
  String _orderCertification;
  String _floor;
  String _shiftNumber;
  String _note;
  String _clockInAddress;
  String _checkinLat;
  String _checkinLon;
  String _clockoutAddress;
  String _checkoutLat;
  String _checkoutLon;

  ApiShift(
      {int id,
        String orderid,
        String username,
        String status,
        String shiftStartTime,
        String shiftEndTime,
        String breakStartTime,
        String breakEndTime,
        String shiftStartTimeActual,
        String shiftStartSignoff,
        String shiftEndTimeActual,
        String shiftEndSignoff,
        String clientId,
        String clientName,
        String orderSpecialty,
        String orderCertification,
        String floor,
        String shiftNumber,
        String note,
        String clockInAddress,
        String checkinLat,
        String checkinLon,
        String clockoutAddress,
        String checkoutLat,
        String checkoutLon}) {
    this._id = id;
    this._orderid = orderid;
    this._username = username;
    this._status = status;
    this._shiftStartTime = shiftStartTime;
    this._shiftEndTime = shiftEndTime;
    this._breakStartTime = breakStartTime;
    this._breakEndTime = breakEndTime;
    this._shiftStartTimeActual = shiftStartTimeActual;
    this._shiftStartSignoff = shiftStartSignoff;
    this._shiftEndTimeActual = shiftEndTimeActual;
    this._shiftEndSignoff = shiftEndSignoff;
    this._clientId = clientId;
    this._clientName = clientName;
    this._orderSpecialty = orderSpecialty;
    this._orderCertification = orderCertification;
    this._floor = floor;
    this._shiftNumber = shiftNumber;
    this._note = note;
    this._clockInAddress = clockInAddress;
    this._checkinLat = checkinLat;
    this._checkinLon = checkinLon;
    this._clockoutAddress = clockoutAddress;
    this._checkoutLat = checkoutLat;
    this._checkoutLon = checkoutLon;
  }

  int get id => _id;
  set id(int id) => _id = id;
  String get orderid => _orderid;
  set orderid(String orderid) => _orderid = orderid;
  String get username => _username;
  set username(String username) => _username = username;
  String get status => _status;
  set status(String status) => _status = status;
  String get shiftStartTime => _shiftStartTime;
  set shiftStartTime(String shiftStartTime) => _shiftStartTime = shiftStartTime;
  String get shiftEndTime => _shiftEndTime;
  set shiftEndTime(String shiftEndTime) => _shiftEndTime = shiftEndTime;
  String get breakStartTime => _breakStartTime;
  set breakStartTime(String breakStartTime) => _breakStartTime = breakStartTime;
  String get breakEndTime => _breakEndTime;
  set breakEndTime(String breakEndTime) => _breakEndTime = breakEndTime;
  String get shiftStartTimeActual => _shiftStartTimeActual;
  set shiftStartTimeActual(String shiftStartTimeActual) =>
      _shiftStartTimeActual = shiftStartTimeActual;
  String get shiftStartSignoff => _shiftStartSignoff;
  set shiftStartSignoff(String shiftStartSignoff) =>
      _shiftStartSignoff = shiftStartSignoff;
  String get shiftEndTimeActual => _shiftEndTimeActual;
  set shiftEndTimeActual(String shiftEndTimeActual) =>
      _shiftEndTimeActual = shiftEndTimeActual;
  String get shiftEndSignoff => _shiftEndSignoff;
  set shiftEndSignoff(String shiftEndSignoff) =>
      _shiftEndSignoff = shiftEndSignoff;
  String get clientId => _clientId;
  set clientId(String clientId) => _clientId = clientId;
  String get clientName => _clientName;
  set clientName(String clientName) => _clientName = clientName;
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
  String get clockInAddress => _clockInAddress;
  set clockInAddress(String clockInAddress) => _clockInAddress = clockInAddress;
  String get checkinLat => _checkinLat;
  set checkinLat(String checkinLat) => _checkinLat = checkinLat;
  String get checkinLon => _checkinLon;
  set checkinLon(String checkinLon) => _checkinLon = checkinLon;
  String get clockoutAddress => _clockoutAddress;
  set clockoutAddress(String clockoutAddress) =>
      _clockoutAddress = clockoutAddress;
  String get checkoutLat => _checkoutLat;
  set checkoutLat(String checkoutLat) => _checkoutLat = checkoutLat;
  String get checkoutLon => _checkoutLon;
  set checkoutLon(String checkoutLon) => _checkoutLon = checkoutLon;

  ApiShift.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _orderid = json['orderid'];
    _username = json['username'];
    _status = json['status'];
    _shiftStartTime = json['shiftStartTime'];
    _shiftEndTime = json['shiftEndTime'];
    _breakStartTime = json['breakStartTime'];
    _breakEndTime = json['breakEndTime'];
    _shiftStartTimeActual = json['shiftStartTimeActual'];
    _shiftStartSignoff = json['shiftStartSignoff'];
    _shiftEndTimeActual = json['shiftEndTimeActual'];
    _shiftEndSignoff = json['shiftEndSignoff'];
    _clientId = json['clientId'];
    _clientName = json['clientName'];
    _orderSpecialty = json['orderSpecialty'];
    _orderCertification = json['orderCertification'];
    _floor = json['floor'];
    _shiftNumber = json['shiftNumber'];
    _note = json['note'];
    _clockInAddress = json['clockInAddress'];
    _checkinLat = json['checkinLat'];
    _checkinLon = json['checkinLon'];
    _clockoutAddress = json['clockoutAddress'];
    _checkoutLat = json['checkoutLat'];
    _checkoutLon = json['checkoutLon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['orderid'] = this._orderid;
    data['username'] = this._username;
    data['status'] = this._status;
    data['shiftStartTime'] = this._shiftStartTime;
    data['shiftEndTime'] = this._shiftEndTime;
    data['breakStartTime'] = this._breakStartTime;
    data['breakEndTime'] = this._breakEndTime;
    data['shiftStartTimeActual'] = this._shiftStartTimeActual;
    data['shiftStartSignoff'] = this._shiftStartSignoff;
    data['shiftEndTimeActual'] = this._shiftEndTimeActual;
    data['shiftEndSignoff'] = this._shiftEndSignoff;
    data['clientId'] = this._clientId;
    data['clientName'] = this._clientName;
    data['orderSpecialty'] = this._orderSpecialty;
    data['orderCertification'] = this._orderCertification;
    data['floor'] = this._floor;
    data['shiftNumber'] = this._shiftNumber;
    data['note'] = this._note;
    data['clockInAddress'] = this._clockInAddress;
    data['checkinLat'] = this._checkinLat;
    data['checkinLon'] = this._checkinLon;
    data['clockoutAddress'] = this._clockoutAddress;
    data['checkoutLat'] = this._checkoutLat;
    data['checkoutLon'] = this._checkoutLon;
    return data;
  }
}

