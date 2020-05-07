class Properties {
  String product;
  var price;
  String shelf;
  var checkout;

  Properties({this.product, this.price, this.shelf, this.checkout});

  Properties.fromJson(Map<String, dynamic> json) {
    product = json['Product'];
    price = json['Price'];
    shelf = json['Shelf'];
    shelf = json['CheckOut'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Product'] = this.product;
    data['Price'] = this.price;
    data['Shelf'] = this.shelf;
    data['CheckOut'] = this.checkout;

    return data;
  }
}
