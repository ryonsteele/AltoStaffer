class Specs{
  String _specId;
  String _specName;

  Specs({String specId, String specName}) {
    this._specId = specId;
    this._specName = specName;
  }

  String get specId => _specId;
  set specId(String specId) => _specId = specId;
  String get specName => _specName;
  set specName(String specName) => _specName = specName;

  Specs.fromJson(Map<String, dynamic> json) {
    _specId = json['specId'];
    _specName = json['specName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['specId'] = this._specId;
    data['specName'] = this._specName;
    return data;
  }
}