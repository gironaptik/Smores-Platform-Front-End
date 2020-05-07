import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:smores_app/models/action.dart';
import 'package:smores_app/models/user.dart';
import 'package:smores_app/widgets/app_drawer.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_nfc_reader/flutter_nfc_reader.dart';
import 'package:http/http.dart' as http;

final RoundedLoadingButtonController _btnController =
    new RoundedLoadingButtonController();
final String checkInName = "In";
final String checkOutName = "Out";
bool checkedInStatus = true;

const spinkit = SpinKitRotatingCircle(
  color: Colors.greenAccent,
  size: 50.0,
);

class ShoppingCart extends StatefulWidget {
  User user;
  var shoppingList = new List<Actionn>();
  final WebSocketChannel channel;

  ShoppingCart({Key key, this.user, @required this.channel}) : super(key: key);

  @override
  _ShoppingCart createState() => _ShoppingCart(user: this.user);

  // static _ShoppingCart of(BuildContext context) {
  //   return context.ancestorStateOfType(const TypeMatcher<_ShoppingCart>());
  // }
}

class _ShoppingCart extends State<ShoppingCart> {
  User user;
  Actionn checkOutAction;
  double totalsum;
  var finish = true;
  Widget body;
  @override
  void initState() {
    super.initState();
    _sendMessage();
  }

  final TextStyle dropdownMenuItem =
      TextStyle(color: Colors.black, fontSize: 18);
  final primary = Color(0xff23b574);
  final secondary = Color(0xff333C46);

  static List<Actionn> shoppingList = new List<Actionn>();
  _ShoppingCart({this.user});
  // static final String path = "lib/src/pages/ecommerce/cart1.dart";
  List<Map> _items = new List();
  var data;

