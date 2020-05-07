class ActionKey {
  String id;
  String smartspace;

  ActionKey({this.id, this.smartspace});

  ActionKey.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    smartspace = json['smartspace'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['smartspace'] = this.smartspace;
    return data;
  }
}