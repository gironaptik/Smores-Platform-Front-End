class Recommendations {
  String recommendedProducts;

  Recommendations({this.recommendedProducts});

  Recommendations.fromJson(Map<String, dynamic> json) {
    recommendedProducts = json['recommendedProducts'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['recommendedProducts'] = this.recommendedProducts;
    return data;
  }
}