  void _refresh() async {
    check();
    if (finish == false) {
      setState(() {
        _items.clear();
        var products = new Map<String, Map>();
        products.clear();
        totalsum = 0;
        for (Actionn action in shoppingList) {
          if (products.containsKey(action.properties.product)) {
            var updateProduct = products[action.properties.product];
            int amount = updateProduct['amount'];
            action.type == "Charge" ? ++amount : --amount;
            updateProduct.update('amount', (value) => amount);
            updateProduct.update(
                'price', (value) => (amount) * (action.properties.price));
            products.update(
                action.properties.product, (value) => updateProduct);
          } else {
            var newProduct = new Map();
            newProduct.putIfAbsent('title', () => action.properties.product);
            newProduct.putIfAbsent('amount', () => 1);
            newProduct.putIfAbsent('price', () => action.properties.price);
            products.putIfAbsent(action.properties.product, () => newProduct);
          }
        }

        products.forEach((final String key, final value) {
          if (value['amount'] > 0) {
            totalsum += value['price'];
            _items = List.from(_items)
              ..add({
                "title": value['title'],
                "price": value['price'].toStringAsFixed(2),
                "amount": value['amount']
              });
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    const oneSec = const Duration(seconds: 1);
    Timer refresher = new Timer.periodic(oneSec, (Timer t) {
      if (mounted) {
        _refresh();
      }
    });
    return Scaffold(
      drawer: AppDrawer(user: user),
      backgroundColor: Color(0xfff0f0f0),
      body: Builder(
        builder: (context) => SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 140,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: primary,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(
                              onPressed: () {
                                Scaffold.of(context).openDrawer();
                                refresher.cancel();
                              },
                              icon: Icon(
                                Icons.menu,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Shopping Cart",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 24),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.help,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    StreamBuilder(
                      stream: widget.channel.stream,
                      builder: (context, snapshot) {
                        if (snapshot.data != null) {
                          var tagObjsJson = jsonDecode(snapshot.data) as List;
                          shoppingList = tagObjsJson
                              .map((name) => new Actionn.fromJson(name))
                              .toList();
                        }
                        // if (shoppingList.length > 0) {
                        //   if (shoppingList[0].type == 'CheckIn') {
                        //     finish = true;
                        //   } else {
                        //     finish = false;
                        //   }
                        // } else {
                        //   if (shoppingList.length == 0) finish = false;
                        // }
                        return Text(' ');
                      },
                    ),
                    (finish == false)
                        ? Expanded(
                            child: new ListView.builder(
                              padding: EdgeInsets.all(16.0),
                              itemCount: _items.length,
                              itemBuilder: (BuildContext context, int index) {
                                return new Stack(
                                  children: <Widget>[
                                    new Container(
                                      width: double.infinity,
                                      margin: EdgeInsets.only(
                                          right: 30.0, bottom: 10.0),
                                      child: Material(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        elevation: 3.0,
                                        child: Container(
                                          padding: EdgeInsets.all(16.0),
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                height: 80,
                                              ),
                                              SizedBox(
                                                width: 10.0,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      _items[index]["title"],
                                                      style: TextStyle(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Container(
                                                      width: double.infinity,
                                                      height: 20,
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: SizedBox(
                                                        child: Text(
                                                            "Amount: ${_items[index]['amount']} "),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 40,
                                                      alignment:
                                                          Alignment.bottomRight,
                                                      child: Text(
                                                          "\₪${_items[index]['price']}",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 18.0)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 20,
                                      right: 15,
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                        alignment: Alignment.center,
                                        child: MaterialButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0)),
                                          padding: EdgeInsets.all(0.0),
                                          color: primary,
                                          child: Icon(
                                            Icons.add_shopping_cart,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {},
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              },
                            ),
                          )
                        : Expanded(
                            child: new Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  RoundedLoadingButton(
                                    color: primary,
                                    child: Text('Start Shopping!',
                                        style: TextStyle(color: Colors.white)),
                                    controller: _btnController,
                                    onPressed: _doSomething,
                                  )
                                ],
                              ),
                            ),
                          ),
                    (finish == false)
                        ? Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  "Cart Subtotal     \₪" +
                                      totalsum.toStringAsFixed(2),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: MaterialButton(
                                    height: 50.0,
                                    color: secondary,
                                    child: Text(
                                      "Checkout".toUpperCase(),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      checkOut();

                                      // _refresh();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _sendMessage() async {
    widget.channel.sink.add(user.key.email);
  }

  @override
  void didUpdateWidget(ShoppingCart oldWidget) {
    super.didUpdateWidget(oldWidget);

    setState(() {});
  }

  @override
  void dispose() {
    widget.channel.sink.close();
    super.dispose();
  }

  void rebuild() {
    setState(() {});
  }

  Future<Actionn> checkOut() async {
    final String loginurl =
        "https://smoressmartspace.herokuapp.com/smartspace/actions";
    var result = await http.post(loginurl,
        headers: {"Content-type": "application/json"},
        body: json.encode({
          "actionKey": {"id": null, "smartspace": null},
          "type": "CheckOut",
          "created": null,
          "element": {"id": "5e5ed061a14a1c000467c831", "smartspace": "Smores"},
          "player": {
            "smartspace": user.key.smartspace,
            "email": user.key.email
          },
          "properties": {}
        }));
    if (result.statusCode == 200) {
      checkedInStatus = false;
      var tagObjsJson = jsonDecode(result.body);
      checkOutAction = Actionn.fromJson(tagObjsJson);
      finish = true;
    }
    return checkOutAction;
  }

  void _doSomething() async {
    Timer(Duration(seconds: 2), () {
      _btnController.success();
    });
    checkIn();
  }

  Future<Actionn> checkIn() async {
    final String loginurl =
        "https://smoressmartspace.herokuapp.com/smartspace/actions";
    Actionn newAction = Actionn.empty();
    var result = await http.post(loginurl,
        headers: {"Content-type": "application/json"},
        body: json.encode({
          "actionKey": {"id": null, "smartspace": null},
          "type": "CheckIn",
          "created": DateTime.tryParse("dd-mm-yyyy HH:MM:SS"),
          "element": {"id": "5e5ed05ba14a1c000467c830", "smartspace": "Smores"},
          "player": {
            "smartspace": user.key.smartspace,
            "email": user.key.email
          },
          "properties": {}
        }));
    if (result.statusCode == 200) checkedInStatus = true;
    return newAction;
  }

  void check() {
    shoppingList.length == 0
        ? finish = false
        : shoppingList.length == 1 && shoppingList[0].type == "CheckIn"
            ? finish = true
            : finish = false;

    FlutterNfcReader.read().then((response) {
      print("{" + response.content.toString() + "}");
      print("outname!! ====>>> " + checkInName);
      if (response.content.toString().contains(checkOutName))
        checkOut();
      else if (response.content.toString().contains(checkInName) &&
          finish == true) {
        _doSomething();
        setState(() {});
      }
    });
    setState(() {});
  }
}
