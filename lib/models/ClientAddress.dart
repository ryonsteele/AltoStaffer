class ClientAddress {
  String _clientId;
  String _address;
  String _address2;
  String _city;
  String _state;
  String _zip;
  String _county;

  ClientAddress(
      String clientId,
        String address,
        String address2,
        String city,
        String state,
        String zip,
        String county) {
    this._clientId = clientId;
    this._address = address;
    this._address2 = address2;
    this._city = city;
    this._state = state;
    this._zip = zip;
    this._county = county;
  }


  String get clientId => _clientId;
  set clientId(String clientId) => _clientId = clientId;
  String get address => _address;
  set address(String address) => _address = address;
  String get address2 => _address2;
  set address2(String address2) => _address2 = address2;
  String get city => _city;
  set city(String city) => _city = city;
  String get state => _state;
  set state(String state) => _state = state;
  String get zip => _zip;
  set zip(String zip) => _zip = zip;
  String get county => _county;
  set county(String county) => _county = county;

  ClientAddress.fromJson(Map<String, dynamic> json) {
    _clientId = json['clientId'];
    _address = json['address'];
    _address2 = json['address2'];
    _city = json['city'];
    _state = json['state'];
    _zip = json['zip'];
    _county = json['county'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['clientId'] = this._clientId;
    data['address'] = this._address;
    data['address2'] = this._address2;
    data['city'] = this._city;
    data['state'] = this._state;
    data['zip'] = this._zip;
    data['county'] = this._county;
    return data;
  }
}