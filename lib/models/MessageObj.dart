
class MessageObj {
  String _title;
  String _body;

  MessageObj(String title, String body) {
    this._title = title;
    this._body = body;
  }

  String get title => _title;
  set title(String title) => _title = title;
  String get body => _body;
  set body(String body) => _body = body;

  MessageObj.fromJson(Map<String, dynamic> json) {
    _title = json['title'];
    _body = json['body'];
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this._title;
    data['body'] = this._body;
    return data;
  }
}

