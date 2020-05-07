class Player {
  String smartspace;
  String email;

  Player({this.smartspace, this.email});

  Player.fromJson(Map<String, dynamic> json) {
    smartspace = json['smartspace'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['smartspace'] = this.smartspace;
    data['email'] = this.email;
    return data;
  }
}