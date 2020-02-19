class SessionKey {
  String _success;
  String _sessionKey;
  String _message;

  SessionKey({String success, String sessionKey, String message}) {
    this._success = success;
    this._sessionKey = sessionKey;
    this._message = message;
  }

  String get success => _success;
  set success(String success) => _success = success;
  String get sessionKey => _sessionKey;
  set sessionKey(String sessionKey) => _sessionKey = sessionKey;
  String get message => _message;
  set message(String message) => _message = message;

  SessionKey.fromJson(Map<String, dynamic> json) {
    _success = json['success'];
    _sessionKey = json['sessionKey'];
    _message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this._success;
    data['sessionKey'] = this._sessionKey;
    data['message'] = this._message;
    return data;
  }
}

