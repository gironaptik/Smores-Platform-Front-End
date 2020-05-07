import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:smores_app/models/action.dart';
import 'package:smores_app/models/user.dart';
import 'package:smores_app/widgets/app_drawer.dart';
import 'package:http/http.dart' as http;

class HistoryPurchases extends StatefulWidget {
  User user;
  HistoryPurchases({Key key, this.user}) : super(key: key);

  static final String path = "lib/src/pages/lists/list2.dart";

  @override
  _HistoryPurchases createState() => _HistoryPurchases(user: this.user);
}

class _HistoryPurchases extends State<HistoryPurchases> {
  Widget body;
  @override
  void initState() {
    super.initState();
    checkInList(user);
  }

  final User user;

  _HistoryPurchases({this.user});

  var checkInListList = new List<Actionn>();
  var askedShoppingList = new List<Actionn>();
  var orederedList = new Map<String, Map>();

  final TextStyle dropdownMenuItem =
      TextStyle(color: Colors.black, fontSize: 18);
  final primary = Color(0xff23b574);
  final secondary = Color(0xff00bae2);

  TextEditingController customerEditingController = new TextEditingController();

  createAlertDialog(
      BuildContext context, Actionn fromAction, Actionn tillAction) async {
    askedShoppingList.clear();
    askedShoppingList =
        await shoppingList(user, fromAction, tillAction, "Charge") +
            await shoppingList(user, fromAction, tillAction, "Return");
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        orderProducts();
        return new SimpleDialog(
          backgroundColor: Colors.transparent,
          children: <Widget>[
            new Container(
              height: 300.0,
              width: 100.0,
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Color(0xfff0f0f0),
                  borderRadius: BorderRadius.all(new Radius.circular(15.0))),
              child: new ListView(
                children: <Widget>[
                  Container(
                    padding: new EdgeInsets.only(top: 20, bottom: 10),
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: primary,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15.0),
                            topRight: Radius.circular(15.0))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text("Item",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                        Text("Amount",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                      ],
                    ),
                  ),
                  for (var entry in orederedList.entries)
                    Padding(
                      padding: new EdgeInsets.only(
                          left: 40.0, right: 60, bottom: 10, top: 10),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(entry.value['title'],
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18)),
                          Text(entry.value['amount'].toString(),
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18))
                        ],
                      ),
                    )
                ],
              ),
            )
          ],
        );
      },
    );
  }

  List<Map> currentCheckInList = [];

  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      drawer: AppDrawer(user: user),
      key: _scaffoldKey,
      backgroundColor: Color(0xfff0f0f0),
      body: Builder(
        builder: (context) => SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 145),
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  child: ListView.builder(
                      itemCount: currentCheckInList.length,
                      itemBuilder: (BuildContext newcontext, int index) {
                        return buildList(newcontext, index);
                      }),
                ),
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
                          },
                          icon: Icon(
                            Icons.menu,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "History Purchases",
                          style: TextStyle(color: Colors.white, fontSize: 24),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildList(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        try {
          createAlertDialog(
              context, checkInListList[index], checkInListList[index - 1]);
        } on RangeError {
          createAlertDialog(context, checkInListList[index], null);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,
        ),
        width: double.infinity,
        height: 110,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 50,
              height: 50,
              margin: EdgeInsets.only(right: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(width: 3, color: secondary),
                image: DecorationImage(
                    image: CachedNetworkImageProvider(
                        currentCheckInList[index]['logoText']),
                    fit: BoxFit.fill),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    currentCheckInList[index]['name'],
                    style: TextStyle(
                        color: primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        color: secondary,
                        size: 20,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(currentCheckInList[index]['location'],
                          style: TextStyle(
                              color: primary, fontSize: 13, letterSpacing: .3)),
                    ],
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.perm_device_information,
                        color: secondary,
                        size: 20,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(currentCheckInList[index]['type'],
                          style: TextStyle(
                              color: primary, fontSize: 13, letterSpacing: .3)),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<List> checkInList(User user) async {
    final checkInListPath =
        'https://smoressmartspace.herokuapp.com/smartspace/actions/typeList/' +
            user.key.smartspace +
            '/' +
            user.key.email +
            '?search=type&type=CheckIn';
    var result = await http.get(Uri.encodeFull(checkInListPath),
        headers: {"Accept": "application/json"});
    if (result.statusCode == 200) {
      var tagObjsJson = jsonDecode(result.body) as List;
      checkInListList =
          tagObjsJson.map((name) => new Actionn.fromJson(name)).toList();
    } else {
      Text("Failed");
    }
    for (Actionn action in checkInListList) {
      currentCheckInList.add({
        "name": action.created,
        "location": action.actionKey.smartspace,
        "type": action.type,
        "logoText": "https://smores-assets.s3-us-west-2.amazonaws.com/logo.png"
      });
    }
    // checkInListList = new List.from(checkInListList.reversed);
    setState(() {
      _HistoryPurchases();
    });
    return checkInListList;
  }

  void orderProducts() {
    orederedList.clear();
    for (Actionn action in askedShoppingList) {
      if (orederedList.containsKey(action.properties.product)) {
        var updateProduct = orederedList[action.properties.product];
        var amount = updateProduct['amount'];
        action.type == "Charge" ? ++amount : --amount;
        var price = updateProduct['price'];
        updateProduct.update('amount', (value) => amount);
        updateProduct.update('price', (value) => ++amount * price);
        orederedList.update(
            action.properties.product, (value) => updateProduct);
      } else {
        var newProduct = new Map();
        newProduct.putIfAbsent('title', () => action.properties.product);
        newProduct.putIfAbsent('amount', () => 1);
        newProduct.putIfAbsent(
            'price', () => action.properties.price); // action.properties.price
        orederedList.putIfAbsent(action.properties.product, () => newProduct);
      }
    }
  }

  Future<List> shoppingList(User user, Actionn fromAction, Actionn tillAction,
      String actionType) async {
    String checkInListPath;
    print("requestedID ===>>" + fromAction.actionKey.id);
    if (tillAction != null) {
      checkInListPath =
          'https://smoressmartspace.herokuapp.com/smartspace/actionsbetween/' +
              user.key.smartspace +
              '/' +
              user.key.email +
              '?type=' +
              actionType +
              '&from=' +
              fromAction.actionKey.id +
              '&to=' +
              tillAction.actionKey.id;
    } else {
      checkInListPath =
          'https://smoressmartspace.herokuapp.com/smartspace/actionsbetween/' +
              user.key.smartspace +
              '/' +
              user.key.email +
              '?type=' +
              actionType +
              '&from=' +
              fromAction.actionKey.id;
    }
    var result = await http.get(Uri.encodeFull(checkInListPath),
        headers: {"Accept": "application/json"});
    if (result.statusCode == 200) {
      var tagObjsJson = jsonDecode(result.body) as List;
      askedShoppingList =
          tagObjsJson.map((name) => new Actionn.fromJson(name)).toList();
    } else {
      Text("Failed");
    }
    return askedShoppingList;
  }
}
