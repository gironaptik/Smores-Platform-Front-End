class Elementt {
  ElementKey key;
  String elementType;
  String name;
  bool expired;
  Null created;
  Creator creator;
  Latlng latlng;
  ElementProperties elementProperties;

  Elementt.empty();

  Elementt(
      {this.key,
      this.elementType,
      this.name,
      this.expired,
      this.created,
      this.creator,
      this.latlng,
      this.elementProperties});

  Elementt.fromJson(Map<String, dynamic> json) {
    key = json['key'] != null ? new ElementKey.fromJson(json['key']) : null;
    elementType = json['elementType'];
    name = json['name'];
    expired = json['expired'];
    created = json['created'];
    creator =
        json['creator'] != null ? new Creator.fromJson(json['creator']) : null;
    latlng =
        json['latlng'] != null ? new Latlng.fromJson(json['latlng']) : null;
    elementProperties = json['elementProperties'] != null
        ? new ElementProperties.fromJson(json['elementProperties'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.key != null) {
      data['key'] = this.key.toJson();
    }
    data['elementType'] = this.elementType;
    data['name'] = this.name;
    data['expired'] = this.expired;
    data['created'] = this.created;
    if (this.creator != null) {
      data['creator'] = this.creator.toJson();
    }
    if (this.latlng != null) {
      data['latlng'] = this.latlng.toJson();
    }
    if (this.elementProperties != null) {
      data['elementProperties'] = this.elementProperties.toJson();
    }
    return data;
  }
}

class ElementKey {
  String id;
  String smartspace;

  ElementKey({this.id, this.smartspace});

  ElementKey.fromJson(Map<String, dynamic> json) {
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

class Creator {
  String smartspace;
  String email;

  Creator({this.smartspace, this.email});

  Creator.fromJson(Map<String, dynamic> json) {
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

class Latlng {
  var lat;
  var lng;

  Latlng({this.lat, this.lng});

  Latlng.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}

class ElementProperties {
  var product;
  var amount;
  var price;
  var shelf;

  ElementProperties({this.product, this.amount, this.price, this.shelf});

  ElementProperties.fromJson(Map<String, dynamic> json) {
    product = json['Product'];
    amount = json['Amount'];
    price = json['Price'];
    shelf = json['Shelf'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Product'] = this.product;
    data['Amount'] = this.amount;
    data['Price'] = this.price;
    data['Shelf'] = this.shelf;

    return data;
  }
}
