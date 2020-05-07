import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:smores_app/models/action.dart';
import 'package:smores_app/models/element.dart';
import 'package:smores_app/models/user.dart';
import 'package:smores_app/widgets/app_drawer.dart';
import 'package:http/http.dart' as http;

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class NewElement extends StatefulWidget {
  User user;
  NewElement({Key key, this.user}) : super(key: key);

  static final String path = "lib/src/pages/lists/list2.dart";

  @override
  _NewElement createState() => _NewElement(user: this.user);
}

class _NewElement extends State<NewElement> {
  Elementt newElement = Elementt.empty();
  TextEditingController nameController = new TextEditingController();
  TextEditingController typeController = new TextEditingController();
  TextEditingController shelfController = new TextEditingController();
  TextEditingController amountController = new TextEditingController();
  TextEditingController priceController = new TextEditingController();

  Widget body;
  @override
  void initState() {
    super.initState();
    // checkInList(user);
  }

  final User user;

  _NewElement({this.user});

  var checkInListList = new List<Actionn>();
  var askedShoppingList = new List<Actionn>();
  var orederedList = new Map<String, Map>();

  final TextStyle dropdownMenuItem =
      TextStyle(color: Colors.black, fontSize: 18);
  final primary = Color(0xff23b574);
  final secondary = Color(0xff00bae2);

  TextEditingController customerEditingController = new TextEditingController();

  List<Map> currentCheckInList = [];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: AppDrawer(user: user),
      key: _scaffoldKey,
      backgroundColor: Color(0xfff0f0f0),
      body: Builder(
        builder: (context) => SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
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
                          },
                          icon: Icon(
                            Icons.menu,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Add New Product",
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
                buildList(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildList(BuildContext context) {
    final TextStyle titleStyle = TextStyle(
        color: Colors.black87, fontSize: 16.0, fontWeight: FontWeight.w500);
    final TextStyle trailingStyle = TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 16.0,
        fontWeight: FontWeight.bold);
    return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: SizedBox(
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(child: Text("Name", style: titleStyle)),
                      Expanded(
                        child: TextField(
                          style: trailingStyle,
                          textAlign: TextAlign.end,
                          decoration: InputDecoration(
                              hintText: 'Milk / Shirt / Bread / iPhone'),
                          controller: nameController,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: SizedBox(
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(child: Text("Type", style: titleStyle)),
                      Expanded(
                        child: TextField(
                          style: trailingStyle,
                          textAlign: TextAlign.end,
                          decoration: InputDecoration(
                              hintText: 'Food / Gadgets / Clothes'),
                          controller: typeController,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: SizedBox(
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(child: Text("Shelf", style: titleStyle)),
                      Expanded(
                        child: TextField(
                          style: trailingStyle,
                          textAlign: TextAlign.end,
                          decoration: InputDecoration(hintText: 'Shelf number'),
                          controller: shelfController,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: SizedBox(
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(child: Text("Amount", style: titleStyle)),
                      Expanded(
                        child: TextField(
                          style: trailingStyle,
                          textAlign: TextAlign.end,
                          decoration:
                              InputDecoration(hintText: 'Product Amount'),
                          controller: amountController,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: SizedBox(
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(child: Text("Price", style: titleStyle)),
                      Expanded(
                        child: TextField(
                          style: trailingStyle,
                          textAlign: TextAlign.end,
                          decoration:
                              InputDecoration(hintText: 'Product Price'),
                          controller: priceController,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                RaisedButton(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 20.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Colors.deepPurple.withOpacity(0.8),
                  textColor: Colors.white,
                  child: Text("Add Product"),
                  onPressed: () {
                    Elementt newElement = Elementt(
                        key: ElementKey(id: null, smartspace: null),
                        elementType: typeController.text,
                        name: nameController.text,
                        expired: false,
                        created: null,
                        creator: Creator(
                            email: user.key.email,
                            smartspace: user.key.smartspace),
                        latlng: Latlng(lat: 5.0, lng: 5.0),
                        elementProperties: ElementProperties(
                            amount: amountController.text,
                            price: priceController.text,
                            shelf: shelfController.text));
                    // print(json.encode(newElement));
                    postNewElement();
                  },
                ),
              ],
            )
          ],
        ));
  }

  Future<void> postNewElement() async {
    var path = 'https://smoressmartspace.herokuapp.com/smartspace/elements/' +
        user.key.smartspace +
        '/' +
        user.key.email;

    var result = await http.post(path,
        headers: {"Content-type": "application/json"},
        body: json.encode({
          "key": {"id": null, "smartspace": null},
          "elementType": typeController.text,
          "name": nameController.text,
          "expired": false,
          "created": null,
          "creator": {
            "smartspace": user.key.smartspace,
            "email": user.key.email
          },
          "latlng": {"lat": 0.0, "lng": 0.0},
          "elementProperties": {
            "Product": null,
            "Amount": int.parse(amountController.text),
            "Price": double.parse(priceController.text),
            "Shelf": int.parse(shelfController.text)
          }
        }));
    var convert = json.decode(result.body);
    print("Status ====>>> ${result.statusCode}");
    if (result.statusCode == 200) {
      newElement = Elementt.fromJson(convert);
      showInSnackBar("Element added succesfully");
    } else {
      showInSnackBar("Please check the fields and try again");
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text(value), duration: const Duration(seconds: 6)));
  }
}
